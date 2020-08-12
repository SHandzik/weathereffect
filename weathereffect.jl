using CSV, VegaLite, DataFrames

data = CSV.File("./data/03098-data.txt") |> DataFrame

# Select the nessersary columns

wda = select(data, :2 , :16, :17)

# The column names are meaningless and odd.
# Let's give them some more meaningful names.

rename!(wda, :1 => :Date, :2 => :MaxValue, :3 => :MinValue)


# The values are stored in Celsius. It is easy read for humans, but difficult to work with for a computer.
# Let's change the values to Kelvin 

nrow(wda)