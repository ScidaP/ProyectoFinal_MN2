program producto_vectorial
  use mpi
  implicit none
  integer, parameter :: TAMANIO = 20000  ! Cambiar tamaño de la matriz a 20000
  integer :: ID_Proceso, TotalProcesos, cant_pasos
  double precision :: arre1(TAMANIO), arre2(TAMANIO)   ! Usar double precision para los arreglos
  double precision :: resultado_t, resultado_i
  integer :: nva_a, nva_b, i
  integer :: dest, tag
  double precision :: start_time, end_time, elapsed_time
  double precision :: max_time
  integer :: status(MPI_STATUS_SIZE)

  ! Inicialización de MPI
  call MPI_Init()
  call MPI_Comm_rank(MPI_COMM_WORLD, ID_Proceso)
  call MPI_Comm_size(MPI_COMM_WORLD, TotalProcesos)

  ! Llenar las matrices
  call llenar_matriz(arre1, TAMANIO)
  call llenar_matriz(arre2, TAMANIO)

  dest = 0       ! Proceso que recibirá los resultados parciales
  tag = 0         ! Etiqueta de los mensajes
  cant_pasos = TAMANIO / TotalProcesos

  ! Inicio del temporizador
  call MPI_Wtime(start_time)

  ! División del trabajo
  nva_a = ID_Proceso * cant_pasos
  nva_b = (ID_Proceso + 1) * cant_pasos

  ! Cálculo del producto vectorial parcial
  resultado_i = prod_vectorial(arre1, arre2, nva_a, nva_b)

  print*, 'Soy el proceso ', ID_Proceso, ' y mi suma parcial es ', resultado_i

  if (ID_Proceso == 0) then
    resultado_t = resultado_i
    do i = 1, TotalProcesos - 1
      call MPI_Recv(resultado_i, 1, MPI_DOUBLE_PRECISION, i, tag, MPI_COMM_WORLD, status)
      resultado_t = resultado_t + resultado_i
    end do
    print*, 'El resultado total es ', resultado_t
  else
    call MPI_Send(resultado_i, 1, MPI_DOUBLE_PRECISION, dest, tag, MPI_COMM_WORLD)
  end if

  ! Fin del temporizador
  call MPI_Wtime(end_time)

  elapsed_time = end_time - start_time

  ! Reducir para obtener el tiempo máximo
  call MPI_Reduce(elapsed_time, max_time, 1, MPI_DOUBLE_PRECISION, MPI_MAX, 0, MPI_COMM_WORLD)

  if (ID_Proceso == 0) then
    print*, 'Tiempo total de ejecución = ', max_time, ' segundos'
  end if

  call MPI_Finalize()
contains

  ! Función para llenar el arreglo
  subroutine llenar_matriz(matriz, tamanio)
    double precision, dimension(:), intent(out) :: matriz
    integer, intent(in) :: tamanio
    integer :: i
    do i = 1, tamanio
      matriz(i) = real(i)  ! Llenar con valores de tipo double precision
    end do
  end subroutine llenar_matriz

  ! Función para calcular el producto vectorial parcial
  double precision function prod_vectorial(v1, v2, a, b)
    double precision, dimension(:), intent(in) :: v1, v2
    integer, intent(in) :: a, b
    integer :: i
    double precision :: suma
    suma = 0.0d0
    do i = a, b - 1
      suma = suma + v1(i) * v2(i)
    end do
    prod_vectorial = suma
  end function prod_vectorial

end program producto_vectorial