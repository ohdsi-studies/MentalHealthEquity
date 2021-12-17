const pg_namespace =
    SQLTable(schema = :pg_catalog,
             name = :pg_namespace,
             columns = [:oid, :nspname])
const pg_class =
    SQLTable(schema = :pg_catalog,
             name = :pg_class,
             columns = [:oid, :relname, :relnamespace, :relkind])
const pg_attribute =
    SQLTable(schema = :pg_catalog,
             name = :pg_attribute,
             columns = [:attrelid, :attname, :attnum, :attisdropped])

Introspect(; schema = :public) =
    FunSQL.From(pg_class) |>
    FunSQL.Where(FunSQL.Fun.in(FunSQL.Get.relkind, "r", "v")) |>
    FunSQL.Where(FunSQL.Fun.has_table_privilege(FunSQL.Get.oid, "SELECT")) |>
    FunSQL.Join(FunSQL.From(pg_namespace) |>
         FunSQL.Where(FunSQL.Get.nspname .== String(schema)) |>
         FunSQL.As(:nsp),
         on = FunSQL.Get.relnamespace .== FunSQL.Get.nsp.oid) |>
    FunSQL.Join(FunSQL.From(pg_attribute) |>
         FunSQL.Where(FunSQL.Fun.and(FunSQL.Get.attnum .> 0, FunSQL.Fun.not(FunSQL.Get.attisdropped))) |>
         FunSQL.As(:att),
         on = FunSQL.Get.oid .== FunSQL.Get.att.attrelid) |>
    FunSQL.Order(FunSQL.Get.nsp.nspname, FunSQL.Get.relname, FunSQL.Get.att.attnum) |>
    FunSQL.Select(FunSQL.Get.nsp.nspname, FunSQL.Get.relname, FunSQL.Get.att.attname)

function introspect(conn; schema = :public)
    q = Introspect(schema = schema)
    sql = render(q, dialect = :postgresql)
    ts = Pair{Symbol, FunSQL.SQLTable}[]
    s = n = nothing
    cs = Symbol[]
    rows = Tables.rows(LibPQ.execute(conn, sql))
    for (nspname, relname, attname) in rows
        s′ = Symbol(nspname)
        n′ = Symbol(relname)
        c′ = Symbol(attname)
        if s === s′ && n === n′
            push!(cs, c′)
        else
            if s !== nothing
                t = SQLTable(schema = s, name = n, columns = cs)
                push!(ts, n => t)
            end
            s = s′
            n = n′
            cs = [c′]
        end
    end
    if !isempty(cs)
        t = SQLTable(schema = s, name = n, columns = cs)
        push!(ts, n => t)
    end
    return NamedTuple(ts)
end

"""
	unzip(file::String, output_path::String)

Unzip a zipped archive.

# Arguments

- `file` - a zip archive to unzip.
- `output_path` - output directory where unzipped files are placed.

"""
function unzip(file::String, output_path::String)
    fileFullPath = isabspath(file) ? file : joinpath(pwd(), file)
    basePath = dirname(fileFullPath)
    outPath = (
        output_path == "" ? basePath :
        (isabspath(output_path) ? output_path : joinpath(pwd(), output_path))
    )
    isdir(outPath) ? "" : mkdir(outPath)
    zarchive = ZipFile.Reader(fileFullPath)
    for f in zarchive.files
        fullFilePath = joinpath(outPath, f.name)
        if (endswith(f.name, "/") || endswith(f.name, "\\"))
            mkdir(fullFilePath)
        else
            write(fullFilePath, read(f))
        end
    end
    close(zarchive)
end


"""
	download_dataset(; dataset_names = [])

# Arguments

- `dataset_names` - list of data sets to download.  Downloads all available datasets if no list is provided. Requires internet connection.

"""
function download_dataset(; dataset_names = [])
    if dataset_names |> isempty
        for dataset in DATASETS
            path = joinpath(datadir("exp_raw"), dataset.name)
            if !ispath(path)
                mkpath(path)
                dl_file = download(dataset.url, datadir(path, dataset.name * ".zip"))
                unzip(dl_file, path)
                rm(dl_file)
            else
                @warn "Path for $(dataset.name) already exists. Skipping download."
            end
        end
    else
        for name in dataset_names
            for dataset in DATASETS
                if name == dataset.name
                    path = joinpath(datadir("exp_raw"), dataset.name)
                    if !ispath(path)
                        mkpath(path)
                        dl_file =
                            download(dataset.url, datadir(path, dataset.name * ".zip"))
                        unzip(dl_file, path)
                        rm(dl_file)
                    else
                        @warn "Path for $(dataset.name) already exists. Skipping download."
                    end
                end
            end
        end
    end
end

export introspect
export unzip, download_dataset
