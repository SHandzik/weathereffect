### A Pluto.jl notebook ###
# v0.11.4

using Markdown
using InteractiveUtils

# ╔═╡ aa9e1430-db11-11ea-3bff-3da389d87dee
using CSV, DataFrames, VegaLite

# ╔═╡ 0798dbaa-db12-11ea-1861-6316dd491b9c
data = CSV.File("./data/03098-data.csv")  |> DataFrame

# ╔═╡ 44d659ca-db12-11ea-342d-039288315b52
head(data)

# ╔═╡ a7c82d22-db19-11ea-381c-8f5d8afe455b
wda = data[16:17]

# ╔═╡ abd57056-db15-11ea-3dc4-8be952723d55
date = data[2]

# ╔═╡ a74aacfc-db15-11ea-3da0-e3336d5a0289
wf = hcat(date, wda)

# ╔═╡ b98adc16-db38-11ea-3133-9b10845abb66
names(wf)

# ╔═╡ e2abfa28-db36-11ea-3330-5110acc84a4b
rename(wf, [:x1 => :Date])

# ╔═╡ eabf6c5c-db33-11ea-20eb-7bf9feee3e7e
rename!(wf, :1 => :Date, :2 => :MaxValue, :3 => :MinValue)

# ╔═╡ 12d7bff6-db3d-11ea-198d-bdb0403f3a56
size(wf)

# ╔═╡ Cell order:
# ╠═aa9e1430-db11-11ea-3bff-3da389d87dee
# ╠═0798dbaa-db12-11ea-1861-6316dd491b9c
# ╠═44d659ca-db12-11ea-342d-039288315b52
# ╠═a7c82d22-db19-11ea-381c-8f5d8afe455b
# ╠═abd57056-db15-11ea-3dc4-8be952723d55
# ╠═a74aacfc-db15-11ea-3da0-e3336d5a0289
# ╠═b98adc16-db38-11ea-3133-9b10845abb66
# ╠═e2abfa28-db36-11ea-3330-5110acc84a4b
# ╠═eabf6c5c-db33-11ea-20eb-7bf9feee3e7e
# ╠═12d7bff6-db3d-11ea-198d-bdb0403f3a56
