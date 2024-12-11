#include <chrono>
#include <cmath>
#include <iostream>
#include <random>

class MonteCarloPI {
private:
    std::mt19937_64 rng;
    double radius;
    size_t points;

public:
    MonteCarloPI(double r = 1.0) : radius(r) {
        // Seed with high-resolution clock
        rng.seed(std::chrono::high_resolution_clock::now().time_since_epoch().count());
    }

    double calculate(size_t n) {
        points = n;
        size_t inside = 0;
        std::uniform_real_distribution<double> dist(-radius, radius);

        for (size_t i = 0; i < points; ++i) {
            double x = dist(rng);
            double y = dist(rng);
            if (x*x + y*y <= radius*radius) {
                inside++;
            }
        }

        return 4.0 * inside / points;
    }

    // Get error estimate
    double getError(double calculated_pi) const {
        return std::abs(M_PI - calculated_pi);
    }
};

int main() {
    MonteCarloPI mc(1.0);

    auto start = std::chrono::high_resolution_clock::now();
    double result = mc.calculate(1000000);
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsed = end - start;

    std::cout << "Estimated PI: " << result << std::endl;
    std::cout << "Actual PI: " << M_PI << std::endl;
    std::cout << "Error: " << mc.getError(result) << std::endl;
    std::cout << "Time taken: " << elapsed.count() << " seconds" << std::endl;

    return 0;
}
