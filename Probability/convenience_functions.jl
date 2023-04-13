Base.Dict{Symbol,V}(a::NamedTuple) where V =
        Dict{Symbol,V}(n=>v for (n,v) in zip(keys(a), values(a)))
Base.convert(::Type{Dict{Symbol,V}}, a::NamedTuple) where V =
                                                        Dict{Symbol,V}(a)
Base.isequal(a::Dict{Symbol,<:Any}, nt::NamedTuple) =
                                                length(a) == length(nt) &&
                                                all(a[n] == v for (n,v) in zip(keys(nt), values(nt)))