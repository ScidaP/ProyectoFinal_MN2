program prod_vectorial_mpi
    use mpi
    implicit none

    integer, parameter :: N = 32  ! Tamaño del vector
    integer :: arre1(N), arre2(N), cant_pasos, tama, nva_a, nva_b
    integer :: ID_Proceso, TotalProcesos, ierr, i
    integer :: resultado_i, resultado_t
    double precision :: start_time, end_time, execution_time, total_execution_time

    ! Inicializar MPI
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, ID_Proceso, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, TotalProcesos, ierr)

    ! Crear los vectores de entrada
    do i = 1, N
        arre1(i) = i
        arre2(i) = 2 * i
    end do

    ! Calcular pasos para dividir el trabajo
    tama = N
    cant_pasos = tama / TotalProcesos
    nva_a = ID_Proceso * cant_pasos + 1
    nva_b = (ID_Proceso + 1) * cant_pasos
    if (ID_Proceso == TotalProcesos - 1) nva_b = tama  ! Último proceso toma el resto

    ! Medir tiempo de inicio
    start_time = MPI_WTIME()

    ! Calcular suma parcial del producto vectorial
    resultado_i = 0
    do i = nva_a, nva_b
        resultado_i = resultado_i + arre1(i) * arre2(i)
    end do

    ! Imprimir resultado parcial de cada proceso
    print *, "Soy el proceso ", ID_Proceso, " y mi suma es ", resultado_i

    ! Proceso raíz recopila resultados
    if (ID_Proceso == 0) then
        resultado_t = resultado_i
        do i = 1, TotalProcesos - 1
            call MPI_RECV(resultado_i, 1, MPI_INTEGER, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
            resultado_t = resultado_t + resultado_i
        end do
        print *, "El resultado es: ", resultado_t
    else
        call MPI_SEND(resultado_i, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, ierr)
    end if

    ! Medir tiempo de finalización
    end_time = MPI_WTIME()
    execution_time = end_time - start_time

    ! Reducir el tiempo total de ejecución (máximo entre procesos)
    call MPI_REDUCE(execution_time, total_execution_time, 1, MPI_DOUBLE_PRECISION, MPI_MAX, 0, MPI_COMM_WORLD, ierr)

    ! El proceso raíz imprime el tiempo total de ejecución
    if (ID_Proceso == 0) then
        print *, "Tiempo total de ejecución: ", total_execution_time, " segundos"
    end if

    ! Finalizar MPI
    call MPI_FINALIZE(ierr)
end program prod_vectorial_mpi
