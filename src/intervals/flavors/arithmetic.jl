"""
    zero_times_infinity(::Type{AbstractFlavor})

Return the result of zero times positive infinity for the given flavor.
"""
zero_times_infinity(::Type{F}) where {T, F<:SetBasedInterval{T}} = zero(T)


"""
    inv_of_zero(F)

Inverse of the interval containing only `0`.
"""
inv_of_zero(::Type{F}) where {F<:SetBasedInterval} = emptyinterval(F)

"""
    div_zero_by(F, x)

Division of exactly `0` by `x`.
"""
div_zero_by(::Type{F}, x) where {F<:SetBasedInterval} = zero(F)