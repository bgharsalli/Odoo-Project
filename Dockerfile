# Utilisation de l'image officielle Odoo 17.0 comme base
FROM odoo:17.0

# Passer en utilisateur root pour éviter les problèmes de permission
USER root

# Installer les dépendances système nécessaires pour python-ldap et d'autres modules
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    lsb-release \
    git \
    wget \
    python3-pip \
    libpq-dev=14.17-0ubuntu0.22.04.1 \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Installer les dépendances Python
RUN pip3 install -r requirements.txt

# Copier le fichier de configuration Odoo
COPY config/odoo.conf /etc/odoo/

# Exposer le port 8069 pour l'accès web à Odoo
EXPOSE 8069

# Démarrer le serveur Odoo
CMD ["odoo"]
