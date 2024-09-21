### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ca3996e3-7a32-41a9-9e3f-f5cb83f3fe5f
begin
	using Markdown
	using PlutoUI
end

# ╔═╡ 89ca61fd-6bd0-483f-aad6-e3aa2e35046c
md"""

To run this notebook `welcome.jl` locally, copy and paste the following into your Julia REPL:

```julia
using Pkg; Pkg.activate(temp=true); Pkg.add("Pluto")
BASE_URL = "https://raw.githubusercontent.com/tensor4all/T4APlutoExamples/refs/heads/main/pluto_notebooks/"
notebook = "welcome.jl"
url = joinpath(BASE_URL, notebook)
using Pluto; Pluto.run(notebook=download(url))
```
"""

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
$ curl -fsSL https://install.julialang.org | sh -s -- --yes
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
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.5 (2024-08-27)
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

# ╔═╡ 19b7809c-5a93-4963-b46a-360a332c476d
begin
	img_main_menu=Resource("https://raw.githubusercontent.com/tensor4all/T4APlutoExamples/refs/heads/main/assets/open_welcome.png")
	nothing
end

# ╔═╡ 7b83cb86-f08a-41b0-b506-6cbe5393d3a3
md"""
## How to open Pluto notebooks locally

Our tutorials are written in [Pluto.jl](https://plutojl.org/) notebook. To open Pluto notebooks locally, clone our [tutorial repository T4APlutoExamples](https://github.com/tensor4all/T4APlutoExamples) and navigate to directory `T4APlutoExamples`:

```sh
$ git clone https://github.com/tensor4all/T4APlutoExamples.git
$ cd T4APlutoExamples
$ Manifest.toml   Project.toml    README.md       pluto_notebooks scripts
```

Then we also need to install Pluto.jl. To do this, type `julia --project` in a terminal to open Julia REPL and run the following julia code:

```julia-repl
$ julia --project
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.5 (2024-08-27)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> using Pkg; Pkg.instantiate()
  Activating project at `~/tensor4all/T4APlutoExamples`
```

Continued from previous REPL session, launch Pluto server locally via:

```julia-repl
julia> using Pluto; Pluto.run()
[ Info: Loading...
┌ Info:
└ Opening http://localhost:1234/?secret=xxxxxx in your default browser... ~ have fun!
┌ Info:
│ Press Ctrl+C in this terminal to stop Pluto
└
```

This will open http://localhost:1234/?secret=xxxxxx in your default browser and you will see the following main menu of Pluto notebook:

$(img_main_menu)

To open notebooks under `pluto_notebooks` directory, type `pluto_notebooks/welcome.jl` to text area under `Open a notebook` section. Then click `Open` button.
"""

# ╔═╡ ec419a4f-061c-4d67-a1b6-c123eb763132
md"""
## Specifying Pluto notebook URL directly

You can also open the notebook on the web directly.
"""

# ╔═╡ 2cbff48a-a3ef-462d-a726-4c5ca85bb4c0
md"""
## About PlutoUI.jl

The drop down menu above is created using PlutoUI.jl. You'll notice that when the drop-down menu is updated from `welcome.jl' to `quantics1d.jl', the message "To run this notebook locally, run welcome.jl" should change to "To run this notebook locally, run quantics1d.jl". This interactive functionality is one of the key features of Pluto notebook.
"""

# ╔═╡ 3766d4ae-2f5a-4515-82c2-b8984947efa4
begin
	ui_notebook = @bind notebook Select([
		"welcome.jl",
		"quantics1d.jl",
		"quantics2d.jl",
		"quantics1d_advanced.jl",
		"compress.jl",
		"interfacingwithitensors.jl",
		"plots.jl",
		"qft.jl",
	], default="welcome.jl")
	nothing
end

# ╔═╡ 07854cf9-da58-4c02-a54f-31a24d1f32b3
md"""
Select file $(ui_notebook).

To run this notebook $(notebook) locally, copy and paste the following into your Julia REPL:
"""

# ╔═╡ cf22b220-b5d6-483f-a137-ff56d0216158
begin
	mdstr = """
	```julia
	using Pkg; Pkg.activate(temp=true); Pkg.add("Pluto")
	BASE_URL = "https://raw.githubusercontent.com/tensor4all/T4APlutoExamples/refs/heads/main/pluto_notebooks/"
	notebook = "$(notebook)"
	url = joinpath(BASE_URL, notebook)
	using Pluto; Pluto.run(notebook=download(url))
	```
	"""
	Markdown.parse(mdstr)
end

# ╔═╡ 1286865c-875b-4b32-b27f-9796aab29b23
md"""
## About Pluto.jl

Since Pluto has a built-in package manager, packages are automatically installed when you use:

```julia
using <YourPackage>
# or 
import <YourPackage>
``` 

Your package environment is stored in the notebook file. If you open the notebook with a text editor you will find `PLUTO_PROJECT_TOML_CONTENTS` which corresponds to Project.toml and `PLUTO_MANIFEST_TOML_CONTENTS` which corresponds to Manifest.toml. When someone else opens your notebook with Pluto, the exact same package environment will be used and packages will work on their computer.

See [Pluto’s built-in package management](https://plutojl.org/en/docs/packages/) to learn more.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "be1c3711711942a0b3f42007b7d4abd4448cc38d"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

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
# ╟─89ca61fd-6bd0-483f-aad6-e3aa2e35046c
# ╠═ca3996e3-7a32-41a9-9e3f-f5cb83f3fe5f
# ╟─5cf76073-4a83-4d0d-aac0-843dbbafc027
# ╟─3f5633ea-85cd-48dd-a533-9d2d57d54bc2
# ╟─f6c6d410-bc9a-427e-9085-c966acd1509c
# ╟─8972eee5-606d-4d7d-bb41-5f6c768a0fe4
# ╟─96a60509-1189-4925-a1d1-69e7a30f6b52
# ╟─19b7809c-5a93-4963-b46a-360a332c476d
# ╟─7b83cb86-f08a-41b0-b506-6cbe5393d3a3
# ╟─ec419a4f-061c-4d67-a1b6-c123eb763132
# ╟─07854cf9-da58-4c02-a54f-31a24d1f32b3
# ╟─cf22b220-b5d6-483f-a137-ff56d0216158
# ╟─2cbff48a-a3ef-462d-a726-4c5ca85bb4c0
# ╠═3766d4ae-2f5a-4515-82c2-b8984947efa4
# ╟─1286865c-875b-4b32-b27f-9796aab29b23
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
