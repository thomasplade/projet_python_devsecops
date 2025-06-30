FROM python:3.10-slim

# Éviter les prompts interactifs
ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour système minimale + install build tools nécessaires (si besoin)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        libssl-dev \
        build-essential && \
    apt-get purge -y libpam-modules libpam-runtime libpam0g perl-base && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Mettre à jour pip + setuptools (corrige CVE-2024-6345 et CVE-2025-47273)
RUN pip install --upgrade pip setuptools==78.1.1

# Préparation du répertoire
WORKDIR /app

# Copie des requirements et installation
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du code
COPY . .

# Commande de lancement
CMD ["python", "app.py"]
