### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# ╔═╡ 5dffb70c-45a2-460c-a641-de830b86cfad
begin
	using Pkg
	Pkg.activate(".")
	Pkg.instantiate()
end

# ╔═╡ cab957dc-3617-4456-95cb-9b0f46817eb6
# This cell only has to be executed once to install all the necessary packages

begin
	Pkg.add([
    	"Statistics",
    	"Dates",
    	"CSV",
    	"DataFrames",
    	"Query",
    	"Pipe",
    	"Gadfly",
    	])
end

# ╔═╡ 6208fc80-f7ca-426c-ac17-4e7a0fd50c5c
using CSV, DataFrames, Statistics, Pipe, Gadfly, Query, Dates

# ╔═╡ 1784d91a-9c35-11eb-2864-4121a103c646
md"**Vorabversion HTML Static**"

# ╔═╡ 6f92f150-33d7-4043-9be2-647348bd699d
md"# Auswirkungen des Klimawandel in Südwestfalen 
## am Beispiel der Grünlandtemperatursumme" 

# ╔═╡ d58ea5c1-e60f-4aa2-b503-c725dcde83ee
md"
**Disclaimer:** 
*Für diese Auswertung werden die Messdaten einzelner Wetterstation herangezogen. Es kann nicht ausgeschlossen werden, dass es durch Standort bedingte Einflüße zu Verzehrungen kommt.*

Der Klimawandel ist seit langer Zeit ein Thema. Anhand von Wetteraufzeigungen der vom Deutschen Wetterdienst betriebenen Wetterstation soll gezeigt werden, welche Auswirkung in Südwestfalen nachweisbar sind. 
Um die Anschaulichkeit zu verbessern und nicht auf pure Statistik zu setzen, wird für die Auswertung die Grünlandtemperatursumme verwendet. Es ist ein errechneter Temperaturwert der in der Agrarmeterologie verwandt wird.

Die verwendeten Rohdaten sind über das [Open Data](https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/) Portal des [DWD](http://dwd.de) verfügbar.

Zunächst einmal gilt es, die Arbeitsumgebung vorzubereiten."

# ╔═╡ 73d1bacf-60a4-4e22-8a9e-46a10baa8841
md"## Auf geht es!"

# ╔═╡ 6d80c7e9-3d65-4ce6-9224-fcc9767ac71a
md"**Laden der notwendigen Programmpaket**"

# ╔═╡ deb77d49-fb02-4bbd-a70b-3d9e0eb0e6a2
md"**Laden der Rohdaten**"

# ╔═╡ e43c00e3-bd89-4e46-a45e-ef529bc27caf
suedwest_weather = CSV.File("./data/dwd_hist_weather.csv") |> DataFrame;

# ╔═╡ ea5e7228-5fe2-4f7f-915b-cdece11344d6
first(suedwest_weather, 10)

# ╔═╡ e0514b1f-e72f-42e7-b773-9e5f28ddcb6e
md"### Die Grünlandtemperatursumme
Die Grünlandtemperatursumme ist ein errechneter Temperaturwert der in der Agrarmeterologie verwandt wird."

# ╔═╡ 73240757-fba1-47b7-99fe-1dc15d3d3c28
md"##### Hintergrund"

# ╔═╡ b087acef-a974-4cb6-8a39-00a167cb1ffb
md"Ab einem Summenwert von 200°C ist die Vegatationruhe des Winters beendet und das Pflanzenwachstum startet. Die Böden haben sich soweit erwärmt, dass sie Nährstoffe bereitstellen können. Kurz gesagt, es kann als faktischer Frühjahresbeginn gewertet werden. \
Um die Grünlandtemperatursumme zu errechnen, werden alle positiven Tagesmittelwerte addiert. Dabei wird nachfolgende Berechnungsformel angewendet"

# ╔═╡ c92bc708-e9dd-44f5-b6dd-7149b5d53d4d
md"
* Im Januar wird die Summe mit 0,5 multipliziert
* Im Februar wird die Summe mit 0,75 multipliziert
* Ab März gilt die errechnete Temperatursumme ohne Abschlag"

# ╔═╡ 03574fdf-7b93-4182-9cef-96ccb51b7ddb
md"##### Die Wetterstationen und Zeiträume


| Station | Kreis | Zeitraum | Stationshöhe |
| :-----: | :----: | :-----:  |----:|
| Kahler Asten | Hochsauerlandkreis   | 1955 bis 2019 | 839 m |
| Lüdenscheid | Märkische Kreis | 1950 bis 1995 | 444 m |
| Lüdenscheid | Märkische Kreis | 1994 bis 2019 | 386 m |
| Bad Sassendorf | Kreis Soest | 1950 bis 1980 | 81 m |
| Lippstadt | Kreis Soest | 1981 bis 2019 | 92 m |
| Lennestadt | Kreis Olpe | 1962 bis 2019 | 286 m|

Leider liegen nicht für alle Wetterstationen Daten für den Zeitraum 1950 bis 2020 vor.\
Starke beschädigungen durch den zweiten Weltkrieg machten die Wettermessung am Kahlen Aster erst 1955 wieder möglich.  \
In Lennestadt, im Kreis Olpe, wurde die Messreihe erst 1962 begonnen. \
Die Wetterstationen Lüdenscheid und im Kreis Soest wechselten in dem betrachteten Zeitraum den Standort. Für die in dieser Auswertung ist das aber nicht relevant."

# ╔═╡ 4a3cec0e-31c1-467b-b93a-4d07c0d26f23
md"**Selektion der Daten**"

# ╔═╡ 238d368c-1630-45c7-ae6d-6fcb518e4a17
begin
	gtsdata = suedwest_weather |> @query(i, begin
            @where i.Year >= 1950 && i.Month <= 5 && i.Temp_Avg >= 0.0
            @select {i.Station_ID, i.Date, i.Month, i.Year, i.Temp_Avg}
    end) |> DataFrame

	first(gtsdata, 10)
end	

# ╔═╡ cf4dfb85-6b83-449a-b414-e330792792de
md"**Erstellen eines leeren Dataframes um die errechneten Grünlandtemperatursummen abspeichern zu können**"

# ╔═╡ b3275947-3f71-4857-8f62-855e480f0aad
gtsdf = DataFrame(Station_ID = Int64[], Year = Int64[], Day = Int64[], Date = Date[], Gts_Temp = Float64[])

# ╔═╡ 3bbfaf47-28d5-4496-a449-178382c135ef
begin
	stationen = unique(gtsdata.Station_ID);
	countStationen = size(stationen);	

	for s in 1:6
    	gtsYearRange = gtsdata |> @query(i, begin
            @where i.Station_ID == stationen[s]
            @select {i.Year}
    	end) |> DataFrame

    gtsYearRangeMin = minimum(gtsYearRange.Year)
    gtsYearRangeMax = maximum(gtsYearRange.Year)

    iyearRange = gtsYearRangeMin:gtsYearRangeMax
    
     
    for iyear in iyearRange
        gtsJanDf = gtsdata |> @query(i, begin
            @where i.Year == iyear && i.Month == 1 && i.Station_ID == stationen[s]
            @select {i.Date, i.Temp_Avg}
        end) |> DataFrame
    
        gtsJan = sum(gtsJanDf.Temp_Avg) * 0.5
    
        gtsFebDf = gtsdata |> @query(i, begin
            @where i.Year == iyear && i.Month == 2 && i.Station_ID == stationen[s]
            @select {i.Date, i.Temp_Avg}
        end) |> DataFrame       
    
        gtsFeb = sum(gtsFebDf.Temp_Avg) * 0.75
    
        gtsMarDf = gtsdata |> @query(i, begin
            @where i.Year == iyear && i.Month > 2 && i.Station_ID == stationen[s]
            @select {i.Date, i.Temp_Avg}
        end) |> DataFrame
    
        daycounter = 1
        gts = round((gtsJan + gtsFeb), digits=2)
        
        while gts <= 200
           gts = gts + gtsMarDf.Temp_Avg[daycounter]
           daycounter = daycounter + 1
        end
    
        gtsdate = gtsMarDf[daycounter, :]
        gtsday = dayofyear(gtsdate.Date)
        push!(gtsdf, [stationen[s], iyear, gtsday, gtsdate.Date, gts])
    
    	end
	end
end;

# ╔═╡ 57f77db9-6090-4aa8-bd95-8be37372eff8
md"**Die errechneten Temperatursummen**

Blick auf die erst 15 Zeilen des Datensatzes"

# ╔═╡ 04bdf109-4149-4cdd-ab2a-8f8bc1d1aacf
first(gtsdf, 15)

# ╔═╡ 2d201056-fa7a-49a0-8405-0f243ff51d0d
size(gtsdf)[1]

# ╔═╡ 6fa7149c-95a5-4c7c-9851-853e702f3ca4
md"**Separieren der Stationen für einen Plot**"

# ╔═╡ c32dfce0-3ffe-45f5-a9fd-b06bda9cb789
lued = gtsdf |> @query(i, begin
            @where i.Station_ID == 3096 || i.Station_ID == 3098
            @select {i.Year, i.Day, i.Date, i.Gts_Temp}
    end) |> DataFrame;
  

# ╔═╡ 40124993-bb7d-4fe3-8acc-138c34e6f329
soest = gtsdf |> @query(i, begin
            @where i.Station_ID == 4401 || i.Station_ID == 3031
            @select {i.Year, i.Day, i.Date, i.Gts_Temp}
    end) |> DataFrame; 

# ╔═╡ d3d94f39-5468-4ffa-a1db-0c9c08eafcaf
hsk = gtsdf |> @query(i, begin
            @where i.Station_ID == 2483
            @select {i.Year, i.Day, i.Date, i.Gts_Temp}
    end) |> DataFrame;

# ╔═╡ 99b8ce6a-cae1-401b-b5df-a384a3508427
olpe = gtsdf |> @query(i, begin
            @where i.Station_ID == 2947
            @select {i.Year, i.Day, i.Date, i.Gts_Temp}
    end) |> DataFrame;  

# ╔═╡ d4527c64-c9e0-4b3b-8548-5cff944e8866
set_default_plot_size(20cm,10cm)

# ╔═╡ 1bb47005-4c83-4800-904c-4302358fb009
md"### Auswertung"

# ╔═╡ edb99c8d-d7e8-48dd-ab1f-7e4aa5665227
md" #### Charts, Klimamittel etc."

# ╔═╡ 4d6d9a99-a8ce-4102-a3c2-4552050b3603
md"**Station Lüdenscheid**"

# ╔═╡ b0952093-d55a-45f6-87cc-e35128d4c96f
plot(lued, x=:Year, y=:Day, Geom.point, color=:Day, Guide.colorkey(title="Tage", labels=[">90","≤90"]), Guide.title("Station Lüdenscheid"),  Guide.xlabel("Jahr"), Guide.ylabel("Tage bis 200°C"))

# ╔═╡ d844dc41-cf14-4f9d-a25a-da4eba0fdc02
md"**Die letzten fünf Jahre**"

# ╔═╡ f24e4a58-8c2a-43bf-a2c9-709ea4d5d829
filter(:Year => >(2015), lued)

# ╔═╡ d18f6af4-77c5-412c-95e6-b4ccc4d101d1
md"**Station Kreis Soest**"

# ╔═╡ 687ece5e-132a-48a2-8d48-bf3add52066d
plot(soest, x=:Year, y=:Day, Geom.point, color=:Day,
     Guide.colorkey(title="Tage", labels=[">90","≤90"]), Guide.title("Station Kreis Soest"), Guide.xlabel("Jahr"), Guide.ylabel("Tage bis 200 °C"))

# ╔═╡ cae77058-783d-4c51-a2b0-331ea6a50a0d
md"**Die letzten fünf Jahre**"

# ╔═╡ dd37791f-2a1a-471d-a2d4-ff13ce86320b
filter(:Year => >(2015), soest)

# ╔═╡ a18d6108-c387-4d08-926e-93651507d6a9
md"**Station Kahler Asten**"

# ╔═╡ df35c3ba-6bce-4666-bfcd-a7aee207b03b
plot(hsk, x=:Year, y=:Day, Geom.point, color=:Day,
     Guide.colorkey(title="Tage", labels=[">90","≤90"]), Guide.title("Station Kahler Asten"), Guide.xlabel("Jahr"), Guide.ylabel("Tage"))

# ╔═╡ 549f6836-154b-49a0-8c00-14fa77ce467f
md"**Die letzten fünf Jahre**"

# ╔═╡ b61debaa-da20-44ba-bba0-2133da33e4fa
filter(:Year => >(2015), hsk)

# ╔═╡ 39078d88-672d-4cf8-9073-418d413e1b91
md"**Station Lennestadt Kreis Olpe**"

# ╔═╡ d2615ce0-dbe3-4c88-a1ca-3c76fa049524
plot(olpe, x=:Year, y=:Day, Geom.point, color=:Day,
     Guide.colorkey(title="Tage", labels=[">90","≤90"]), Guide.title("Station Lennestadt"), Guide.xlabel("Jahr"), Guide.ylabel("Tage"))

# ╔═╡ 14968b3c-830a-42dd-9731-3fbf61dac0f6
md"**Die letzten fünf Jahre**"

# ╔═╡ c1620603-9a2c-41c1-8cd4-be7e9aa03443
filter(:Year => >(2015), olpe)

# ╔═╡ b5df1108-0273-494a-a12b-5860e094ce04
md"### Was wurde gemacht?

Die Temperatursumme wurden gemäß der Formel berechnet. Wird der Schwellwert von 200°C überschritten wird das Datum ausgelesen und der Tag des Jahres ermittelt. Es handelt sich um einen fortlaufende Zählung. Der 1. Januar ist Tag 1 der 2. Januar Tag 2 der 31. Dezember Tag 365/366. 
Auf der x-Achse ist die Zeit dargestellt, auf der y-Achse der Tag an dem die Wärmesumme erreicht wird.

Zur Orientierung:
* der 1. März ist Tag 59
* der 1. April ist Tag 90

In einem zweiten Schritte wurden die Klimamittel errechnet. Einmal für den Zeitraum von 1951 bis 1980, und von 1991 bis 2020.
Aus den schon erwähnten Gründen, weicht die Referenzperiode am Kahlen Asten ab. Bei der Station Lennestadt ist die Messreihe zu kurz um zwei Klimamittel errechnen zu können.  

### Was ist zu sehen?
* Die Temperatursummen werden früher im Jahr erreicht.
* An allen Station ist eine Streuung von etwa 40 Tagen zwischen dem Minimalen und Maximalen Wert zu beobachen. Diese Streuung ist auch über den gesamten Zeitraum weitgehend konstant. 
* Im Vergleich der Klimamittel ist die Temperatursumme heute rund 11 Tage füher erreicht, als es in der Refenrenzperiode der Fall war.
* Das es am Standort Lüdenscheid abweichungen gibt (9 Tage) kann am Ort der Messtation liegen. Die Wetterstation befand sich zu diesem Zeitpunkt (1951 bis 1980) am Zeppelin-Gymnasium, mitten in der Stadt Lüdenscheid. Seit 1994 befindet sich die Station in Lüdenscheid-Oberhunscheid.
* Von 1989 bis etwa 2004 ist eine Häufung von milden Jahre zu beobachen. Besonders ausgeprägt ist es an der Station Kahler zu sehen. An den Stationen Soest, Lennestadt und Lüdenscheid ist der Trend ebenfalls aber weniger ausgeprägt zu beobachten. In den Jahren bis 2020 nimmt die Streuung wieder zu. Da dieses Muster an allen Stationen in Südwestfalen zu beobacheten ist, können kleinräumige Wettereffekte ausgeschlossen werden. Ein möglicher Grund für dieses Muster sind beeinflußungen durch die [Nordatlantische Oszillation](https://www.geomar.de/entdecken/artikel/die-nordatlantische-oszillation-und-ihr-einfluss-auf-das-klima-in-europa) die in diesem Zeitraum sehr ausgeprägt war.


### Wird sich der Trend Fortsetzen?
Ja und Nein. Zum einen wird sich der in den letzten Jahren etablierte Trend zu milden Wintern und einen frühen Frühjahr, im Rahmen der natürlichen Fluktuation, fortsetzen. Auf der andern Seite zeigen die Charts auch eine Bodenbildung. Im Kreis Soest ist das bei 60 Tagen, etwa dem 1.März, in Lüdenscheid um den 10. März, zu beobachten. Es bleibt abzuwarten, ob diese werte signifikant unterschritten werden. "

# ╔═╡ 54032c0c-c00f-4104-b1fa-a93ce66c7320
md" ## Viel Dank für Ihre Aufmerksamkeit"

# ╔═╡ 6bf38b05-2db8-40b6-804c-a3feaa65a9f7


# ╔═╡ 2b149c9b-027a-4230-ba03-65eca99d7bb6


# ╔═╡ 4346e53b-474c-49e5-8dd7-5abe071a7d6f


# ╔═╡ bd404afd-c344-40e6-87d9-87cf75fcb4a8
md"#### Berechnung Klimamittel"

# ╔═╡ 1db0ca81-ba58-4c6e-a98f-0d2666a07866
begin
	lued_klimit_1 = filter(:Year => <(1981), lued)
	lued_klimit_2 = lued_klimit_1[2:end, :]
	klimit_1 = combine(lued_klimit_2, :Day => mean)
	klimit_1md = klimit_1.Day_mean[1]
end;


# ╔═╡ 1ceab331-3af1-4296-b84f-67c0e67e7cae
begin
	lued_klimit_3 = filter(:Year => >(1990), lued);
	klimit_2 = combine(lued_klimit_3, :Day => mean);
	klimit_3 = klimit_2.Day_mean[1]
end;

# ╔═╡ 2db35e2d-1166-480e-b78c-4415d19a3bb9
md" Klimamittel 1951 - 1980: $klimit_1md Tage\
Klimamittel 1991 - 2020: $klimit_3 Tage"

# ╔═╡ 4db28e81-2b14-4f00-97c9-4c9adebdd57e
begin
	soest_klimit_1 = filter(:Year => <(1981), soest)
	soest_klimit_2 = soest_klimit_1[2:end, :]
	klimit_so1 = combine(soest_klimit_2, :Day => mean)
	klimit_so1md = klimit_so1.Day_mean[1]
	soest_klimit_3 = filter(:Year => >(1990), soest)
	klimit_so2 = combine(soest_klimit_3, :Day => mean)
	klimit_so2md = klimit_so2.Day_mean[1]
end;

# ╔═╡ bae2d70b-511a-417f-8f92-b26d3513bfa3
md" Klimamittel 1951 - 1980: $klimit_so1md Tage\
Klimamittel 1991 - 2020: $klimit_so2md Tage"

# ╔═╡ b7a7ed1f-2d03-401d-a917-73436c0f6e6b
begin
	hsk_klimit_1 = filter(:Year => <(1985), hsk)
	klimit_hsk1 = combine(hsk_klimit_1, :Day => mean)
	klimit_hsk1md = klimit_hsk1.Day_mean[1]
	hsk_klimit_2 = filter(:Year => >(1990), hsk)
	klimit_hsk2 = combine(hsk_klimit_2, :Day => mean)
	klimit_hsk2md = klimit_hsk2.Day_mean[1]
end;

# ╔═╡ 29c15d1e-617c-4990-b52d-25af00599554
md" Klimamittel 1955 - 1984: $klimit_hsk1md Tage\
Klimamittel 1991 - 2020: $klimit_hsk2md Tage"

# ╔═╡ 6cbc2474-1b2f-4df4-848e-e20098b497b3
begin
	olpe_klimit_1 = filter(:Year => <(1992), olpe)
	klimit_oe1 = combine(olpe_klimit_1, :Day => mean)
	klimit_oe1md = klimit_oe1.Day_mean[1]
end;

# ╔═╡ b8e348f0-4754-424b-b74a-e7c5d90cd33f
md" Klimamittel 1962 - 1991: $klimit_oe1md Tage"

# ╔═╡ 6613100d-1ec6-487e-b0b3-eceafabfe6bc


# ╔═╡ Cell order:
# ╟─1784d91a-9c35-11eb-2864-4121a103c646
# ╟─6f92f150-33d7-4043-9be2-647348bd699d
# ╟─d58ea5c1-e60f-4aa2-b503-c725dcde83ee
# ╟─73d1bacf-60a4-4e22-8a9e-46a10baa8841
# ╟─6d80c7e9-3d65-4ce6-9224-fcc9767ac71a
# ╠═5dffb70c-45a2-460c-a641-de830b86cfad
# ╠═cab957dc-3617-4456-95cb-9b0f46817eb6
# ╠═6208fc80-f7ca-426c-ac17-4e7a0fd50c5c
# ╟─deb77d49-fb02-4bbd-a70b-3d9e0eb0e6a2
# ╠═e43c00e3-bd89-4e46-a45e-ef529bc27caf
# ╟─ea5e7228-5fe2-4f7f-915b-cdece11344d6
# ╟─e0514b1f-e72f-42e7-b773-9e5f28ddcb6e
# ╟─73240757-fba1-47b7-99fe-1dc15d3d3c28
# ╟─b087acef-a974-4cb6-8a39-00a167cb1ffb
# ╟─c92bc708-e9dd-44f5-b6dd-7149b5d53d4d
# ╟─03574fdf-7b93-4182-9cef-96ccb51b7ddb
# ╟─4a3cec0e-31c1-467b-b93a-4d07c0d26f23
# ╟─238d368c-1630-45c7-ae6d-6fcb518e4a17
# ╟─cf4dfb85-6b83-449a-b414-e330792792de
# ╟─b3275947-3f71-4857-8f62-855e480f0aad
# ╟─3bbfaf47-28d5-4496-a449-178382c135ef
# ╟─57f77db9-6090-4aa8-bd95-8be37372eff8
# ╠═04bdf109-4149-4cdd-ab2a-8f8bc1d1aacf
# ╠═2d201056-fa7a-49a0-8405-0f243ff51d0d
# ╟─6fa7149c-95a5-4c7c-9851-853e702f3ca4
# ╠═c32dfce0-3ffe-45f5-a9fd-b06bda9cb789
# ╠═40124993-bb7d-4fe3-8acc-138c34e6f329
# ╠═d3d94f39-5468-4ffa-a1db-0c9c08eafcaf
# ╠═99b8ce6a-cae1-401b-b5df-a384a3508427
# ╠═d4527c64-c9e0-4b3b-8548-5cff944e8866
# ╟─1bb47005-4c83-4800-904c-4302358fb009
# ╟─edb99c8d-d7e8-48dd-ab1f-7e4aa5665227
# ╟─4d6d9a99-a8ce-4102-a3c2-4552050b3603
# ╟─b0952093-d55a-45f6-87cc-e35128d4c96f
# ╟─2db35e2d-1166-480e-b78c-4415d19a3bb9
# ╟─d844dc41-cf14-4f9d-a25a-da4eba0fdc02
# ╟─f24e4a58-8c2a-43bf-a2c9-709ea4d5d829
# ╟─d18f6af4-77c5-412c-95e6-b4ccc4d101d1
# ╟─687ece5e-132a-48a2-8d48-bf3add52066d
# ╟─bae2d70b-511a-417f-8f92-b26d3513bfa3
# ╟─cae77058-783d-4c51-a2b0-331ea6a50a0d
# ╟─dd37791f-2a1a-471d-a2d4-ff13ce86320b
# ╟─a18d6108-c387-4d08-926e-93651507d6a9
# ╟─df35c3ba-6bce-4666-bfcd-a7aee207b03b
# ╟─29c15d1e-617c-4990-b52d-25af00599554
# ╟─549f6836-154b-49a0-8c00-14fa77ce467f
# ╟─b61debaa-da20-44ba-bba0-2133da33e4fa
# ╟─39078d88-672d-4cf8-9073-418d413e1b91
# ╟─d2615ce0-dbe3-4c88-a1ca-3c76fa049524
# ╟─b8e348f0-4754-424b-b74a-e7c5d90cd33f
# ╟─14968b3c-830a-42dd-9731-3fbf61dac0f6
# ╟─c1620603-9a2c-41c1-8cd4-be7e9aa03443
# ╟─b5df1108-0273-494a-a12b-5860e094ce04
# ╟─54032c0c-c00f-4104-b1fa-a93ce66c7320
# ╟─6bf38b05-2db8-40b6-804c-a3feaa65a9f7
# ╟─2b149c9b-027a-4230-ba03-65eca99d7bb6
# ╟─4346e53b-474c-49e5-8dd7-5abe071a7d6f
# ╟─bd404afd-c344-40e6-87d9-87cf75fcb4a8
# ╠═1db0ca81-ba58-4c6e-a98f-0d2666a07866
# ╠═1ceab331-3af1-4296-b84f-67c0e67e7cae
# ╠═4db28e81-2b14-4f00-97c9-4c9adebdd57e
# ╠═b7a7ed1f-2d03-401d-a917-73436c0f6e6b
# ╠═6cbc2474-1b2f-4df4-848e-e20098b497b3
# ╠═6613100d-1ec6-487e-b0b3-eceafabfe6bc
