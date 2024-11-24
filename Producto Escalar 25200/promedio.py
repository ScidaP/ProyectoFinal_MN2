def calcular_promedio_desde_archivo(nombre_archivo):
    try:
        with open(nombre_archivo, 'r') as archivo:
            numeros = []
            
            # Leer cada línea del archivo
            for linea in archivo:
                linea = linea.strip()
                if linea:  # Asegurarse de que no esté vacía
                    numeros.append(float(linea))
            
            # Verificar si se encontraron números
            if numeros:
                promedio = sum(numeros) / len(numeros)
                print(f"El promedio de los números es: {promedio:.10f}")
            else:
                print("El archivo está vacío o no contiene números válidos.")
    except FileNotFoundError:
        print(f"No se pudo encontrar el archivo: {nombre_archivo}")
    except ValueError:
        print("El archivo contiene datos no numéricos.")

# Usar la función con un archivo de ejemplo
calcular_promedio_desde_archivo("tiempos_secuencial_python.txt")
