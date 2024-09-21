using PlutoSliderServer
include("common.jl")
PLUTO_NOTEBOOKS_DIR = joinpath(dirname(@__DIR__), "pluto_notebooks")

PlutoSliderServer.export_directory(PLUTO_NOTEBOOKS_DIR)
