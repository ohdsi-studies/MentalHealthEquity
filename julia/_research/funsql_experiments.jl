using DrWatson
@quickactivate "MentalHealthEquity"

# using DataFrames
using DBInterface
# using FunSQL: From, Fun, Get, Join, Select, SQLTable, Where
using LibPQ

const conn = ODBC.Connection(ENV["DSN"])
const db = introspect(conn)

const conn = LibPQ.Connection("port=5434, user=synpuf_v5")

const person = SQLTable(:person, columns = [:person_id, :year_of_birth, :location_id])
const location = SQLTable(:location, columns = [:location_id, :city, :state])

# q =
    # From(person) |>
    # Where(Fun.between(Get.year_of_birth, 1930, 1940)) |>
    # Join(
        # :location => From(location) |> Where(Get.state .== "IL"),
        # on = Get.location_id .== Get.location.location_id,
    # ) |>
    # Select(Get.person_id, :age => 2020 .- Get.year_of_birth)


# sql = FunSQL.render(q, dialect = :postgresql)
# res = LibPQ.execute(conn, sql)
# DataFrame(res)

using FunSQL: SQLTable, As, Define, From, Fun, Get, Join, Order, Select, Where, render, Limit
using Tables

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
    From(pg_class) |>
    Where(Fun.in(Get.relkind, "r", "v")) |>
    Where(Fun.has_table_privilege(Get.oid, "SELECT")) |>
    Join(From(pg_namespace) |>
         Where(Get.nspname .== String(schema)) |>
         As(:nsp),
         on = Get.relnamespace .== Get.nsp.oid) |>
    Join(From(pg_attribute) |>
         Where(Fun.and(Get.attnum .> 0, Fun.not(Get.attisdropped))) |>
         As(:att),
         on = Get.oid .== Get.att.attrelid) |>
    Order(Get.nsp.nspname, Get.relname, Get.att.attnum) |>
    Select(Get.nsp.nspname, Get.relname, Get.att.attname)

function introspect(conn; schema = :public)
    q = Introspect(schema = schema)
    sql = render(q, dialect = :postgresql)
    ts = Pair{Symbol, SQLTable}[]
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

schema_info = introspect(conn; schema = :synpuf5)
person = schema_info[:person]
location = schema_info[:location]

q =
    From(person) |>
    Where(Fun.between(Get.year_of_birth, 1930, 1940)) |>
    Define(:age => 2020 .- Get.year_of_birth) |>
    Join(
	:location => From(location) |> Where(Get.state .== "IL"),
	on = Get.location_id .== Get.location.location_id, 
    )

sql = render(q, dialect = :postgresql)
res = LibPQ.execute(conn, sql)
test = DataFrame(res)


