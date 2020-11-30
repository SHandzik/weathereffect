### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 68a2e920-2f0b-11eb-303f-ab454aa3adf7
using CSV, DataFrames, Statistics, Pipe, StatsPlots

# ╔═╡ f6914552-2f0a-11eb-1c71-6532aeb3a05a
# using Pkg

# ╔═╡ 691c3f32-2f0b-11eb-2da6-ab0dd3a71058
# Pkg.activate()

# ╔═╡ 4afea22e-2f36-11eb-213a-514b7ac84bbb
gr()

# ╔═╡ c8c20ac4-2f0c-11eb-188a-214dd5059765
suedwest_weather = CSV.File("./data/dwd_hist_weather.csv", missingstring="-999.0") |> DataFrame

# ╔═╡ e7df7cb2-3014-11eb-2924-b582da8ee188
coalesce.(suedwest_weather, 0)

# ╔═╡ 24b246ee-2f0f-11eb-26a9-3b026685cf62
nrw_avg = CSV.File("./data/dwd_season_avg_nrw1.csv") |> DataFrame

# ╔═╡ 9fcaef6c-2f22-11eb-01ee-95cc17d6c428
nrw_avg[81, :]

# ╔═╡ bce6e47c-2f23-11eb-2893-373b1495f3eb
nrw_avg[110, :]

# ╔═╡ 201419d2-2fd4-11eb-216e-fb84c1b17180
md" ##### Klimatologische Referenzperiode 1961 - 1990 gemäß WMO"

# ╔═╡ 671fb10a-2ff6-11eb-0807-51d3059841f4
md" **Durchschnittwerte für NRW in °C**"

# ╔═╡ 01809b50-2f26-11eb-24d2-8b78b32b8fbd
begin
	Rev_Winter_mean = round(mean(nrw_avg.Winter[81:110]), digits=2);
	Rev_Spring_mean = round(mean(nrw_avg.Spring[81:110]), digits=2);
	Rev_Summer_mean = round(mean(nrw_avg.Summer[81:110]), digits=2);
	Rev_Autumn_mean = round(mean(nrw_avg.Autumn[81:110]), digits=2);
end;

# ╔═╡ a8179324-2fd5-11eb-34ca-7fba899ed601
md" Winter : $Rev_Winter_mean °C  

Frühling : $Rev_Spring_mean °C

Sommer : $Rev_Summer_mean °C

Herbst : $Rev_Autumn_mean °C"

# ╔═╡ a7ce1710-2fd5-11eb-1737-a309fc117e03


# ╔═╡ a779d3c8-2fd5-11eb-07c1-97b8231f2845
md" ### Blick auf den gesamten Datensatz"

# ╔═╡ e22fb79a-2f2f-11eb-1359-732958d95672
	plot(nrw_avg.Year, nrw_avg.Summer,
		reg = :true,
		line = :scatter,
		title = "Durchschnittswerte Sommer in NRW",
        legend = :none,
	    size = (600, 600))

# ╔═╡ a694a97e-2fd5-11eb-0c86-b7b80d316337
md" In der obigen Grafik fällt auf, das zwischen 1925 und 1950 "

# ╔═╡ 420acf66-2ffc-11eb-39ca-b1cf541127bf
round(std(nrw_avg.Summer[20:44]), digits=3)

# ╔═╡ b0194da2-2ffc-11eb-2d86-0718798b3763
round(std(nrw_avg.Summer[45:69]), digits=3)

# ╔═╡ d66a1a22-2ffc-11eb-1e4e-03e070904499
round(std(nrw_avg.Summer[70:94]), digits=3)

# ╔═╡ 4bf1cd92-3004-11eb-1efe-49c78d827c4c
round(std(nrw_avg.Summer[116:140]), digits=3)

# ╔═╡ 618711ba-2ffc-11eb-0ef7-6b1fe5318dcd
nrw_avg[44, :]

# ╔═╡ 45bddd28-2f3f-11eb-348f-b9f981c56a54
plot(nrw_avg.Year, nrw_avg.Winter,
		reg = :true,
		grid = :true,
		line = :scatter,
		title = "Durchschnittswerte Winter in NRW",
        legend = :none,
	    size = (600, 600))

# ╔═╡ ecc21af8-2ffd-11eb-23ec-0d4afb85d2db
round(std(nrw_avg.Winter[20:44]), digits=3)

# ╔═╡ 540aba9e-2f51-11eb-0de9-3f53e8bee3ba
round(std(nrw_avg.Winter[45:69]), digits=3)

# ╔═╡ 00789ef8-2ffe-11eb-1ca8-2d6f79ba79e3
round(std(nrw_avg.Winter[70:94]), digits=3)

# ╔═╡ 2d8d93fe-3004-11eb-0980-c38b7c5d83d4
round(std(nrw_avg.Winter[115:140]), digits=3)

# ╔═╡ 53c71ee0-2f51-11eb-29dd-6b5dfefbbece
sw_season = groupby(suedwest_weather, :Season)

# ╔═╡ b54e553e-2f51-11eb-36f3-c5f7196d1ed6
combine(sw_season, :Temp_Avg => mean)

# ╔═╡ d17930b6-3010-11eb-3f6c-d13eb178042d
mean(skipmissing(suedwest_weather.Snow))

# ╔═╡ 931f94d4-3012-11eb-2bf5-aff5d601da7c
maximum(skipmissing(suedwest_weather.Snow))

# ╔═╡ 427d8f7e-3015-11eb-3dc8-0b62cebae640
minimum(skipmissing(suedwest_weather.Snow))

# ╔═╡ 5b69a77e-2f2b-11eb-12d8-774aebc4fbb2
nrw_avg[130:140, :]

# ╔═╡ 70d29c24-3011-11eb-01ac-af35727573d7
suedwest_weather.winter

# ╔═╡ 29161544-3018-11eb-18f0-a97aa5b72c71
sw-station = groupby(suedwest_weather, :Season)

# ╔═╡ Cell order:
# ╠═f6914552-2f0a-11eb-1c71-6532aeb3a05a
# ╠═691c3f32-2f0b-11eb-2da6-ab0dd3a71058
# ╠═68a2e920-2f0b-11eb-303f-ab454aa3adf7
# ╠═4afea22e-2f36-11eb-213a-514b7ac84bbb
# ╠═c8c20ac4-2f0c-11eb-188a-214dd5059765
# ╠═e7df7cb2-3014-11eb-2924-b582da8ee188
# ╠═24b246ee-2f0f-11eb-26a9-3b026685cf62
# ╟─9fcaef6c-2f22-11eb-01ee-95cc17d6c428
# ╠═bce6e47c-2f23-11eb-2893-373b1495f3eb
# ╟─201419d2-2fd4-11eb-216e-fb84c1b17180
# ╟─671fb10a-2ff6-11eb-0807-51d3059841f4
# ╠═01809b50-2f26-11eb-24d2-8b78b32b8fbd
# ╟─a8179324-2fd5-11eb-34ca-7fba899ed601
# ╠═a7ce1710-2fd5-11eb-1737-a309fc117e03
# ╠═a779d3c8-2fd5-11eb-07c1-97b8231f2845
# ╠═e22fb79a-2f2f-11eb-1359-732958d95672
# ╠═a694a97e-2fd5-11eb-0c86-b7b80d316337
# ╠═420acf66-2ffc-11eb-39ca-b1cf541127bf
# ╠═b0194da2-2ffc-11eb-2d86-0718798b3763
# ╠═d66a1a22-2ffc-11eb-1e4e-03e070904499
# ╠═4bf1cd92-3004-11eb-1efe-49c78d827c4c
# ╠═618711ba-2ffc-11eb-0ef7-6b1fe5318dcd
# ╠═45bddd28-2f3f-11eb-348f-b9f981c56a54
# ╠═ecc21af8-2ffd-11eb-23ec-0d4afb85d2db
# ╠═540aba9e-2f51-11eb-0de9-3f53e8bee3ba
# ╠═00789ef8-2ffe-11eb-1ca8-2d6f79ba79e3
# ╠═2d8d93fe-3004-11eb-0980-c38b7c5d83d4
# ╠═53c71ee0-2f51-11eb-29dd-6b5dfefbbece
# ╠═b54e553e-2f51-11eb-36f3-c5f7196d1ed6
# ╠═d17930b6-3010-11eb-3f6c-d13eb178042d
# ╠═931f94d4-3012-11eb-2bf5-aff5d601da7c
# ╠═427d8f7e-3015-11eb-3dc8-0b62cebae640
# ╠═5b69a77e-2f2b-11eb-12d8-774aebc4fbb2
# ╠═70d29c24-3011-11eb-01ac-af35727573d7
# ╠═29161544-3018-11eb-18f0-a97aa5b72c71
