import matplotlib.pyplot as plt

# Valores en el eje x y y
x_values = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28]
y_values = [1.0378992, 0.3864518, 0.2355263, 0.0766952, 0.0820120, 0.0627974, 0.0520480,
            0.0475917, 0.0378888, 0.0349491, 0.0222516, 0.0186458, 0.0196378, 0.0116081]

# Crear la gráfica
plt.figure(figsize=(10, 6))
plt.plot(x_values, y_values, marker='o', linestyle='-', color='b')

# Ajustar las marcas del eje X
plt.xticks(x_values)

# Añadir etiquetas y título
plt.title("Eficiencia usando C", fontsize=14)
plt.xlabel("Cantidad de Procesadores", fontsize=12)
plt.ylabel("Valor de Eficiencia", fontsize=12)
plt.grid(True, linestyle='--', alpha=0.6)
plt.legend()
plt.tight_layout()

# Mostrar la gráfica
plt.show()
