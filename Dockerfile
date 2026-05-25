# Usa una imagen liviana de Python
FROM python:3.11-slim

# Evita que Python escriba archivos .pyc y fuerza el buffering de logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias del sistema necesarias (Corregido sin el guion suelto)
RUN apt-get update && apt-get install -y --no-install-recommends gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar requerimientos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código (incluyendo la carpeta templates/)
COPY . .

# Exponer el puerto configurado (Flask usa el 5000 por defecto)
EXPOSE 5000

# Ejecutar usando Gunicorn en producción
RUN pip install gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
