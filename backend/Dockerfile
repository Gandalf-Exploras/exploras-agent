# Backend Dockerfile per Exploras Agent
FROM python:3.11-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file di dipendenze
COPY requirements.txt .

# Installa le dipendenze Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia il codice dell'applicazione
COPY . .

# Crea una directory per gli ebook se non esiste
RUN mkdir -p /app/ebooks

# Espone la porta 8000
EXPOSE 8000

# Comando per avviare l'applicazione
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
