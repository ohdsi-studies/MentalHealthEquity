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

export introspect
