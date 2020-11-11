using CSV, Plots, DataFrames, DataFramesMeta, Pipe, Dates


dfmt = dateformat"yyyymmdd"
column_types = Dict(:MESS_DATUM => Date)

data = convert(DataFrame, CSV.read("./data/02483-data.txt", delim=';',types=column_types, dateformat=dfmt))

# Select the nessersary columns

select!(data, :2, :4, :5, :7, :10, :14, :16 :17)

# The column names are meaningless and odd.
# Let's give them some more meaningful names.




rename!(data, :1 => :Datum, :2 => :Windspitze, :3 => :Windmittel, :4 => :Niederschlagsmenge, :5 => :Schnee, :6 => :Temp_Mittel, :7 => :Temp_Max, :8 => :Temp_Min)

data.Schnee = replace(data.Schnee, -999 => 0.0)
#data.Windmittel = replace(data.Windmittel, -999 => 0)
#data.Windspitze = replace(data.Windspitze, -999 => 0)
#data.Temperatur_Min = replace(data.Temperatur_Min, -999 => 0)

filter(:Windspitze => >(30), data)
filter(:Niederschlag => >(40), data)


head(sort(data, :Temp_Max, rev = true), 10)

maximum(data.Temp_Max)
minimum(data.Temp_Min)

filter(:Temperatur_Min => <(-15), data)



   data[!, :Jahr] = year.(data[!, :Datum])
   #data[!, :Monat] = month.(data[!, :Datum])
   dataJahr = @where(data, :Temp_Max .>= 25)
   sommertag = combine(groupby(dataJahr, :Jahr), :Temp_Max => length)
  
@pipe sommertag |>
        plot(_.Jahr, _.Temp_Max_length, 
        line = :bar,
        title = "Sommertage ≥ 25°C",
        legend = :none,
        size = (1200, 600))
  
 #savefig(pltSoT, "KA-SommerTag.png")

  dataJahrT = @where(data, :Temp_Max .>= 30)
  tropentag = combine(groupby(dataJahrT, :Jahr), :Temp_Max => length)
       
        @pipe tropentag |>
             statsplot(_.Jahr, _.Temp_Max_length, 
             line = :bar,
             title = "Heißer Tag >= 30°C",
             legend = :none,
             size = (1200, 600))      

      
       
plt1 = @pipe data |>
       	plot(_.Datum, _.Temp_Max, 
	line = :scatter,
	title = "Temperaturverlauf am Kahlen Asten",
        legend = :none,
        size = (1200, 600))

#savefig(plt1, "KA-Temp_Max.png")

# Berrechnung der Jahresniederschlagsmengen

dataJahrNie = @where(data, :Niederschlagsmenge .> 0)
NieschlJahr = combine(groupby(dataJahrNie, :Jahr), :Niederschlagsmenge => sum)

pltJaNie = @pipe NieschlJahr |>
        plot(_.Jahr, _.Niederschlagsmenge_sum, 
        line = :bar,
        title = "Jahresniederschlagsmenge Kahler Asten in mm/m²",
        legend = :none,
        size = (1200, 600)) 

##
@pipe data |>
        plot(_.Datum, _.Niederschlagsmenge, 
        line = :scatter,
        title = "Niederschlagsmenge Kahler Asten in mm/m²",
        legend = :none,
        size = (1200, 600))    

#savefig(pltNi, "KA-Niederschlag.png")

@pipe data |>
       	plot(_.Datum, _.Windspitze, 
	    line = :scatter,
	    title = "Windspitzen in m/s",
        legend = :none,
        size = (1200, 600))

@pipe data |>
        plot(_.Datum, _.Windmittel, 
        line = :scatter,
        title = "Windmittel in m/s",
        legend = :none,
        size = (1200, 600))        

@pipe data |>
        plot(_.Datum, _.Schnee, 
        line = :bar,
        title = "Schneehöhe in cm",
        legend = :none,
        size = (1200, 600))   