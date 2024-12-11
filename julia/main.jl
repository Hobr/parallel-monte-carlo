using Random
using Statistics
using BenchmarkTools

struct MonteCarloPI
    radius::Float64
    rng::MersenneTwister

    MonteCarloPI(r = 1.0) = new(r, MersenneTwister(time_ns()))
end

function calculate(mc::MonteCarloPI, n::Int)
    inside = 0

    for i = 1:n
        x = rand(mc.rng) * 2mc.radius - mc.radius
        y = rand(mc.rng) * 2mc.radius - mc.radius
        if x^2 + y^2 <= mc.radius^2
            inside += 1
        end
    end

    return 4.0 * inside / n
end

function get_error(calculated_pi::Float64)
    return abs(π - calculated_pi)
end

# Run the simulation
mc = MonteCarloPI(1.0)
n_points = 1_000_000

# Benchmark and run
result = @btime calculate($mc, $n_points)

println("Estimated π: ", result)
println("Actual π: ", π)
println("Error: ", get_error(result))
