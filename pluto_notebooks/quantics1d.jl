### A Pluto.jl notebook ###

# ╔═╡ 5c09f2e8-5e91-413f-8f21-407d13ed5b8b
md"""
Click [here](https://tensor4all.org/T4AJuliaTutorials/_sources/ipynbs/quantics1d.ipynb) to download the notebook locally.
"""

# ╔═╡ f85ccc76-0793-41c6-acf5-23e621953b4b
md"""
# Quantics TCI of univariate function
"""

# ╔═╡ ce892f77-f0ee-4721-8976-9d4e217d1925
begin
    using Plots
    gr() # Use GR backend for plotting

    import QuanticsGrids as QG
    using QuanticsTCI: quanticscrossinterpolate, integral

    # defines mutable struct `SemiLogy` and sets shorthands `semilogy` and `semilogy!`
    @userplot SemiLogy
    @recipe function f(t::SemiLogy)
        x = t.args[begin]
        y = t.args[end]
        ε = nextfloat(0.0)

        yscale := :log10
        # Warning: Invalid negative or zero value 0.0 found at series index 16 for log10 based yscale
        # prevent log10(0) from being -Inf
        (x, ε .+ y)
    end
end

# ╔═╡ e241cb1b-d6f4-4017-bd9c-91269a7d44cb
md"""
## Example 1

The first example is taken from Fig. 1 in [Ritter2024](https://arxiv.org/abs/2303.11819).

We are going to compute the integral $\mathrm{I}[f] = \int_0^{\ln 20} \mathrm{d}x f(x) $ of the function

$$
f(x) = \cos\left(\frac{x}{B}\right) \cos\left(\frac{x}{4\sqrt{5}B}\right) e^{-x^2} + 2e^{-x},
$$

where $B = 2^{-30}$.
The integral evaluates to $\mathrm{I}[f] = 19/10 + O(e^{-1/(4B^2)})$.

We first construct a QTT representation of the function $f(x)$ as follows:"""

# ╔═╡ 783ffb2d-8b23-41a0-919b-2e51e0d0c8bd
begin
    B = 2^(-30) # global variable
    function f(x)
        return cos(x / B) * cos(x / (4 * sqrt(5) * B)) * exp(-x^2) + 2 * exp(-x)
    end

    println(f(0.2))
end

# ╔═╡ bfb37a67-322e-4e2a-ad7c-dc8a628ae44f
md"""
Let's examine the behaviour of $f(x)$. This function involves structure on widely different scales: rapid, incommensurate oscillations and a slowly decaying envelope. We'll use [PythonPlot.jl](https://github.com/JuliaPy/PythonPlot.jl) visualisation library which uses Python library [matplotlib](https://matplotlib.org/) behind the scenes.

For small $x$ we have:
"""

# ╔═╡ 0667a441-4318-4ff8-961d-bee751b0f5b1
begin
    xs = LinRange(0, 2.0^(-23), 1000)

    plt = plot(title = "$(nameof(f))")
    plot!(plt, xs, f.(xs), label = "$(nameof(f))", legend = true)
    plt
end

# ╔═╡ 1db28e87-516c-468d-aee2-77a108691054
md"""
For $x \in (0, 3]$ we will get:
"""

# ╔═╡ ac154938-3dfe-420f-a24a-43fb8b9a5060
begin
    xs2 = LinRange(2.0^(-23), 3, 100000)
    plt = plot(title = "$(nameof(f))")
    plot!(plt, xs2, f.(xs2), label = "$(nameof(f))", legend = true)
    plt
end

# ╔═╡ 7d3f31de-a251-4ed4-99b4-380206595132
md"""
### QTT representation

We construct a QTT representation of this function on the domain $[0, \ln 20]$, discretized on a quantics grid of size $2^\mathcal{R}$ with $\mathcal{R} = 40$ bits:
"""

# ╔═╡ fac80646-42ab-40f7-8233-c679cca2cf6b
begin
    R = 40 # number of bits
    xmin = 0.0
    xmax = log(20.0)
    N = 2^R # size of the grid
    # * Uniform grid (includeendpoint=false, default):
    #   -xmin, -xmin+dx, ...., -xmin + (2^R-1)*dx
    #     where dx = (xmax - xmin)/2^R.
    #   Note that the grid does not include the end point xmin.
    #
    # * Uniform grid (includeendpoint=true):
    #   -xmin, -xmin+dx, ...., xmin-dx, xmin,
    #     where dx = (xmax - xmin)/(2^R-1).
    qgrid = QG.DiscretizedGrid{1}(R, xmin, xmax; includeendpoint = true)
    ci, ranks, errors = quanticscrossinterpolate(Float64, f, qgrid; maxbonddim = 15)
end

# ╔═╡ 575431fb-1cb5-4611-add7-471f7ae01dcd
length(ci.tci)

# ╔═╡ e5282234-32be-4787-a33e-c2df02aefcaf
md"""
Here, we've created the object `ci` of type `QuanticsTensorCI2{Float64}`. This can be evaluated at an linear index $i$ ($1 \le i \le 2^\mathcal{R}$) as follows:
"""

# ╔═╡ b48a3427-cd90-4d80-a97c-bde4b7da6716
for i in [1, 2, 3, 2^R] # Linear indices
    # restore original coordinate `x` from linear index `i`
    x = QG.grididx_to_origcoord(qgrid, i)
    println("x: $(x), i: $(i), tci: $(ci(i)), ref: $(f(x))")
end

# ╔═╡ d3f8d6ce-92e0-4a2b-b904-18969197936c
md"""
We see that `ci(i)` approximates the original `f` at `x = QG.grididx_to_origcoord(qgrid, i)`. Let's plot them together.
"""

# ╔═╡ b0f5b0e0-c4c3-4ead-8216-d5e04401ccc1
begin
    maxindex = QG.origcoord_to_grididx(qgrid, 2.0^(-23))
    testindices = Int.(round.(LinRange(1, maxindex, 1000)))

    xs = [QG.grididx_to_origcoord(qgrid, i) for i in testindices]
    ys = f.(xs)
    yci = ci.(testindices)

    plt = plot(title = "$(nameof(f)) and TCI", xlabel = "x", ylabel = "y")
    plot!(plt, xs, ys, label = "$(nameof(f))", legend = true)
    plot!(plt, xs, yci, label = "tci", linestyle = :dash, alpha = 0.7, legend = true)
    plt
end

# ╔═╡ 7595b85c-7f02-4833-911e-87df232e4c11
md"""
Above, one can see that the original function is interpolated very accurately.

Let's plot of $x$ vs interpolation error $|f(x) - \mathrm{ci}(x)|$ for small $x$
"""

# ╔═╡ 70459274-2923-437b-9f09-9c9be792996e
begin
    ys = f.(xs)
    yci = ci.(testindices)
    plt = plot(title = "x vs interpolation error: $(nameof(f))",
        xlabel = "x", ylabel = "interpolation error")
    semilogy!(xs, abs.(ys .- yci), label = "log(|f(x) - ci(x)|)", yscale = :log10,
        legend = :bottomright, ylim = (1e-16, 1e-7), yticks = 10.0 .^ collect(-16:1:-7))
    plt
end

# ╔═╡ 3bdc28f2-5013-4285-a058-3b1bfc855467
md"""
... and for all $x$:"""

# ╔═╡ 3edf2304-4ac8-460f-8888-d52b8dfea0d6
begin
    plt = plot(title = "x vs interpolation error: $(nameof(f))",
        xlabel = "x", ylabel = "interpolation error")

    testindices = Int.(round.(LinRange(1, 2^R, 1000)))
    xs = [QG.grididx_to_origcoord(qgrid, i) for i in testindices]
    ys = f.(xs)
    yci = ci.(testindices)
    semilogy!(xs, abs.(ys .- yci), label = "log(|f(x) - ci(x)|)", legend = true,
        ylim = (1e-16, 1e-6), yticks = 10.0 .^ collect(-16:1:-6))
    plt
end

# ╔═╡ e93fcdcb-6573-4c31-9a0b-c32e1f91ebd7
md"""
The function is approximated with an accuracy $\approx 10^{-7}$ over the entire domain.

We are now ready to compute the integral $\mathrm{I}[f] = \int_0^{\ln 20} \mathrm{d}x f(x) \simeq 19/10$ using the QTT representation of $f(x)$."""

# ╔═╡ e9fdf643-3e46-414e-9f8b-7746d91d0f7f
integral(ci), 19 / 10

# ╔═╡ edfe0936-17a8-416d-92ad-6c7c9d897fd2
md"""
`integral(ci)` is equivalent to calling `QuanticsTCI.sum(ci)` and multiplying the result by the interval length divided by $2^\mathcal{R}$."""

# ╔═╡ c9365566-6df1-4a16-8a31-a515fe98e0d6
sum(ci) * (log(20) - 0) / 2^R, 19 / 10

# ╔═╡ 1ef93487-1cac-4da4-912e-f3a69022a853
md"""
### About `ci::QuanticsTensorCI2{Float64}`

Let's dive into the `ci` object:
"""

# ╔═╡ 6bbdc9e0-5ff1-436f-a19c-3e7cb89a824d
println(typeof(ci))

# ╔═╡ 4996289b-e733-43aa-9a90-ab3143a7d6ec
md"""
As we've seen before, `ci` is an object of `QuanticsTensorCI2{Float64}` in `QuanticsTCI.jl`, which is a thin wrapper of `TensorCI2{Float64}` in `TensorCrossInterpolation.jl`.
The undering object of `TensorCI2{Float64}` type can be accessed as `ci.tci`. This will be useful for obtaining more detailed information on the TCI results.

For instance, `ci.tci.maxsamplevalue` is an estimate of the abosolute maximum value of the function, and `ci.tci.pivoterrors` stores the error as function of the bond dimension computed by prrLU.
In the following figure, we plot the normalized error vs. bond dimension, showing an exponential decay.
"""

# ╔═╡ a426a6ad-75d1-46ec-b05a-8e51301ac545
begin
    # Plot error vs bond dimension obtained by prrLU
    plt = plot(title = "normalized error vs. bond dimension: $(nameof(f))",
        xlabel = "Bond dimension", ylabel = "Normalization error")
    semilogy!(1:length(ci.tci.pivoterrors), ci.tci.pivoterrors ./ ci.tci.maxsamplevalue,
        marker = :x, ylim = (1e-8, 10), yticks = (10.0 .^ (-10:1:0)), legend = false)
    plt
end

# ╔═╡ bee885a0-3170-4410-a783-3c221e29ab71
md"""
### Function evaluations

Our TCI algorithm does not call elements of the entire tensor, but constructs the TT (Tensor Train) from some elements chosen adaptively. On which points $x \in [0, 3]$ was the function evaluated to construct a QTT representation of the function $f(x)$? Let's find out. One can retrieve the information on the function evaluations as follows.
"""

# ╔═╡ 6d75cc75-8170-498f-8520-a44917b7fd6d
begin
    import QuanticsTCI
    # Dict{Float64,Float64}
    # key: `x`
    # value: function value at `x`
    evaluated = QuanticsTCI.cachedata(ci)
end

# ╔═╡ eda97da8-f49f-43d9-857a-ff5bee58be16
md"""
Let's plot `f` and the evaluated points together.
"""

# ╔═╡ 5ce76560-4fe2-49e6-ac79-62d48100b5c1
begin
    f̂(x) = ci(QG.origcoord_to_quantics(qgrid, x))
    xs = LinRange(0, 2.0^(-23), 1000)

    xs_evaluated = collect(keys(evaluated))
    fs_evaluated = [evaluated[x] for x in xs_evaluated]

    plt = plot(
        title = "$(nameof(f)) and TCI", xlabel = "x", ylabel = "y", xlim = (0, maximum(xs)))
    plot!(plt, xs, f.(xs), label = "$(nameof(f))")
    scatter!(plt, xs_evaluated, fs_evaluated, marker = :x, label = "evaluated points")
    plt
end

# ╔═╡ 2ae41928-e443-44ac-80a8-616e37277da5
md"""
## Example 2

We now consider the function:

$$
\newcommand{\sinc}{\mathrm{sinc}}
\begin{align}
f(x) &= \sinc(x)+3e^{-0.3(x-4)^2}\sinc(x-4) \nonumber\\
&\quad - \cos(4x)^2-2\sinc(x+10)e^{-0.6(x+9)} + 4 \cos(2x) e^{-|x+5|}\nonumber \\
&\quad +\frac{6}{x-11}+ \sqrt{(|x|)}\arctan(x/15).\nonumber
\end{align}
$$

One can construct a QTT representation of this function on the domain $[-10, 10)$ using a quantics grid of size $2^\mathcal{R}$ ($\mathcal{R}=20$):
"""

# ╔═╡ 68cac44c-41a6-498d-9957-dd3da91679c8
begin
    import QuanticsGrids as QG
    using QuanticsTCI

    R = 20 # number of bits
    N = 2^R  # size of the grid

    qgrid = QG.DiscretizedGrid{1}(R, -10, 10; includeendpoint = false)

    # Function of interest
    function oscillation_fn(x)
        return (
            sinc(x) + 3 * exp(-0.3 * (x - 4)^2) * sinc(x - 4) - cos(4 * x)^2 -
            2 * sinc(x + 10) * exp(-0.6 * (x + 9)) + 4 * cos(2 * x) * exp(-abs(x + 5)) +
            6 * 1 / (x - 11) + sqrt(abs(x)) * atan(x / 15))
    end

    # Convert to quantics format and sweep
    ci, ranks, errors = quanticscrossinterpolate(
        Float64, oscillation_fn, qgrid; maxbonddim = 15)
end

# ╔═╡ db6a1232-8fc0-4ebd-838b-5905d469ae11
for i in [1, 2, 2^R] # Linear indices
    x = QG.grididx_to_origcoord(qgrid, i)
    println("x: $(x), tci: $(ci(i)), ref: $(oscillation_fn(x))")
end

# ╔═╡ 4a53fd00-1320-4f87-8c92-ddcce7f954c3
md"""
Above, one can see that the original function is interpolated very accurately. The function `grididx_to_origcoord` transforms a linear index to a coordinate point $x$ in the original domain ($-10 \le x < 10$).

In the following figure, we plot the normalized error vs. bond dimension, showing an exponential decay.
"""

# ╔═╡ 1d102f52-822f-43a8-bad3-2416e8c79aa8
begin
    # Plot error vs bond dimension obtained by prrLU
    plt = plot(xlabel = "Bond dimension", ylabel = "Normalization error",
        title = "normalized error vs. bond dimension")
    semilogy!(1:length(ci.tci.pivoterrors), ci.tci.pivoterrors ./ ci.tci.maxsamplevalue,
        marker = :x, ylim = (1e-8, 10), yticks = (10.0 .^ (-10:1:0)), legend = false)
    plt
end

# ╔═╡ 86a2c2ce-928e-4f21-9128-b33e143f1c2e
md"""
## Example 3

### Control the error of the TCI by a tolerance

We interpolate the same function as in Example 2, but this time we use a tolerance to control the error of the TCI. The tolerance is a positive number that determines the maximum error of the TCI, which is scaled by an estimate of the abosolute maximum of the function.
The TCI algorithm will adaptively increase the bond dimension until the error is below the tolerance."""

# ╔═╡ fb59b981-e550-4763-8c2e-5797c383aeb4
begin
    tol = 1e-8 # Tolerance for the error

    # Convert to quantics format and sweep
    ci_tol, ranks_tol, errors_tol = quanticscrossinterpolate(
        Float64, oscillation_fn, qgrid;
        tolerance = tol,
        normalizeerror = true, # Normalize the error by the maximum sample value,
        verbosity = 1, loginterval = 1 # Log the error every `loginterval` iterations
    )
end

# ╔═╡ 6c7ac83c-f9e1-4999-883e-913e37f0d03d
println("Max abs sampled value is $(ci_tol.tci.maxsamplevalue)")

# ╔═╡ ab49ca09-97d3-4223-891f-966df3309739
errors_tol ./ ci_tol.tci.maxsamplevalue

# ╔═╡ f4c3409b-a1c4-4db6-9c31-7559178c6b03
md"""
### Estimate the error of the TCI
Wait!
Since we did not sample the function over the entire domain, we do not know the true error of the TCI.
In theory, we can estimate the error of the TCI by comparing the function values at the sampled points with the TCI values at the same points.
But, it is not practical to compare the function values with the TCI values at all points in the domain.
The function `estimatetrueerror` in `TensorCrossInterpolation.jl` provides a good estimate of the error of the TCI.
The algorithm finds indices (points) where the error is large by a randomized global search algorithm starting with a set of random initial points."""

# ╔═╡ 4c6c4cc7-7240-45cc-9500-51a28da3a690
import TensorCrossInterpolation as TCI
pivoterror_global = TCI.estimatetrueerror(
    TCI.TensorTrain(ci.tci), ci.quanticsfunction; nsearch = 100) # Results are sorted in descending order of the error

# ╔═╡ d64ff0f1-794d-4e53-878a-45b81a8707aa
md"""
Now, you can see the error estimate of the TCI is below the tolerance of $10^{-8}$ (or close to it)."""

# ╔═╡ 8945822d-c359-4ed2-a56a-8e08ae38aaf9
begin
    println("The largest error found is $(pivoterror_global[1][2]) and the corresponding pivot is $(pivoterror_global[1][1]).")
    println("The tolerance used is $(tol * ci_tol.tci.maxsamplevalue).")
end

# ╔═╡ Cell order:
# ╟─5c09f2e8-5e91-413f-8f21-407d13ed5b8b
# ╟─f85ccc76-0793-41c6-acf5-23e621953b4b
# ╠═ce892f77-f0ee-4721-8976-9d4e217d1925
# ╟─e241cb1b-d6f4-4017-bd9c-91269a7d44cb
# ╠═783ffb2d-8b23-41a0-919b-2e51e0d0c8bd
# ╟─bfb37a67-322e-4e2a-ad7c-dc8a628ae44f
# ╠═0667a441-4318-4ff8-961d-bee751b0f5b1
# ╟─1db28e87-516c-468d-aee2-77a108691054
# ╠═ac154938-3dfe-420f-a24a-43fb8b9a5060
# ╟─7d3f31de-a251-4ed4-99b4-380206595132
# ╠═fac80646-42ab-40f7-8233-c679cca2cf6b
# ╠═575431fb-1cb5-4611-add7-471f7ae01dcd
# ╟─e5282234-32be-4787-a33e-c2df02aefcaf
# ╠═b48a3427-cd90-4d80-a97c-bde4b7da6716
# ╟─d3f8d6ce-92e0-4a2b-b904-18969197936c
# ╠═b0f5b0e0-c4c3-4ead-8216-d5e04401ccc1
# ╟─7595b85c-7f02-4833-911e-87df232e4c11
# ╠═70459274-2923-437b-9f09-9c9be792996e
# ╟─3bdc28f2-5013-4285-a058-3b1bfc855467
# ╠═3edf2304-4ac8-460f-8888-d52b8dfea0d6
# ╟─e93fcdcb-6573-4c31-9a0b-c32e1f91ebd7
# ╠═e9fdf643-3e46-414e-9f8b-7746d91d0f7f
# ╟─edfe0936-17a8-416d-92ad-6c7c9d897fd2
# ╠═c9365566-6df1-4a16-8a31-a515fe98e0d6
# ╟─1ef93487-1cac-4da4-912e-f3a69022a853
# ╠═6bbdc9e0-5ff1-436f-a19c-3e7cb89a824d
# ╟─4996289b-e733-43aa-9a90-ab3143a7d6ec
# ╠═a426a6ad-75d1-46ec-b05a-8e51301ac545
# ╟─bee885a0-3170-4410-a783-3c221e29ab71
# ╠═6d75cc75-8170-498f-8520-a44917b7fd6d
# ╟─eda97da8-f49f-43d9-857a-ff5bee58be16
# ╠═5ce76560-4fe2-49e6-ac79-62d48100b5c1
# ╟─2ae41928-e443-44ac-80a8-616e37277da5
# ╠═68cac44c-41a6-498d-9957-dd3da91679c8
# ╠═db6a1232-8fc0-4ebd-838b-5905d469ae11
# ╟─4a53fd00-1320-4f87-8c92-ddcce7f954c3
# ╠═1d102f52-822f-43a8-bad3-2416e8c79aa8
# ╟─86a2c2ce-928e-4f21-9128-b33e143f1c2e
# ╠═fb59b981-e550-4763-8c2e-5797c383aeb4
# ╠═6c7ac83c-f9e1-4999-883e-913e37f0d03d
# ╠═ab49ca09-97d3-4223-891f-966df3309739
# ╟─f4c3409b-a1c4-4db6-9c31-7559178c6b03
# ╠═4c6c4cc7-7240-45cc-9500-51a28da3a690
# ╟─d64ff0f1-794d-4e53-878a-45b81a8707aa
# ╠═8945822d-c359-4ed2-a56a-8e08ae38aaf9
