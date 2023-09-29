const where_bisect = 0.49609375

"""
    bisect(X::Interval, α=0.49609375)

Split the interval `X` at position α; α=0.5 corresponds to the midpoint.
Returns a tuple of the new intervals.
"""
function bisect(X::Interval{T}, α=where_bisect) where {T<:NumTypes}
    @assert 0 ≤ α ≤ 1

    m = scaled_mid(X, α)

    return (unsafe_interval(T, inf(X), m), unsafe_interval(T, m, sup(X)))
end

"""
    bisect(X::IntervalBox, α=0.49609375)

Bisect the `IntervalBox` `X` at position α ∈ [0,1] along its longest side.
"""
function bisect(X::IntervalBox, α=where_bisect)
    i = argmax(diam.(X))  # find longest side

    return bisect(X, i, α)
end

"""
    bisect(X::IntervalBox, i::Integer, α=0.49609375)

Bisect the `IntervalBox` in side number `i`.
"""
function bisect(X::IntervalBox, i::Integer, α=where_bisect)

    x1, x2 = bisect(X[i], α)

    X1 = setindex(X, x1, i)
    X2 = setindex(X, x2, i)

    return (X1, X2)
end

# struct that allows to iterate over all the intervals generated by spliting a interval.
struct IntervalRange{T, S<:Integer} <: AbstractRange{T}
    start::T
    stop::T
    n::S
end

function Base.length(X::IntervalRange) return X.n end

function Base.first(X::IntervalRange) 
    interval(X.start, X.start + step(X))
end

function Base.step(X::IntervalRange) 
    (X.stop - X.start)/X.n 
end

function Base.last(X::IntervalRange) 
    interval(X.stop - step(X), X.stop)
end

function Base.getindex(X::IntervalRange, i::Integer)
    @assert i<=X.n
    return interval(X.start + (i-1)*step(X), X.start + i*step(X))
end
# allows the use of x in X
function Base.in(x::Interval{T}, X::IntervalRange{T}) where {T<:Real} 
    for y in X
        if x ⊆ y
            return true
        end
    end
    return false
end

"""
    mince(x::Interval, n)

Split `x` in `n` intervals of the same diameter, which are returned
as a vector.
"""
function IntervalArithmetic.mince(x::Interval, n::I) where {I <: Integer}
    IntervalRange(x.lo, x.hi, n)
end

"""
    mince(x::IntervalBox, n)

Split `x` in `n` intervals in each dimension of the same diameter. These
intervals are combined in all possible `IntervalBox`-es, which are returned
as a iterable struct.
"""
@generated function mince(x::IntervalBox{N,T}, n) where {N,T<:NumTypes}
    quote
        nodes_matrix = Array{Interval{T},2}(undef, n, N)
        for i in 1:N
            nodes_matrix[1:n,i] .= mince(x[i], n)
        end

        nodes = IntervalBox{$N,T}[]
        Base.Cartesian.@nloops $N i _->(1:n) begin
            Base.Cartesian.@nextract $N ival d->nodes_matrix[i_d, d]
            ibox = Base.Cartesian.@ncall $N IntervalBox ival
            push!(nodes, ibox)
        end
        nodes
    end
end
