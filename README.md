# T4APlutoExamples

[![Export Pluto notebooks](https://github.com/tensor4all/T4APlutoExamples/actions/workflows/ExportPluto.yaml/badge.svg)](https://github.com/tensor4all/T4APlutoExamples/actions/workflows/ExportPluto.yaml)

[![CI](https://github.com/tensor4all/T4APlutoExamples/actions/workflows/CI.yaml/badge.svg)](https://github.com/tensor4all/T4APlutoExamples/actions/workflows/CI.yaml)

[![pages-build-deployment](https://github.com/tensor4all/T4APlutoExamples/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/tensor4all/T4APlutoExamples/actions/workflows/pages/pages-build-deployment)

Website: https://tensor4all.org/T4APlutoExamples/pluto_notebooks/


## Description

[This repository](https://github.com/Tensor4All/T4APlutoExamples) contains tutorials for [Tensor4All group](https://tensor4all.org/) written in Julia with Pluto notebook. Pre-computed notebooks can be found at [this page](https://tensor4all.org/T4APlutoExamples/pluto_notebooks/).

## How to open Pluto notebooks locally

To open and run Pluto notebooks, you will need to install Julia. We recommend using [juliaup](https://github.com/JuliaLang/juliaup) to install Julia, following the instructions provided on the [official Julia website](https://julialang.org/downloads/).

```sh
$ git clone https://github.com/tensor4all/T4APlutoExamples.git
$ cd T4APlutoExamples
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.5 (2024-08-27)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pkg; Pkg.activate("."); Pkg.instantiate()
julia> Pkg.status()
Status `~/tensor4all/T4APlutoExamples/Project.toml`
  [3bbe58f8] ExampleJuggler v2.0.1
  [9136182c] ITensors v0.6.18
  [98e50ef6] JuliaFormatter v1.0.60
  [b964fa9f] LaTeXStrings v1.3.1
  [91a5bcdd] Plots v1.40.8
  [c3e4b0f8] Pluto v0.19.46
  [2fc8631c] PlutoSliderServer v0.3.31
  [7f904dfe] PlutoUI v0.7.60
  [87f76fb3] Quantics v0.3.8
  [634c7f73] QuanticsGrids v0.3.2
  [b11687fd] QuanticsTCI v0.7.0
  [9f0aa9f4] TCIITensorConversion v0.1.4
  [b261b2ec] TensorCrossInterpolation v0.9.12
  [d6f4376e] Markdown
```

## Launch Pluto Notebook

Let's run our Pluto notebook `pluto_notebooks/quantics1d.jl` for instance. Open your terminal. Then start Julia REPL:

```sh
$ julia
```

Next, run `using Pkg; Pkg.activate("."); using Pluto; Pluto.run(notebook="pluto_notebooks/quantics1d.jl")` in your Julia REPL:

```julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.5 (2024-08-27)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pkg; Pkg.activate("."); using Pluto; Pluto.run(notebook="pluto_notebooks/quantics1d.jl")
```

This will launch a Pluto notebook server immediately.

### Tips 💡

You can also run Pluto notebooks on the web using the `download` function. Copy and paste the following into your Julia REPL:

```julia
using Pkg; Pkg.activate(temp=true); Pkg.add("Pluto")
BASE_URL = "https://raw.githubusercontent.com/tensor4all/T4APlutoExamples/refs/heads/main/pluto_notebooks/"
notebook = "quantics1d.jl"
url = joinpath(BASE_URL, notebook)
using Pluto; Pluto.run(notebook=download(url))
```

## How to learn more about Pluto.jl

See the official Pluto.jl tutorial [🔎 Basic Commands in Pluto](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%94%8E-Basic-Commands-in-Pluto) to learn more.
