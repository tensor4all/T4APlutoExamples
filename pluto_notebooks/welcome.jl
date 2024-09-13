### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 5cf76073-4a83-4d0d-aac0-843dbbafc027
md"""
# T4A Julia Tutorials

This documentation provides a comprehensive tutorials/examples
on quantics and tensor cross interpolation (TCI) and their combinations (QTCI).
These technologies allow us to reveal low-rank tensor network representation (TNR) hidden in data or a function,
and perform computation such as Fourier transform and convolution.
Please refer [xfacpaper](https://arxiv.org/abs/2407.02454) for a more detailed introduction of these concepts.

The T4A group hosts various Julia libraries for performing such operations.
The folowing list is given in the order of low-level to high-level libraries:

- [TensorCrossInterpolation.jl](https://github.com/tensor4all/TensorCrossInterpolation.jl/) provides implementations of TCI.
- [QuanticsGrids.jl](https://github.com/tensor4all/QuanticsGrids.jl/) provides utilities for handling quantics representations, e.g., creating a quantics grid and transformation between the original coordinate system and the quantics representation.
- [QuanticsTCI.jl](https://github.com/tensor4all/QuanticsTCI.jl/) is a thin wrapper around `TensorCrossInterpolation.jl` and `QuanticsGrids.jl`, providing valuable functionalities for non-expert users' performing quantics TCI (QTCI).
- [TCIITensorConversion.jl](https://github.com/tensor4all/TCIITensorConversion.jl/) provides conversions of tensor trains between `TensorCrossInterpolation.jl` and `ITensors.jl`.
- [Quantics.jl](https://github.com/tensor4all/Quantics.jl/) is an experimental library providing a high-level API for performing operations in QTT. This library is under development and its API may be subject to change. The library is not yet registered in the Julia package registry.

Additionally, we provide some topics on Julia packages such as:

- [Plots.jl](plots.ipynb). Basic tutorial for plotting using Plots.jl.

This documentation provides examples of using these libraries to perform QTCI and other operations.

## Preparation - Installing Julia

Install `julia` command using [juliaup](https://github.com/JuliaLang/juliaup).

On Windows Julia and Juliaup can be installed directly from the Windows store. One can also install exactly the same version by executing
"""

# ╔═╡ 3f5633ea-85cd-48dd-a533-9d2d57d54bc2
md"""
```powershell
PS> winget install julia -s msstore
```
"""

# ╔═╡ f6c6d410-bc9a-427e-9085-c966acd1509c
md"""
on a command line.

Juliaup can be installed on Linux or Mac by executing
"""

# ╔═╡ 8972eee5-606d-4d7d-bb41-5f6c768a0fe4
md"""
```sh
$ curl -fsSL https://install.julialang.org | sh
```
"""

# ╔═╡ 96a60509-1189-4925-a1d1-69e7a30f6b52
md"""
in a shell.

You can check that `julia` is installed correctly by simply running `julia` in your terminal:

```julia-repl
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type \"?\" for help, \"]?\" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.1 (2024-02-13)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

The REPL greets you with a banner and a `julia>` prompt. Let's display \"Hello World\":

```julia-repl
julia> println(\"Hello World\")
```

To see the environment in which Julia is running, you can use `versioninfo()`.

```julia-repl
julia> versioninfo()
```

To exit the interactive session, type `exit()` followed by the return or enter key:

```julia-repl
julia> exit()
```

See the official documentation at [The Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) to learn more."""

# ╔═╡ 7b83cb86-f08a-41b0-b506-6cbe5393d3a3


# ╔═╡ Cell order:
# ╟─5cf76073-4a83-4d0d-aac0-843dbbafc027
# ╟─3f5633ea-85cd-48dd-a533-9d2d57d54bc2
# ╟─f6c6d410-bc9a-427e-9085-c966acd1509c
# ╟─8972eee5-606d-4d7d-bb41-5f6c768a0fe4
# ╟─96a60509-1189-4925-a1d1-69e7a30f6b52
# ╟─7b83cb86-f08a-41b0-b506-6cbe5393d3a3
