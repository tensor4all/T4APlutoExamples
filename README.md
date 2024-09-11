# T4APlutoExamples

This repository contains tutorials for tensor4all group written in Julia with Pluto notebook.

## Setup

- Install Julia

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
  [98e50ef6] JuliaFormatter v1.0.60
  [c3e4b0f8] Pluto v0.19.46
  [2fc8631c] PlutoSliderServer v0.3.31
```

## Launch Pluto Notebook

Let's run our Pluto notebook `pluto_notebooks/quantics1d.jl` for instance:

```sh
$ julia --project
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.5 (2024-08-27)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pluto; Pluto.run(notebook="pluto_notebooks/quantics1d.jl")
```

This will launch a Pluto notebook server immediately.

## How to learn more about Pluto.jl

See the official Pluto.jl tutorial [🔎 Basic Commands in Pluto](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%94%8E-Basic-Commands-in-Pluto) to learn more.

