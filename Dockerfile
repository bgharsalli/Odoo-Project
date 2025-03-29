# Utilisation de l'image de base Odoo
FROM odoo:17.0

# Mise à jour et installation des dépendances système nécessaires
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    lsb-release \
    git \
    wget \
    python3-pip \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Installation de libpq-dev, forcer l'installation de la version compatible
RUN apt-get update && apt-get install -y \
    libpq-dev=14.17-0ubuntu0.22.04.1 \
    && rm -rf /var/lib/apt/lists/*

# Installation des dépendances Python requises
RUN pip3 install -r requirements.txt

# Définition du fichier de configuration Odoo (avec correction du chemin)
COPY odoo.conf /etc/odoo/

# Exposer le port 8069 pour l'accès web à Odoo
EXPOSE 8069

# Commande de démarrage d'Odoo
CMD ["odoo"]
