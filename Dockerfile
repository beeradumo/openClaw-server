# ETAPA 1: Compilarea (Builder)
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Instalăm uneltele de build și dependențele
RUN apt-get update && apt-get install -y \
    build-essential cmake git \
    libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-mixer-dev \
    libtinyxml2-dev zlib1g-dev

# Clonăm codul sursă oficial OpenClaw
RUN git clone https://github.com/p12tic/OpenClaw.git /app-source

# Compilăm proiectul
WORKDIR /app-source
RUN mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc)

# ETAPA 2: Rularea (Runner) - Imaginea finală va fi mult mai mică
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalăm doar runtime-ul (fără compilatoare)
RUN apt-get update && apt-get install -y \
    libsdl2-2.0-0 libsdl2-image-2.0-0 libsdl2-ttf-2.0-0 libsdl2-mixer-2.0-0 \
    libtinyxml2-9 zlib1g curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiem doar executabilul compilat din prima etapă
COPY --from=builder /app-source/build/openclaw .

# IMPORTANT: Aici avem nevoie de fișierele jocului (Asset-urile)
# Dacă nu le ai, serverul va da eroare. 
# Recomand să le pui într-un folder 'assets' pe GitHub.

EXPOSE 2200

# Pornim serverul
CMD ["./openclaw", "--server", "--port", "2200"]
