# Folosim o imagine de Ubuntu curată
FROM ubuntu:22.04

# Evităm întrebările interactive în timpul instalării
ENV DEBIAN_FRONTEND=noninteractive

# Instalăm dependențele necesare pentru OpenClaw
RUN apt-get update && apt-get install -y \
    libsdl2-2.0-0 \
    libsdl2-image-2.0-0 \
    libsdl2-ttf-2.0-0 \
    libsdl2-mixer-2.0-0 \
    libtinyxml2-9 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Creăm directorul aplicației
WORKDIR /app

# Aici Railway va copia fișierele din GitHub în container
COPY . .

# Oferim permisiuni de execuție binarului (presupunând că se numește 'openclaw')
RUN chmod +x openclaw

# Portul pe care va asculta serverul
EXPOSE 2200

# Comanda de pornire a serverului
CMD ["./openclaw", "--server", "--port", "2200"]
