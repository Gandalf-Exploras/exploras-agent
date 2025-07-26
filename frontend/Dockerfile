# Frontend Dockerfile per Exploras Agent
FROM node:18-alpine as builder

# Imposta la directory di lavoro
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Installa tutte le dipendenze e Angular CLI globalmente
RUN npm install && npm install -g @angular/cli

# Copia il codice sorgente
COPY . .

# Build dell'applicazione Angular per produzione
RUN ng build --configuration production

# Stage 2: Serve con Nginx
FROM nginx:alpine

# Copia i file buildati da Angular
COPY --from=builder /app/dist/exploras-frontend /usr/share/nginx/html

# Copia la configurazione nginx personalizzata
COPY nginx.conf /etc/nginx/nginx.conf

# Espone la porta 80
EXPOSE 80

# Comando per avviare nginx
CMD ["nginx", "-g", "daemon off;"]
