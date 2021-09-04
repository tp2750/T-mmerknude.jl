module Tømmerknude

export Stick, Slot, overlap

struct Stick
    id::Int64
    key::Array{Int64,3}
    orientation::Int64 
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
    Stick(id, Stick(v),0)
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

function overlap(x::Int64,y::Int64)
    ## Orientation of slots as in figure toemmerknude_slots.jpg i, j, k
    local res = ((Int64[],Int64[]))
    if (x == 1)
        if ( y == 2 )
            res = ((Int64[],Int64[])) ## no overlap
        elseif (y == 3)
            res = ([[2,2,1],[1,2,1],[1,3,1],[2,3,1]], ## in Slot 1
                   [[2,3,2],[2,4,2],[2,3,1],[2,4,1]]) ## in Slot 3
        end
    end
    res
end

"""
    A Slot contains a Stick in a given rotation.
    The `overlap` between 2 Slots is the sum of the voxels that are filled by both sticks
"""
struct Slot
    id::Int64
    stick::Stick
    rotation::Int64
end

function overlap(s1::Slot, s2::Slot)
    ## TODO: rotation
    collisions = map(overlap(s1.id, s2.id)...) do x,y
        s1.stick.key[x...] == 1 & s2.stick.key[y...] == 1
    end
    sum(collisions)
end



end
