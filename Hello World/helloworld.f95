program mpi_bcast_example
    use mpi
    implicit none

    integer, parameter :: N = 20
    character(len=N) :: mensaje
    integer :: root, my_id, nproc, ierr
    double precision :: start_time, end_time, execution_time, total_execution_time

    root = 0  ! Proceso raíz
    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, my_id, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, nproc, ierr)

    ! Inicializar el mensaje
    if (my_id == root) then
        mensaje = 'Hola mundo'  ! Copiar "Hola mundo" en el mensaje
    else
        mensaje = ' '  ! Rellenar el mensaje con espacios en otros procesos
    end if

    ! Registrar el tiempo de inicio
    start_time = MPI_WTIME()

    ! Transmitir el mensaje desde el proceso raíz
    call MPI_BCAST(mensaje, len(mensaje), MPI_CHARACTER, root, MPI_COMM_WORLD, ierr)

    ! Imprimir el mensaje recibido en cada proceso
    print *, 'Mensaje del proceso', my_id, ':', trim(mensaje)

    ! Registrar el tiempo de finalización
    end_time = MPI_WTIME()
    execution_time = end_time - start_time

    ! Reducir el tiempo total de ejecución (máximo entre procesos)
    call MPI_REDUCE(execution_time, total_execution_time, 1, MPI_DOUBLE_PRECISION, MPI_MAX, root, MPI_COMM_WORLD, ierr)

    ! Imprimir el tiempo total desde el proceso raíz
    if (my_id == root) then
        print *, 'Tiempo total de ejecución:', total_execution_time, 'segundos'
    end if

    call MPI_FINALIZE(ierr)
end program mpi_bcast_example
