# Tømmerknude

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tp2750.github.io/Tømmerknude.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tp2750.github.io/Tømmerknude.jl/dev)
[![Build Status](https://github.com/tp2750/Tømmerknude.jl/workflows/CI/badge.svg)](https://github.com/tp2750/Tømmerknude.jl/actions)
[![Coverage](https://codecov.io/gh/tp2750/Tømmerknude.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/tp2750/Tømmerknude.jl)

Based on this article:
https://ing.dk/artikel/kan-du-lose-gordiske-tommerknude-249110

# Plan

* The knot consists of 4x4x4 voxels.
* A stick has 2x2x4 voxels inside the knot.
* A Stick has a unique "key" describing which voxels are filled and empty
* The knot has 6 slots. 
* A stick is assigned a slot and a rotation.
* A configuration is an assignment of slot and rotation to all 6 sticks
* A valid configuration has all 6 sticks assigned to slots and rotations so that there are no overlaps in the knot

# Example:

The simplest stick has key:

```{julia}
julia> reshape([1,1,1,1,0,1,1,1,1,1,0,1,0,1,1,1],(2,4,2))
2×4×2 Array{Int64, 3}:
[:, :, 1] =
 1  1  0  1
 1  1  1  1

[:, :, 2] =
 1  0  0  1
 1  1  1  1
```

The indexes run: down, across, forward as in an array.


# Finding overlap

The `overlap` function returns the voxes that overlap between two slots.
The numbering of voxes in the know is the same as on the sticks: i,j,k, 
where the orientation is given by the following figure:

![knot_slots](assets/toemmerknude_slots.jpg)

