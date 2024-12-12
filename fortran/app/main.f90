program main
   use base, only: base_test => test
   use monte, only: monte_normal => normal, monte_omp => omp, monte_mpi => mpi, monte_coarray => coarray
   use stratified, only: stratified_normal => normal, stratified_omp => omp, stratified_mpi => mpi, stratified_coarray => coarray
   use importance, only: importance_normal => normal, importance_omp => omp, importance_mpi => mpi, importance_coarray => coarray
   use quasi, only: quasi_normal => normal, quasi_omp => omp, quasi_mpi => mpi, quasi_coarray => coarray
   implicit none

   call base_test()

   ! 基本蒙特卡洛算法
   print *, "基本蒙特卡洛算法"
   call monte_normal()
   call monte_omp()
   call monte_mpi()
   call monte_coarray()

   ! 分层采样
   print *, "分层采样"
   call stratified_normal()
   call stratified_omp()
   call stratified_mpi()
   call stratified_coarray()

   ! 重要性采样
   print *, "重要性采样"
   call importance_normal()
   call importance_omp()
   call importance_mpi()
   call importance_coarray()

   ! 拟蒙特卡洛序列
   print *, "拟蒙特卡洛序列"
   call quasi_normal()
   call quasi_omp()
   call quasi_mpi()
   call quasi_coarray()

end program main
