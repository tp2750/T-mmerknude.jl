module Tømmerknude

export Stick,  overlap, voxels, stick_set, rotate, flip, sticks_simple, solve, print_solution

mutable struct Stick
    id::Int64
    key::Array{Int64,3}
    rotation::Int64
    flip::Int64
end

"""
    Generator based on signature from OpenScad file
"""
function Stick(v::Vector{T}) where T <:Int
    @assert length(v) == 8
    key_v = [
        v[1] == 2 ? 0 : 1 ,
        v[5] == 2 ? 0 : 1 ,
        v[2] == 2 ? 0 : 1 ,
        v[6] == 2 ? 0 : 1 ,
        v[3] == 2 ? 0 : 1 ,
        v[7] == 2 ? 0 : 1 ,
        v[4] == 2 ? 0 : 1 ,
        v[8] == 2 ? 0 : 1 ,

        v[1] == 0 ? 1 : 0 ,
        v[5] == 0 ? 1 : 0 ,
        v[2] == 0 ? 1 : 0 ,
        v[6] == 0 ? 1 : 0 ,
        v[3] == 0 ? 1 : 0 ,
        v[7] == 0 ? 1 : 0 ,
        v[4] == 0 ? 1 : 0 ,
        v[8] == 0 ? 1 : 0 ,
    ]
    reshape(key_v,(2,4,2))
end

function Stick(id::T, v::Vector{T}) where T <:Int
    Stick(id, Stick(v),0,0)
end

## Generate the 6 sticks
stick_set = [
    Stick(1, [0,1,2,0,0,0,0,0]),
    Stick(2, [1,2,2,1,1,1,1,1]),
    Stick(3, [2,1,1,2,0,1,1,0]),
    Stick(4, [0,2,1,0,0,1,1,0]),
    Stick(5, [2,1,2,2,0,0,1,0]),
    Stick(6, [1,2,2,1,1,1,0,0]),
]

## Simple form
sticks_simple = [
    Stick(1, [0,0,0,0,0,0,0,0]),
    Stick(2, [2,2,2,2,0,0,0,0]),
    Stick(3, [2,2,2,2,0,0,0,0]),
    Stick(4, [1,2,2,1,1,1,1,1]),
    Stick(5, [1,2,2,1,1,1,1,1]),
    Stick(6, [2,0,0,2,0,0,0,0]),
]


function rotate(stick::Stick)
    ## Rotate clockwise around long axes
    Stick(stick.id,mapslices(rotr90, stick.key; dims=(1,3)), (stick.rotation + 1) % 4, stick.flip )
end

function flip(stick::Stick)
    ## Flip over the long axes
    Stick(stick.id,mapslices(rot180, stick.key;dims=(2,3)), stick.rotation, (stick.flip + 1) % 2)
end

function overlap(s1::Int64,s2::Int64)
    ## Overlapping voxes between slots s1, s2. Just add the matrices!
    voxels(s1) .+ voxels(s2) .> 1
end


"""
    A Position is a slot containing a Stick in a given orientation.
    The `overlap` between 2 Slots is the sum of the voxels that are filled by both sticks
"""
struct Position
    slot::Int64
    stick::Stick
end

function overlap(p1::Position, p2::Position; debug=false)
    res = voxels(p1.slot, p1.stick.key) .+  voxels(p2.slot, p2.stick.key) .>1
    if(debug)
        return(res)
    end
    sum(res)
end

function overlap(pos::Vector{Position}; debug=false)
    res = sum([voxels(p.slot, p.stick.key) for p in pos]) .> 1
    if(debug)
        return(res)
    end
    sum(res)
end



function voxels1(slot::Int64)
    s = zeros(Int64,4,4,4)
    if (slot == 1)
        s[1:2,2:3,1:4] .= 1
    elseif (slot == 2)
        s[3:4,2:3,1:4] .= 1
    elseif (slot == 3)
        s[1:4,1:2,2:3] .= 1
    elseif (slot == 4)
        s[1:4,3:4,2:3] .= 1
    elseif (slot == 5)
        s[2:3,1:4,1:2] .= 1
    elseif (slot == 6)
        s[2:3,1:4,3:4] .= 1
    else
        error("There is only 6 slots!")
    end
    s
end


function voxels(slot::Int64, key = 1)
    ## voxels occupied by stick with key = stick.key in slot 
    local s = zeros(Int64,4,4,4)
    if (slot == 1)
        s[1:2,1:4,2:3] .= key
        s =  mapslices(rotr90,s; dims=(2,3))
    elseif (slot == 2)
        s[3:4,1:4,2:3] .= key
        s =  mapslices(rotr90,s; dims=(2,3))
    elseif (slot == 3)
        s[1:2,1:4,2:3] .= key
        s =  mapslices(rotl90,s; dims=(1,2))
    elseif (slot == 4)
        s[3:4,1:4,2:3] .= key
        s =  mapslices(rotl90,s; dims=(1,2))
    elseif (slot == 5)
        s[2:3,1:4,1:2] .= key
    elseif (slot == 6)
        s[2:3,1:4,3:4] .= key
    else
        error("There is only 6 slots!")
    end
    s
end

function print_solution(solution::Vector{Position})
    sum([voxels(p) .* p.stick.id for p in solution])
end

function voxels(pos::Position)
     voxels(pos.slot, pos.stick.key)
end


Base.copy(s::Stick) = Stick(s.id, s.key, s.rotation, s.flip)

function solve(set::Vector{Stick})
    return solve(set, Position[])
end

function solve(set::Vector{Stick}, placed::Vector{Position})
    if length(set) == 0
        return [placed]
    end

    solutions = []

    stick = copy(set[1])
    rest = copy(set[2:end])

    for slot in 1:6 # Loop over slots
        if ! any(slot .== [p.slot for p in placed]) # Check if slot isn't occupied
            for flips in 0:1 # Loop over rotations
                stick = flip(stick)
                for rot in 1:4
                    stick = rotate(stick)
                    # Note: efter 4 rotationer er vi tilbage til udgangspunktet, så vi er klar til næste ydre loop. I.e. vi behøver ikke at kopiere stick og rotere hhv 1, 2, 3 og 4 gange, vi kan bare rotere en enkelt gang hver iteration.
                    if overlap(vcat(placed, [Position(slot, stick)])) == 0
                        append!(solutions, solve(rest, vcat(placed, [Position(slot, stick)])))
                    end
                end
            end
        end
    end
    return solutions
end

# function solve(set::Vector{Stick})
    
# end


# ## Leftovers
# function overlap1(x::Int64,y::Int64)
#     ## Orientation of slots as in figure toemmerknude_slots.jpg i, j, k
#     local res = ((Int64[],Int64[]))
#     if (x == 1)
#         if ( y == 2 )
#             res = ((Int64[],Int64[])) ## no overlap
#         elseif (y == 3)
#             res = ([[2,2,1],[1,2,1],[1,3,1],[2,3,1]], ## in Slot 1
#                    [[2,3,2],[2,4,2],[2,3,1],[2,4,1]]) ## in Slot 3
#         end
#     end
#     res
# end
#
# struct Slot
#     id::Int64
#     stick::Stick
#     rotation::Int64
# end
#
# function overlap(s1::Slot, s2::Slot)
#     ## TODO: rotation
#     collisions = map(overlap1(s1.id, s2.id)...) do x,y
#         s1.stick.key[x...] == 1 & s2.stick.key[y...] == 1
#     end
#     sum(collisions)
# end
#
## README
# We still need to translate into local coordinates of a rotated stick in a slot

# The `overlap` function returns the voxes that overlap between two slots.
# The numbering of voxes in the know is the same as on the sticks: i,j,k, 
# where the orientation is given by the following figure:



end

