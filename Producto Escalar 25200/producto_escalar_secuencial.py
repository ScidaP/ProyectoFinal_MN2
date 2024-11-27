import numpy as np
import time

# Definir el tamaño de los arreglos
TAMANIO = 25200

# Función para llenar un arreglo con valores
def llenar_arreglo(tamanio):
    return np.arange(1, tamanio + 1)

# Función para calcular el producto vectorial
def prod_vectorial(v1, v2):
    return np.sum(v1 * v2)

def main():
    # Crear y llenar las matrices
    arre1 = llenar_arreglo(TAMANIO)
    arre2 = llenar_arreglo(TAMANIO)

    # Medir el tiempo de ejecución
    start_time = time.time()

    # Calcular el producto vectorial
    resultado_t = prod_vectorial(arre1, arre2)

    end_time = time.time()
    elapsed_time = end_time - start_time

    # Imprimir el resultado y el tiempo
    print(f"{elapsed_time:.6f}")

if __name__ == "__main__":
    main()
