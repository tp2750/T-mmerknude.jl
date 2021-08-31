using Tømmerknude
using Documenter

DocMeta.setdocmeta!(Tømmerknude, :DocTestSetup, :(using Tømmerknude); recursive=true)

makedocs(;
    modules=[Tømmerknude],
    authors="Thomas Poulsen",
    repo="https://github.com/tp2750/Tømmerknude.jl/blob/{commit}{path}#{line}",
    sitename="Tømmerknude.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tp2750.github.io/Tømmerknude.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/Tømmerknude.jl",
)
