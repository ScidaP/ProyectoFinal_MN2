#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define TAMANIO 25200

// Función para llenar un arreglo con valores
void llenar_matriz(int matriz[], int tamanio) {
    for (int i = 0; i < tamanio; i++) {
        matriz[i] = i + 1; // Llena con valores consecutivos, puedes cambiar esta lógica si es necesario
    }
}

// Función para calcular el producto vectorial parcial
long prod_vectorial(int v1[], int v2[], int a, int b) {
    long suma = 0;
    for (int i = a; i < b; i++) {
        suma += v1[i] * v2[i];
    }
    return suma;
}

int main(int argc, char **argv) {
    int arre1[TAMANIO];
    int arre2[TAMANIO];

    // Llenar las matrices
    llenar_matriz(arre1, TAMANIO);
    llenar_matriz(arre2, TAMANIO);

    int dest = 0; // Proceso que recibirá los resultados parciales
    int tag = 0;  // Etiqueta de los mensajes
    int tama = TAMANIO;

    double start_time, end_time, elapsed_time;

    MPI_Status status;

    /* Declaración de variables */
    int ID_Proceso, TotalProcesos, cant_pasos;
    long long resultado_t; long resultado_i;
    int nva_a, nva_b;

    /* Inicialización de MPI */
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &ID_Proceso);
    MPI_Comm_size(MPI_COMM_WORLD, &TotalProcesos);

    // Inicio del temporizador
    start_time = MPI_Wtime();

    // División del trabajo
    cant_pasos = tama / TotalProcesos;

    nva_a = ID_Proceso * cant_pasos;
    nva_b = (ID_Proceso + 1) * cant_pasos;

    // Cálculo del producto vectorial parcial
    resultado_i = prod_vectorial(arre1, arre2, nva_a, nva_b);

    printf("Soy el proceso %d y mi suma parcial es %li\n", ID_Proceso, resultado_i);

    if (ID_Proceso == 0) {
        resultado_t = resultado_i;
        for (int i = 1; i < TotalProcesos; i++) {
            MPI_Recv(&resultado_i, 1, MPI_LONG, i, tag, MPI_COMM_WORLD, &status);
            resultado_t += resultado_i;
        }
        printf("\nEl resultado total es %lld\n", resultado_t);
    } else {
        MPI_Send(&resultado_i, 1, MPI_LONG, dest, tag, MPI_COMM_WORLD);
    }

    // Fin del temporizador
    end_time = MPI_Wtime();

    elapsed_time = end_time - start_time;

    // Reducir para obtener el tiempo máximo
    double max_time;
    MPI_Reduce(&elapsed_time, &max_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

    if (ID_Proceso == 0) {
        printf("Tiempo total de ejecución = %f segundos\n", max_time);
    }

    MPI_Finalize();

    return 0;
}