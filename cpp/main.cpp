#include "algorithm/adaptive/basic.hpp"
#include "algorithm/importance/basic.hpp"
#include "algorithm/monte/basic.hpp"
#include "algorithm/quasi/basic.hpp"
#include "algorithm/stratified/basic.hpp"
#include "util/statistics.hpp"
#include "util/timer.hpp"
#include <iostream>
#include <random>

int main(int argc, char **argv)
{
    size_t samples = 1000000;
    double radius = 1.0;

    std::mt19937 random_engine(42);

    /*
        基本蒙特卡洛
    */
    std::cout << "基本蒙特卡洛" << std::endl;
    monte::basic::GeneralMonteCarlo general_mc;
    auto result_general = general_mc.compute(samples, radius, random_engine);
    std::cout << "常规: " << result_general.result << std::endl;

    monte::basic::BatchMonteCarlo batch_mc;
    auto result_batch = batch_mc.compute(samples, radius, random_engine);
    std::cout << "批处理: " << result_batch.result << std::endl;

    monte::basic::SymmetryMonteCarlo symmetry_mc;
    auto result_symmetry = symmetry_mc.compute(samples, radius, random_engine);
    std::cout << "对称性优化: " << result_symmetry.result << std::endl;

    /*
        重要性采样
    */
    std::cout << "重要性采样" << std::endl;
    monte::importance::ImportanceSampling importance_sampling;
    auto result_importance = importance_sampling.compute(samples, radius, random_engine);
    std::cout << "常规: " << result_importance.result << std::endl;

    /*
        分层采样
    */
    std::cout << "分层采样" << std::endl;
    monte::stratified::GeneralStratifiedSampling stratified_general;
    auto result_stratified_general = stratified_general.compute(samples, radius, random_engine);
    std::cout << "常规: " << result_stratified_general.result << std::endl;

    monte::stratified::ImportanceStratifiedSampling stratified_importance;
    auto result_stratified_importance = stratified_importance.compute(samples, radius, random_engine);
    std::cout << "重要性-分层: " << result_stratified_importance.result << std::endl;

    /*
        自适应采样
    */
    std::cout << "自适应采样" << std::endl;
    monte::adaptive::AdaptiveSampling adaptive_sampling;
    auto result_adaptive = adaptive_sampling.compute(samples, radius, random_engine);
    std::cout << "常规 " << result_adaptive.result << std::endl;

    /*
        拟蒙特卡洛序列
    */
    std::cout << "拟蒙特卡洛序列" << std::endl;
    monte::quasi::SobolSequence sobol_sequence;
    auto result_sobol = sobol_sequence.compute(samples, radius);
    std::cout << "Sobol序列: " << result_sobol.result << std::endl;

    monte::quasi::HaltonSequence halton_sequence;
    auto result_halton = halton_sequence.compute(samples, radius);
    std::cout << "Halton序列: " << result_halton.result << std::endl;

    monte::quasi::FaureSequence faure_sequence;
    auto result_faure = faure_sequence.compute(samples, radius);
    std::cout << "Faure序列: " << result_faure.result << std::endl;

    return 0;
}
