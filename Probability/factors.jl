Base.Dict{Symbol,V}(a::NamedTuple) where V =
        Dict{Symbol,V}(n=>v for (n,v) in zip(keys(a), values(a)))
Base.convert(::Type{Dict{Symbol,V}}, a::NamedTuple) where V =
                                                        Dict{Symbol,V}(a)
Base.isequal(a::Dict{Symbol,<:Any}, nt::NamedTuple) =
                                                length(a) == length(nt) &&
                                                all(a[n] == v for (n,v) in zip(keys(nt), values(nt)))

struct Variable
    name::Symbol
    r::Int # number of possible values
end

const Assignment = Dict{Symbol,Int}
const FactorTable = Dict{Assignment,Float64}

struct Factor
    vars::Vector{Variable}
    table::FactorTable
end

variablenames(ϕ::Factor) = [var.name for var in ϕ.vars]
select(a::Assignment, varnames::Vector{Symbol}) =
                    Assignment(n=>a[n] for n in varnames)

function assignments(vars::AbstractVector{Variable})
    names = [var.name for var in vars]
    return vec([Assignment(n=>v for (n,v) in zip(names, values))
                for values in product((1:v.r for v in vars)...)])
end

function normalize!(ϕ::Factor)
    z = sum(p for (a,p) in ϕ.table)
    for (a,p) in ϕ.table
        ϕ.table[a] = p/z
    end
    return ϕ
end

# requires convenience functions from appendix G.5
X = Variable(:x, 2)
Y = Variable(:y, 2)
Z = Variable(:z, 2)
ϕ = Factor([X, Y, Z], FactorTable(
                                (x=1, y=1, z=1) => 0.08, (x=1, y=1, z=2) => 0.31,
                                (x=1, y=2, z=1) => 0.09, (x=1, y=2, z=2) => 0.37,
                                (x=2, y=1, z=1) => 0.01, (x=2, y=1, z=2) => 0.05,
                                (x=2, y=2, z=1) => 0.02, (x=2, y=2, z=2) => 0.07,
                                ))