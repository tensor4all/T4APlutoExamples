using Test
using ExampleJuggler
import Pluto

ExampleJuggler.verbose!(true)
include("common.jl")

@testset "pluto notebooks" begin
    ExampleJuggler.testplutonotebooks(PLUTO_NOTEBOOKS_DIR, PLUTO_FILE_NAMES, pluto_project=nothing)
end
