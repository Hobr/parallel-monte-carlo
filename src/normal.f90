program normal
   use, intrinsic :: iso_fortran_env, only: dp => real64
   implicit none

   real(dp) :: x, y, area, true_area, dis
   real(dp) :: r
   real(dp) :: start_cpu, end_cpu
   integer :: start_time, end_time
   integer :: i, inside_points, samples

   ! 参数
   r = 1.0_dp
   samples = 100000000
   inside_points = 0
   true_area = r*r*3.141592653589793_dp

   ! 开始时间
   call cpu_time(start_cpu)
   call system_clock(count=start_time)

   ! 蒙特卡洛
   do i = 1, samples
      call random_number(x)
      call random_number(y)
      x = x*r*2.0_dp - r
      y = y*r*2.0_dp - r

      if (x*x + y*y <= r*r) then
         inside_points = inside_points + 1
      end if
   end do

   ! 圆面积
   area = (real(inside_points, dp)/real(samples, dp))*(4.0_dp*r*r)
   dis = abs(area - true_area)

   ! 结束时间
   call cpu_time(end_cpu)
   call system_clock(count=end_time)

   ! 结果
   print '(A,F15.8)', '计算结果(面积): ', area
   print '(A,F15.8)', '半径: ', r
   print '(A,I10)', '样本量: ', samples
   print '(A,F15.8)', '结果精度(误差): ', dis
   print '(A,F15.8,A)', 'Wall Time: ', (end_time - start_time)/1000.0_dp, '秒'
   print '(A,F15.8,A)', 'CPU Time: ', (end_cpu - start_cpu), '秒'
end program normal
