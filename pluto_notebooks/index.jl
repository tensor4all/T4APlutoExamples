### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 08e003d9-7bcb-44bb-8200-5943c91993db
begin
    using Dates
    now(UTC)
    VERSION # display Julia version
    using Pkg
    Pkg.status()
end

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

# ╔═╡ 8e34f212-d1fe-4e4e-b7f0-bb29a91b5f75
md"""
## Run notebooks

1. Download all the notebooks as [a zip file](https://github.com/tensor4all/T4AJuliaTutorials/releases/download/ipynbs%2Fpreview/ipynbs.zip).
1. Double click `ipynbs.zip` to extract the zip file. You will get a directory named `ipynbs`.
1. Open a terminal and change the directory to the `ipynbs` directory. Then, open a Julia REPL using the `ipynbs` directory as the project directory.
    ```sh
    $ cd ipynbs
   $ ls
       Manifest.toml                 plots.ipynb
       Project.toml                  qft.ipynb
       compress.ipynb                quantics1d.ipynb
       index.ipynb                   quantics1d_advanced.ipynb
       interfacingwithitensors.ipynb quantics2d.ipynb
    $ julia --project=@.
    ```
1. Run the following commands in the Julia REPL to install the required packages, which are registered in `ipynbs/Project.toml`, and open the Jupyter notebook.

```julia-repl
julia> using Pkg
julia> Pkg.instantiate() # Install the required packages. This may take a while.
julia> using IJulia
julia> IJulia.notebook(;dir=pwd()) # Open the Jupyter notebook.
```
"""

# ╔═╡ 2a924178-0714-43d7-bb6d-39041d04dace
md"""
Here, the `--project` option activates our project, which is characterized by `ipynbs/Project.toml`, and `Pkg.instantiate()` installs dependencies needed to run our notebooks.
`Pkg.instantiate()` may take a while to complete, as it downloads and installs the required packages.
This command only needs to be run once, unless the `Project.toml` file is modified."""

# ╔═╡ 7b83cb86-f08a-41b0-b506-6cbe5393d3a3
md"""
We do not recommend to run the notebook in Safari because it may cause some issues.
If you want to use another browser to open the notebook, you can use the following command:

```julia-repl
julia> browser=\"chrome\"  # specify your browser name: see https://docs.python.org/3/library/webbrowser.html#webbrowser.register
julia> cmd = `$(IJulia.JUPYTER) notebook --browser=$(browser)`
julia> run(Cmd(cmd; dir=pwd()); wait=false)
```"""

# ╔═╡ 1a6c4bac-5bce-4b55-b521-5a7d30f77ad4
md"""
## Print out the status of the project

Having trouble? Try the following command in your Julia's REPL:

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Pkg = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "577cc1f465b874f210d362d20acd3bcb5e311580"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─5cf76073-4a83-4d0d-aac0-843dbbafc027
# ╟─3f5633ea-85cd-48dd-a533-9d2d57d54bc2
# ╟─f6c6d410-bc9a-427e-9085-c966acd1509c
# ╟─8972eee5-606d-4d7d-bb41-5f6c768a0fe4
# ╟─96a60509-1189-4925-a1d1-69e7a30f6b52
# ╟─8e34f212-d1fe-4e4e-b7f0-bb29a91b5f75
# ╟─2a924178-0714-43d7-bb6d-39041d04dace
# ╟─7b83cb86-f08a-41b0-b506-6cbe5393d3a3
# ╟─1a6c4bac-5bce-4b55-b521-5a7d30f77ad4
# ╠═08e003d9-7bcb-44bb-8200-5943c91993db
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
