from mpi4py import MPI
import numpy as np
import time

# Definir el tamaño de los arreglos
TAMANIO = 25200

# Función para llenar un arreglo con valores
def llenar_matriz(tamanio):
    return np.arange(1, tamanio + 1)

# Función para calcular el producto vectorial parcial
def prod_vectorial(v1, v2, a, b):
    suma = 0
    for i in range(a, b):
        suma += v1[i] * v2[i]
    return suma

def main():
    # Inicializar MPI
    comm = MPI.COMM_WORLD
    ID_Proceso = comm.Get_rank()
    TotalProcesos = comm.Get_size()

    # Crear y llenar las matrices
    arre1 = llenar_matriz(TAMANIO)
    arre2 = llenar_matriz(TAMANIO)

    # División del trabajo
    cant_pasos = TAMANIO // TotalProcesos
    nva_a = ID_Proceso * cant_pasos
    nva_b = (ID_Proceso + 1) * cant_pasos

    # Calcular el producto vectorial parcial
    start_time = MPI.Wtime()
    resultado_i = prod_vectorial(arre1, arre2, nva_a, nva_b)

    # Reducir los resultados parciales al proceso 0
    resultado_t = comm.reduce(resultado_i, op=MPI.SUM, root=0)

    # Obtener el tiempo máximo
    end_time = MPI.Wtime()
    elapsed_time = end_time - start_time
    max_time = comm.reduce(elapsed_time, op=MPI.MAX, root=0)

    if ID_Proceso == 0:
        print(f'{max_time}, ', end="")

if __name__ == "__main__":
    main()
