module importance

   implicit none
   private

   public :: normal, omp, mpi, coarray

contains
   subroutine normal
      print *, "常规实现"
   end subroutine normal

   subroutine omp
      print *, "OpenMP实现"
   end subroutine omp

   subroutine mpi
      print *, "OpenMP+MPI实现"
   end subroutine mpi

   subroutine coarray
      print *, "Coarray实现"
   end subroutine coarray

end module importance
