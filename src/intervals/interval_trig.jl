
#----- From here on, NEEDS TESTING ------


const float_pi_interval = @floatinterval(pi)
const big_pi_interval = @interval(pi)

get_pi(::Type{BigFloat}) = big_pi_interval
get_pi(::Type{Float64})  = float_pi_interval

half_pi{T}(::Type{T}) = get_pi(T) / 2
two_pi{T}(::Type{T})  = get_pi(T) * 2

half_pi(x::FloatingPoint) = half_pi(typeof(x))


function find_quartiles(x::FloatingPoint)
    temp = x / half_pi(x)
    (ifloor(temp.lo), ifloor(temp.hi))
end

function sin{T<:Real}(a::Interval{T})

    whole_range = Interval(-one(T), one(T))

    diam(a) >= 3*half_pi(T).lo && return whole_range

    lo_quartile = minimum(find_quartiles(a.lo))
    hi_quartile = maximum(find_quartiles(a.hi))

    lo_quartile = mod(lo_quartile, 4)
    hi_quartile = mod(hi_quartile, 4)

    # Different cases depending on the two quartiles:
    if lo_quartile == hi_quartile # Interval limits in the same quartile
        #hi_quartile_true > lo_quartile_true && return whole_range
        return @round(T, sin(a.lo), sin(a.hi))

    elseif lo_quartile==3 && hi_quartile==0
        return @round(T, sin(a.lo), sin(a.hi))

    elseif lo_quartile==1 && hi_quartile==2
        return @round(T, sin(a.hi), sin(a.lo))

    elseif ( lo_quartile == 0 || lo_quartile==3 ) && ( hi_quartile==1 || hi_quartile==2 )
        return @round(T, min(sin(a.lo), sin(a.hi)), one(T))

    elseif ( lo_quartile == 1 || lo_quartile==2 ) && ( hi_quartile==3 || hi_quartile==0 )
        return @round(T, -one(T), max(sin(a.lo), sin(a.hi)))

    elseif ( lo_quartile == 0 && hi_quartile==3 ) || ( lo_quartile == 2 && hi_quartile==1 )
        return whole_range
    else
        # This should be never reached!
        error(string("SOMETHING WENT WRONG in sin with argument $a; this should have never been reached.") )
    end
end


cos{T<:Real}(a::Interval{T}) = sin(half_pi(T) - a)

#tan{T<:Real}(a::Interval{T}) = sin(a) / cos(a)


# function cos{T<:Real}(a::Interval{T})
#     half_pi = convert(T, pi) / 2
#     two_pi = convert(T, pi) * 2
#     rangeCos = @round(T, -one(T), one(T))

#     # Checking the specific case
#     diam(a) >= two_pi && return rangeCos

#     # Limits within 1 full period of sin(x)
#     # Abbreviations
#     lo = mod(a.lo, two_pi)
#     hi = mod(a.hi, two_pi)
#     lo_quartile = floor( lo / half_pi )
#     hi_quartile = floor( hi / half_pi )

#     # 20 different cases
#     if lo_quartile == hi_quartile # Interval limits in the same quartile
#         lo > hi && return rangeCos
#         return @round(T, cos(a.hi), cos(a.lo))

#     elseif lo_quartile == 2 && hi_quartile==3
#         return @round(T, cos(a.lo), cos(a.hi))

#     elseif lo_quartile == 0 && hi_quartile==1
#         return @round(T, cos(a.hi), cos(a.lo))

#     elseif ( lo_quartile == 2 || lo_quartile==3 ) && ( hi_quartile==0 || hi_quartile==1 )
#         return @round(T, min(cos(a.lo), cos(a.hi)), one(T))

#     elseif ( lo_quartile == 0 || lo_quartile==1 ) && ( hi_quartile==2 || hi_quartile==3 )
#         return @round(T, -one(T), max(cos(a.lo), cos(a.hi)))

#     elseif ( lo_quartile == 3 && hi_quartile==2 ) || ( lo_quartile == 1 && hi_quartile==0 )
#         return rangeCos
#     else
#         # This should be never reached!
#         error(string("SOMETHING WENT WRONG in cos.\nThis should have never been reached") )
#     end
# end


function tan{T<:Real}(a::Interval{T})
    whole_range = Interval{T}(-Inf, Inf)


    diam(a) >= get_pi(T).lo && return whole_range

    lo_quartile = minimum(find_quartiles(a.lo))
    hi_quartile = maximum(find_quartiles(a.hi))

    lo_quartile_mod = mod(lo_quartile, 2)
    hi_quartile_mod = mod(hi_quartile, 2)

    if lo_quartile_mod == 0 && hi_quartile_mod == 1
        return whole_range

    elseif lo_quartile_mod == hi_quartile_mod && hi_quartile > lo_quartile
        return whole_range
    end

    @round(T, tan(a.lo), tan(a.hi))

    # could return two disjoint intervals:
    # disjoint2 = Interval{T}( I.lo, Inf )
    # disjoint1 = Interval{T}( -Inf, I.hi)
    # info(string("The resulting interval is disjoint:\n", disjoint1, "\n", disjoint2,
    #            "\n The hull of the disjoint subintervals is considered:\n", rangeTan))
#     return whole_range
end

