# LINUX

### Ejecutar archivo de Python que usa MPI4PY

1) Instalar mpi4py usando `sudo apt install python3-mpi4py`
2) Comando para ejecutar: `mpiexec -n 4 python3 archivo.py` (-n 4 indica la cant. de CPUs)

### Ejecutar archivo de C que usa OpenMPI

1) Primero instalar MPI:<br>
`sudo apt update`<br>
`sudo apt install mpich`  # o, alternativamente, `sudo apt install openmpi-bin`
2) Compilar con: `mpicc -o nombre nombre.c`
3) Ejecutar con: `mpirun -np 4 nombre `


### Ejecutar archivo de Fortran que usa OpenMPI

1) Primero instalar Fortran:<br>
  `sudo apt install gfortran`
2) Instalar MPI:<br>
  `sudo apt install mpich gfortran`
3) Compilar
   `mpif90 nombre.f95 -o nombre`
4) Ejecutar
   `mpirun -np 4 ./nombre`
