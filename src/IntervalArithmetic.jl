module IntervalArithmetic

import CRlibm
import FastRounding
import RoundingEmulator

using Markdown
using SetRounding
using EnumX

import Base:
    +, -, *, /, //, muladd, fma,
    ^, sqrt, exp, log, exp2, exp10, log2, log10, inv, cbrt, hypot,
    zero, one, eps, typemin, typemax, abs, abs2, min, max,
    rad2deg, deg2rad,
    sin, cos, tan, cot, csc, sec, asin, acos, atan, acot, sinpi, cospi, sincospi,
    sinh, cosh, tanh, coth, csch, sech, asinh, acosh, atanh, acoth,
    in, union, intersect, issubset, isempty, isdisjoint,
    convert,
    BigFloat, float, big,
    floor, ceil, trunc, sign, round, copysign, flipsign, signbit,
    expm1, log1p,
    precision,
    isfinite, isinteger, isnan, isinf, iszero,
    abs, abs2,
    show,
    parse, hash

import Base.MPFR: MPFRRoundingMode
import Base.MPFR: MPFRRoundUp, MPFRRoundDown, MPFRRoundNearest, MPFRRoundToZero, MPFRRoundFromZero

export
    Interval, interval, ±, @I_str,
    diam, radius, mid, scaled_mid, mag, mig, hull,
    emptyinterval, isempty, isinterior,
    precedes, strictprecedes, ≺, ⊂, ⊃, contains_zero, isthinzero,
    isweaklyless, isstrictless, overlap, Overlap,
    ≛, setdiffinterval,
    entireinterval, isentire, nai, isnai, isthin, iscommon, isatomic,
    inf, sup, bounds, bisect, mince,
    dist,
    midpoint_radius,
    RoundTiesToEven, RoundTiesToAway,
    IntervalRounding,
    cancelminus, cancelplus, isbounded, isunbounded,
    pow, extended_div, nthroot,
    setformat

## Decorations
export
    decoration, DecoratedInterval,
    com, dac, def, trv, ill

function __init__()
    setrounding(BigFloat, RoundNearest)
end

function Base.setrounding(f::Function, ::Type{Rational{T}},
    rounding_mode::RoundingMode) where T
    return setrounding(f, float(Rational{T}), rounding_mode)
end

## Includes

include("intervals/intervals.jl")

include("bisect.jl")
include("decorations/decorations.jl")

include("rand.jl")
include("parsing.jl")
include("display.jl")
include("symbols.jl")

end
