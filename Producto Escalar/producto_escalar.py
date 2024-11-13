from mpi4py import MPI
import numpy as np
import time

def prod_vectorial(v1, v2, a, b):
    suma = 0
    for i in range(a, b):
        suma += v1[i] * v2[i]
    return suma

def main():
    # Inicializamos MPI
    start_time = MPI.Wtime()
    comm = MPI.COMM_WORLD
    ID_Proceso = comm.Get_rank()
    TotalProcesos = comm.Get_size()

    # Vectores de entrada
    arre1 = np.array([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30])
    arre2 = np.array([2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60])

    # Tamaño del array y cálculos de pasos
    tama = len(arre1)
    cant_pasos = tama // TotalProcesos

    nva_a = ID_Proceso * cant_pasos
    nva_b = (ID_Proceso + 1) * cant_pasos if ID_Proceso != TotalProcesos - 1 else tama

    # Calculamos la suma parcial para cada proceso
    resultado_i = prod_vectorial(arre1, arre2, nva_a, nva_b)
    print(f"Soy el proceso {ID_Proceso} y mi suma es {resultado_i}")

    # Proceso principal recoge los resultados
    if ID_Proceso == 0:
        resultado_t = resultado_i
        for i in range(1, TotalProcesos):
            resultado_i = comm.recv(source=i, tag=0)
            resultado_t += resultado_i
        print(f"\n El resultado es {resultado_t} \n")
    else:
        comm.send(resultado_i, dest=0, tag=0)

    end_time = MPI.Wtime()
    execution_time = end_time - start_time
    total_execution_time = comm.reduce(execution_time, op=MPI.MAX, root=0)

    # El proceso raíz (0) imprime el tiempo total de ejecución
    if ID_Proceso == 0:
        print(f"Tiempo total de ejecución: {total_execution_time} segundos")

if __name__ == "__main__":
    main()
