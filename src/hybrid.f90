program monte_carlo_pi_hybrid
   use, intrinsic :: iso_fortran_env, only: dp => real64
   use mpi
   implicit none

   real(dp) :: x, y, pi, area, true_area, dis
   real(dp) :: r
   real(dp) :: start_cpu, end_cpu
   integer :: start_time, end_time
   integer :: i, local_inside, global_inside, samples, local_points
   integer :: ierr, rank, size

   ! MPI
   call MPI_Init(ierr)
   call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
   call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

   ! 参数
   r = 1.0_dp
   samples = 1000000
   local_points = samples/size
   local_inside = 0
   true_area = r*r*3.141592653589793_dp

   ! 开始时间
   if (rank == 0) then
      call cpu_time(start_cpu)
      call system_clock(count=start_time)
   end if

   !$omp parallel private(x, y) reduction(+:local_inside)
   !$omp do
   do i = 1, local_points
      call random_number(x)
      call random_number(y)
      x = x*r*2.0_dp - r
      y = y*r*2.0_dp - r

      if (x*x + y*y <= r*r) then
         local_inside = local_inside + 1
      end if
   end do
   !$omp end do
   !$omp end parallel

   ! 汇总所有进程的结果
   call MPI_Reduce(local_inside, global_inside, 1, MPI_INTEGER, &
                   MPI_SUM, 0, MPI_COMM_WORLD, ierr)

   if (rank == 0) then
      ! 圆面积
      area = (real(global_inside, dp)/real(samples, dp))*(4.0_dp*r*r)
      dis = abs(area - true_area)

      ! 结束时间
      call cpu_time(end_cpu)
      call system_clock(count=end_time)

      ! 结果
      print '(A,F15.8)', '计算结果(面积): ', area
      print '(A,F15.8)', '半径: ', r
      print '(A,I10)', '样本量: ', samples
      print '(A,F15.8)', '结果精度(误差): ', dis
      print '(A,F15.8,A)', 'Wall Time: ', (end_time - start_time)/1000.0_dp, ' seconds'
      print '(A,F15.8,A)', 'CPU Time: ', (end_cpu - start_cpu), ' seconds'
   end if

   call MPI_Finalize(ierr)

end program monte_carlo_pi_hybrid
