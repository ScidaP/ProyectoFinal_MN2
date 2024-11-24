#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define TAMANIO 25200

// Función para llenar un arreglo con valores
void llenar_matriz(int matriz[], int tamanio) {
    for (int i = 0; i < tamanio; i++) {
        matriz[i] = i + 1; // Llena con valores consecutivos, puedes cambiar esta lógica si es necesario
    }
}

// Función para calcular el producto vectorial completo
long long prod_vectorial(int v1[], int v2[], int tamanio) {
    long long suma = 0;
    for (int i = 0; i < tamanio; i++) {
        suma += v1[i] * v2[i];
    }
    return suma;
}

int main() {
    int arre1[TAMANIO];
    int arre2[TAMANIO];

    // Llenar las matrices
    llenar_matriz(arre1, TAMANIO);
    llenar_matriz(arre2, TAMANIO);

    // Medir el tiempo de ejecución
    clock_t start_time = clock();

    // Cálculo del producto vectorial completo
    long long resultado_t = prod_vectorial(arre1, arre2, TAMANIO);

    clock_t end_time = clock();

    // Calcular el tiempo transcurrido en segundos
    double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;

    // Imprimir el resultado
    printf("%f\n", elapsed_time);

    return 0;
}
