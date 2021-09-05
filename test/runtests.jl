using Tømmerknude
using Test

@testset "Tømmerknude.jl" begin
    @test Stick([0,1,2,0,0,0,0,0]) == reshape([1,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1],(2,4,2))
    #=
    2×4×2 Array{Int64, 3}:
    [:, :, 1] =
    1  1  0  1
    1  1  1  1
    
    [:, :, 2] =
    1  0  0  1
    1  1  1  1
    =#
    @test  Stick(1,[0,1,2,0,0,0,0,0]).key == reshape([1,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1],(2,4,2))
    ## TODO: Rotaions. The following test might not be correct:
    s1 = Stick(1, [0,1,2,0,0,0,0,0])
    s2 = Stick(2, [1,2,2,1,1,1,1,1])
    s3 = Stick(3, [2,1,1,2,0,1,1,0])
#    @test overlap(Slot(1,s1,1), Slot(3,s3,1)) == 2
    #    @test overlap(Slot(1,s1,1), Slot(2,s3,1)) == 0
    @test [Tømmerknude.voxels1(x) == Tømmerknude.voxels(x) for x in 1:6] == Bool[1, 1, 1, 1, 1, 1]
end
