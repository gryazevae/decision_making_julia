include("convenience_functions.jl")
include("factors.jl")

using Graphs

struct BayesianNetwork
    vars::Vector{Variable}
    factors::Vector{Factor}
    graph::SimpleDiGraph{Int64}
end

function probability(bn::BayesianNetwork, assignment)
    subassignment(ϕ) = select(assignment, variablenames(ϕ))
    probability(ϕ) = get(ϕ.table, subassignment(ϕ), 0.0)
    return prod(probability(ϕ) for ϕ in bn.factors)
end


# Example from book. Сommented out so as not to be executed 
# when the file is included by include

B = Variable(:b, 2); S = Variable(:s, 2)
E = Variable(:e, 2)
D = Variable(:d, 2); C = Variable(:c, 2)
vars = [B, S, E, D, C]
factors = [
        Factor([B], FactorTable((b=1,) => 0.99, (b=2,) => 0.01)),
        Factor([S], FactorTable((s=1,) => 0.98, (s=2,) => 0.02)),
        Factor([E,B,S], FactorTable(
            (e=1,b=1,s=1) => 0.90, (e=1,b=1,s=2) => 0.04,
            (e=1,b=2,s=1) => 0.05, (e=1,b=2,s=2) => 0.01,
            (e=2,b=1,s=1) => 0.10, (e=2,b=1,s=2) => 0.96,
            (e=2,b=2,s=1) => 0.95, (e=2,b=2,s=2) => 0.99)),
        Factor([D, E], FactorTable(
            (d=1,e=1) => 0.96, (d=1,e=2) => 0.03,
            (d=2,e=1) => 0.04, (d=2,e=2) => 0.97)),
        Factor([C, E], FactorTable(
            (c=1,e=1) => 0.98, (c=1,e=2) => 0.01,
            (c=2,e=1) => 0.02, (c=2,e=2) => 0.99))
]
graph = SimpleDiGraph(5)
add_edge!(graph, 1, 3); add_edge!(graph, 2, 3)
add_edge!(graph, 3, 4); add_edge!(graph, 3, 5)
bn = BayesianNetwork(vars, factors, graph)