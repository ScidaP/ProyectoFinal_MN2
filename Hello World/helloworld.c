#include <stdio.h>
#include <string.h> 
#include <mpi.h>
#define N 20

int main(int argc, char **argv)
{
  char mensaje[N];
  int  i, my_id, nproc;
  MPI_Status status;
  int root = 0;
  double start_time, end_time, elapsed_time;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_id);

  // Inicio del temporizador
  start_time = MPI_Wtime();

  if (my_id == root)
  {
    strcpy(mensaje, "Hola mundo");
  }
  MPI_Bcast(mensaje, N, MPI_CHAR, root, MPI_COMM_WORLD);
  printf("Mensaje del proceso %d : %s\n", my_id, mensaje);

  end_time = MPI_Wtime();

	elapsed_time = end_time - start_time;

	double max_time;
  MPI_Reduce(&elapsed_time, &max_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

	if (my_id == 0) {
	  printf("Tiempo total de ejecución = %f segundos\n", max_time);
  }

  MPI_Finalize();
}
