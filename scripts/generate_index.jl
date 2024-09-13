function extract_title(filepath::AbstractString)
    lines = read(filepath, String)

    title = ""
    searchingmd = false
    foundtitle = false

    for l in split(lines, "\n")
        foundtitle && break
        if !isnothing(match(r"md\"\"\"", l))
            searchingmd = true
            continue
        end

        if searchingmd
            m = match(r"#\s*", l)
            if !isnothing(m)
                title_ = lstrip(l[nextind(l, m.offset + 1):end])
                title = replace(title_, r"\"\"\"" => "")
                foundtitle = true
            end
        end

        if searchingmd
            isnothing(match(r"\"\"\"", l))
            searchingmd = false
        end
    end
    if isempty(title)
        @warn "Couldn't find title. Using file name as title"
        title = basename(file)
    end
    return title
end

const PLUTO_NOTEBOOKS_DIR = joinpath(dirname(@__DIR__), "pluto_notebooks")

const PLUTO_FILE_NAMES = [
    "welcome.jl",
    "quantics1d.jl",
    "quantics1d_advanced.jl",
    "compress.jl",
    "interfacingwithitensors.jl",
    "quantics2d.jl",
    "plots.jl",
    "qft.jl",
]

open(joinpath(PLUTO_NOTEBOOKS_DIR, "index.md"), "w") do io
    write(io, "# Notebooks\n")

    for f in PLUTO_FILE_NAMES
        title = extract_title(joinpath(PLUTO_NOTEBOOKS_DIR, f))
        link = splitext(basename(f))[begin] * ".html"
        @show title
        write(io, "- [$(title)]($link)\n")
    end
end
