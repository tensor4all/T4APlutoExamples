### A Pluto.jl notebook ###

# ╔═╡ 5c9be416-2eb0-4f7e-bc77-8a14c0cffd67
md"""
Click [here](https://tensor4all.org/T4AJuliaTutorials/_sources/ipynbs/qft.ipynb) to download the notebook locally.
"""

# ╔═╡ 2089fb37-7a8d-46c2-b95c-a0feab70d250
md"""
# Quantum Fourier Transform
"""

# ╔═╡ 23d20fe2-152c-4368-808d-784ab72c507b
begin
    using LaTeXStrings
    using Plots

    import QuanticsGrids as QG
    import TensorCrossInterpolation as TCI
    using QuanticsTCI: quanticscrossinterpolate, quanticsfouriermpo
end

# ╔═╡ ab2c70f2-a83e-454a-a183-12772af3eac4
md"""
## 1D Fourier transform

$$
%\newcommand{\hf}{\hat{f}}   %Fourier transform of \bff
%\newcommand{\hF}{\hat{F}}
$$


Consider a discrete function $f_m \in \mathbb{C}^M$, e.g. the
discretization, $f_m = f(x(m))$, of a one-dimensional function $f(x)$ on a grid $x(m)$.
Its discrete Fourier transform (DFT) is

$$
\hat{f}_k = \sum_{m=0}^{M-1}   T_{km} f_m , \qquad
T_{km} =  \tfrac{1}{\sqrt{M}}  e^{- i 2 \pi k \cdot m /M} .
$$

For a quantics grid, $M = 2^\mathcal{R}$ is exponentially large and the (naive) DFT exponentially expensive to evaluate.
However, the QTT representation of $T$ is known to have a low-rank structure and can be represented as a tensor train with small bond dimensions.

Thus, if the input function $f$ is given in the quantics representation as

<img src=\"https://raw.githubusercontent.com/tensor4all/T4AJuliaTutorials/main/qft1.png\" alt=\"qft1\" width=\"30%\">,

$\hat{f} = T f$ can be computed by efficiently contracting the tensor trains for $T$ and $f$ and recompressing the result:

<img src=\"https://raw.githubusercontent.com/tensor4all/T4AJuliaTutorials/main/qft2.png\" alt=\"qft contraction\" width=\"60%\">.

Note that after the Fourier transform, the quantics indices $\sigma_1,\cdots,\sigma_\mathcal{R}$ are ordered in the inverse order of the input indices $\sigma'_1,\cdots,\sigma'_\mathcal{R}$.
This allows construction of the DFT operator with small bond dimensions."""

# ╔═╡ 81ef384b-b219-4214-973c-7ed8d892834a
md"""


We consider a function $f(x)$, which is the sum of exponential functions, defined on interval $[0,1]$:

$$
f(x) = \sum_p \frac{c_p}{1 - e^{-\epsilon_p}} e^{-\epsilon_p x}.
$$

Its Fourier transform is given by

$$
\hat{f}_k = \int_0^1 dx \, f(x) e^{i \omega_k x} = - \sum_p \frac{c_p}{i\omega_k - \epsilon_p}.
$$

for $k = 0, 1, \cdots $ and $\omega_k = 2\pi k$.

If you are familiar with quantum field theory, you can think of $f(x)$ as a bosonic correlation function."""

# ╔═╡ 4bbd8548-49cc-4abf-af40-909d15cc6c75
begin
    coeffs = [1.0, 1.0]
    ϵs = [100.0, -50.0]

    _exp(x, ϵ) = exp(-ϵ * x) / (1 - exp(-ϵ))

    fx(x) = sum(coeffs .* _exp.(x, ϵs))
end

# ╔═╡ 84e92a8c-289e-4831-88a1-f20d4d681aac
begin
    plotx = range(0, 1; length = 1000)

    plot(plotx, fx.(plotx))
    xlabel!(L"x")
    ylabel!(L"f(x)")
end

# ╔═╡ 3bfec21e-ecf6-4628-a45f-8920eef79447
md"""
First, we construct a QTT representation of the function $f(x)$."""

# ╔═╡ 85718cda-191e-4445-bcca-0704efe5d6b1
begin
    R = 40
    xgrid = QG.DiscretizedGrid{1}(R, 0, 1)

    qtci, ranks, errors = quanticscrossinterpolate(Float64, fx, xgrid; tolerance = 1e-10)
end

# ╔═╡ 02d6bed8-69a6-4b4c-852a-60d9fe52c4db
md"""
Second, we compute the Fourier transform of $f(x)$ using the QTT representation of $f(x)$ and the QTT representation of the DFT operator $T$:

$$
\hat{f}_k = \int_0^1 dx \, f(x) e^{i \omega_k x} \approx \frac{1}{M} \sum_{m=0}^{M-1} f_m e^{i 2 \pi k m / M} =  \frac{1}{\sqrt{M}} \sum_{m=0}^{M-1} T_{km} f_m.
$$

for $k = 0, \ldots, M-1$ and $\omega_k = 2\pi k$.
This can be implemented as follows."""

# ╔═╡ 1b129c10-2143-4235-95b2-0eb60885f7e0
begin
    # Construct QTT representation of T_{km}
    fouriertt = quanticsfouriermpo(R; sign = 1.0, normalize = true)

    # Apply T_{km} to the QTT representation of f(x)
    sitedims = [[2, 1] for _ in 1:R]
    ftt = TCI.TensorTrain(qtci.tci)
    hftt = TCI.contract(fouriertt, ftt; algorithm = :naive, tolerance = 1e-8)

    hftt *= 1 / sqrt(2)^R

    @show hftt
end

# ╔═╡ 314c5b5a-5c3f-4c96-b004-02743bab093a
md"""
Let us compare the result with the exact Fourier transform of $f(x)$."""

# ╔═╡ 1cbf3d00-d1a2-40ee-af13-7d725bd0c195
begin
    kgrid = QG.InherentDiscreteGrid{1}(R, 0) # 0, 1, ..., 2^R-1

    _expk(k, ϵ) = -1 / (2π * k * im - ϵ)
    hfk(k) = sum(coeffs .* _expk.(k, ϵs)) # k = 0, 1, 2, ..., 2^R-1

    plotk = collect(0:300)
    y = [hftt(reverse(QG.origcoord_to_quantics(kgrid, x))) for x in plotk] # Note: revert the order of the quantics indices
    p1 = plot()
    plot!(p1, plotk, real.(y), marker = :+, label = "QFT")
    plot!(p1, plotk, real.(hfk.(plotk)), marker = :x, label = "Reference")
    xlabel!(p1, L"k")
    ylabel!(p1, L"\mathrm{Re}~\hat{f}(k)")

    p2 = plot()
    plot!(p2, plotk, imag.(y), marker = :+, label = "QFT")
    plot!(p2, plotk, imag.(hfk.(plotk)), marker = :x, label = "Reference")
    xlabel!(L"k")
    ylabel!(L"\mathrm{Im}~\hat{f}(k)")

    plot(p1, p2, size = (800, 500))
end

# ╔═╡ 327f847d-de5f-4e40-9888-450283f92c4e
md"""
The exponentially large quantics grid allows to compute the Fourier transform with high accuracy at high frequencies.
To check this, let us compare the results at high frequencies."""

# ╔═╡ b9f728f1-2265-4e0e-95f2-49c7b97d0421
begin
    plotk = [10^n for n in 1:5]
    @assert maximum(plotk) <= 2^R - 1
    y = [hftt(reverse(QG.origcoord_to_quantics(kgrid, x))) for x in plotk] # Note: revert the order of the quantics indices

    p1 = plot()

    plot!(p1, plotk, abs.(real.(y)), marker = :+,
        label = "QFT", xscale = :log10, yscale = :log10)
    plot!(p1, plotk, abs.(real.(hfk.(plotk))), marker = :x,
        label = "Reference", xscale = :log10, yscale = :log10)
    xlabel!(p1, L"k")
    ylabel!(p1, L"\mathrm{Re}~\hat{f}(k)")

    p2 = plot()

    plot!(p2, plotk, abs.(imag.(y)), marker = :+,
        label = "QFT", xscale = :log10, yscale = :log10)
    plot!(p2, plotk, abs.(imag.(hfk.(plotk))), marker = :x,
        label = "Reference", xscale = :log10, yscale = :log10)
    xlabel!(p2, L"k")
    ylabel!(p2, L"\mathrm{Im}~\hat{f}(k)")

    plot(p1, p2, size = (800, 500))
end

# ╔═╡ 89dd01d2-c9fc-4d69-a5b6-3303850bbe8c
md"""
You may use ITensors.jl to compute the Fourier transform of the function $f(x)$.
The following code explains how to do this."""

# ╔═╡ 5f1dcbb3-1f0d-4263-8440-212f0b7f52b6
begin
    import TCIITensorConversion
    using ITensors
    import Quantics: fouriertransform, Quantics

    sites_m = [Index(2, "Qubit,m=$m") for m in 1:R]
    sites_k = [Index(2, "Qubit,k=$k") for k in 1:R]

    fmps = MPS(ftt; sites = sites_m)

    # Apply T_{km} to the MPS representation of f(x) and reply the result by 1/sqrt(M)
    # tag="m" is used to indicate that the MPS is in the "m" basis.
    hfmps = (1 / sqrt(2)^R) *
            fouriertransform(fmps; sign = 1, tag = "m", sitesdst = sites_k)
end

# ╔═╡ 77a9f7c9-36fe-4721-b6c3-7712930c3cf1
# Evaluate Ψ for a given index
function _evaluate(Ψ::MPS, sites, index::Vector{Int})
    only(reduce(*, Ψ[n] * onehot(sites[n] => index[n]) for n in 1:length(Ψ)))
end

# ╔═╡ 7348acb0-1e9c-493a-b192-facfd2d00109
begin
    @assert maximum(plotk) <= 2^R - 1
    y = [_evaluate(hfmps, reverse(sites_k), reverse(QG.origcoord_to_quantics(kgrid, x)))
         for x in plotk] # Note: revert the order of the quantics indices

    p1 = plot()
    plot!(p1, plotk, abs.(real.(y)), marker = :+, label = "QFT")
    plot!(p1, plotk, abs.(real.(hfk.(plotk))), marker = :x, label = "Reference")
    xlabel!(p1, L"k")
    ylabel!(p1, L"\mathrm{Re}~\hat{f}(k)")

    p2 = plot()
    plot!(p2, plotk, abs.(imag.(y)), marker = :+, label = "QFT")
    plot!(p2, plotk, abs.(imag.(hfk.(plotk))), marker = :x, label = "Reference")
    xlabel!(p2, L"k")
    ylabel!(p2, L"\mathrm{Im}~\hat{f}(k)")

    plot(p1, p2, size = (800, 500))
end

# ╔═╡ 87937f1f-eb60-40ea-b0ac-9bef4ce98637
md"""
## 2D Fourier transform

We now consider a two-dimensional function $f(x, y) = \frac{1}{(1 - e^{-\epsilon})(1 - e^{-\epsilon'})} e^{-\epsilon x - \epsilon' y}$ defined on the interval $[0,1]^2$.

Its Fourier transform is given by

$$
\hat{f}_{kl} = \int_0^1  \int_0^1 dx dy \, f(x, y) e^{i \omega_k x + i\omega_l y} \approx \frac{1}{M^2} \sum_{m,n=0}^{M-1} f_{mn} e^{i 2 \pi (k m + l n) / M} =  \frac{1}{M} \sum_{m,n=0}^{M-1} T_{km} T_{ln} f_{mn}.
$$

The exact form of the Fourier transform is

$$
\hat{f}_{kl} = \frac{1}{(i\omega_k - \epsilon) (i\omega_l - \epsilon')}.
$$

for $k, l = 0, 1, \cdots $, $\omega_k = 2\pi k$ and $\omega_l = 2\pi l$.

The 2D Fourier transform can be numerically computed in QTT format (with interleaved representation) in a straightforward way using Quantics.jl.
"""

# ╔═╡ 0c1da36b-686c-4850-a0a0-ac4652d0b0ce
begin
    ϵ = 1.0
    ϵprime = 2.0
    fxy(x, y) = _exp(x, ϵ) * _exp(y, ϵprime)

    # 2D quantics grid using interleaved unfolding scheme
    xygrid = QG.DiscretizedGrid{2}(R, (0, 0), (1, 1); unfoldingscheme = :interleaved)

    # Resultant QTT representation of f(x, y) has bond dimension of 1.
    qtci_xy, ranks_xy, errors_xy = quanticscrossinterpolate(
        Float64, fxy, xygrid; tolerance = 1e-10)
end

# ╔═╡ baabe2d4-d2c9-4932-af0a-b363854655ad
begin
    # for discretizing `y`
    sites_n = [Index(2, "Qubit,n=$n") for n in 1:R]

    sites_l = [Index(2, "Qubit,l=$l") for l in 1:R]

    sites_mn = collect(Iterators.flatten(zip(sites_m, sites_n)))

    fmps2 = MPS(TCI.TensorTrain(qtci_xy.tci); sites = sites_mn)
    siteinds(fmps2)
end

# ╔═╡ 35a93fe6-fa5e-4172-a7d2-228996cf9f5c
begin
    # Fourier transform for x
    tmp_ = (1 / sqrt(2)^R) *
           fouriertransform(fmps2; sign = 1, tag = "m", sitesdst = sites_k, cutoff = 1e-20)

    # Fourier transform for y
    hfmps2 = (1 / sqrt(2)^R) *
             fouriertransform(tmp_; sign = 1, tag = "n", sitesdst = sites_l, cutoff = 1e-20)

    siteinds(hfmps2)
end

# ╔═╡ 0fb125ca-eeec-4ada-ac62-12f45e486952
md"""
For convinience, we swap the order of the indices.
"""

# ╔═╡ 4fc4e652-c883-42b9-a049-79041773a584
begin
    # Convert to fused representation and swap the order of the indices
    hfmps2_fused = MPS(reverse([hfmps2[2 * n - 1] * hfmps2[2 * n] for n in 1:R]))

    # From fused to interleaved representation
    sites_kl = collect(Iterators.flatten(zip(sites_k, sites_l)))
    hfmps2_reverse = Quantics.rearrange_siteinds(hfmps2_fused, [[x] for x in sites_kl])
    siteinds(hfmps2_reverse)
end

# ╔═╡ 028094a0-16f7-4026-9c71-7bd6c31a1ce2
begin
    klgrid = QG.InherentDiscreteGrid{2}(R, (0, 0); unfoldingscheme = :interleaved)

    sparse1dgrid = collect(0:4)

    reconstdata = [_evaluate(
                       hfmps2_reverse, sites_kl, QG.origcoord_to_quantics(klgrid, (k, l)))
                   for k in sparse1dgrid, l in sparse1dgrid]

    hfkl(k::Integer, l::Integer) = _expk(k, ϵ) * _expk(l, ϵprime)

    exactdata = [hfkl(k, l) for k in sparse1dgrid, l in sparse1dgrid]

    c1 = heatmap(real.(exactdata))
    xlabel!(L"k")
    ylabel!(L"l")
    title!("Real part of Exact data")

    c2 = heatmap(real.(reconstdata))
    xlabel!(L"k")
    ylabel!(L"l")
    title!("Real part of Reconstructed data")

    c3 = heatmap(abs.(exactdata .- reconstdata))
    xlabel!(L"k")
    ylabel!(L"l")
    title!("Error")

    plot(c1, c2, c3, size = (1500, 400), layout = (1, 3))
end

# ╔═╡ Cell order:
# ╟─5c9be416-2eb0-4f7e-bc77-8a14c0cffd67
# ╟─2089fb37-7a8d-46c2-b95c-a0feab70d250
# ╠═23d20fe2-152c-4368-808d-784ab72c507b
# ╟─ab2c70f2-a83e-454a-a183-12772af3eac4
# ╟─81ef384b-b219-4214-973c-7ed8d892834a
# ╠═4bbd8548-49cc-4abf-af40-909d15cc6c75
# ╠═84e92a8c-289e-4831-88a1-f20d4d681aac
# ╟─3bfec21e-ecf6-4628-a45f-8920eef79447
# ╠═85718cda-191e-4445-bcca-0704efe5d6b1
# ╟─02d6bed8-69a6-4b4c-852a-60d9fe52c4db
# ╠═1b129c10-2143-4235-95b2-0eb60885f7e0
# ╟─314c5b5a-5c3f-4c96-b004-02743bab093a
# ╠═1cbf3d00-d1a2-40ee-af13-7d725bd0c195
# ╟─327f847d-de5f-4e40-9888-450283f92c4e
# ╠═b9f728f1-2265-4e0e-95f2-49c7b97d0421
# ╟─89dd01d2-c9fc-4d69-a5b6-3303850bbe8c
# ╠═5f1dcbb3-1f0d-4263-8440-212f0b7f52b6
# ╠═77a9f7c9-36fe-4721-b6c3-7712930c3cf1
# ╠═7348acb0-1e9c-493a-b192-facfd2d00109
# ╟─87937f1f-eb60-40ea-b0ac-9bef4ce98637
# ╠═0c1da36b-686c-4850-a0a0-ac4652d0b0ce
# ╠═baabe2d4-d2c9-4932-af0a-b363854655ad
# ╠═35a93fe6-fa5e-4172-a7d2-228996cf9f5c
# ╟─0fb125ca-eeec-4ada-ac62-12f45e486952
# ╠═4fc4e652-c883-42b9-a049-79041773a584
# ╠═028094a0-16f7-4026-9c71-7bd6c31a1ce2
