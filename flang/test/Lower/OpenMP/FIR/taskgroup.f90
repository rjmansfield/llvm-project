! REQUIRES: openmp_runtime

!RUN: %flang_fc1 -emit-fir -flang-deprecated-no-hlfir -fopenmp %s -o - | FileCheck %s

!CHECK-LABEL: @_QPomp_taskgroup
subroutine omp_taskgroup
use omp_lib
integer :: allocated_x
!CHECK-DAG: %{{.*}} = fir.alloca i32 {bindc_name = "allocated_x", uniq_name = "_QFomp_taskgroupEallocated_x"}
!CHECK-DAG: %{{.*}} = arith.constant 4 : i64

!CHECK: omp.taskgroup  allocate(%{{.*}} : i64 -> %0 : !fir.ref<i32>)
!$omp taskgroup allocate(omp_high_bw_mem_alloc: allocated_x)
!$omp task
!CHECK: fir.call @_QPwork() {{.*}}: () -> ()
   call work()
!CHECK: omp.terminator
!$omp end task
!CHECK: omp.terminator
!$omp end taskgroup
end subroutine
