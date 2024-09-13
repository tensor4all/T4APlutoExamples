using PlutoSliderServer

pluto_notebooks = joinpath(dirname(@__DIR__), "pluto_notebooks")

PlutoSliderServer.export_directory(pluto_notebooks)
