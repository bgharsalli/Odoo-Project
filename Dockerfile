# Utiliser l'image officielle d'Odoo 17.0 comme base
FROM odoo:17.0

# Installer les dépendances nécessaires pour python-ldap et autres modules
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    lsb-release \
    git \
    wget \
    python3-pip \
    build-essential \
    python3-dev \
    && apt-get install -f \
    && rm -rf /var/lib/apt/lists/*

# Installer les dépendances de PostgreSQL avec une version spécifique
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copier les fichiers de configuration et les addons personnalisés
COPY config/odoo.conf /etc/odoo/

# Exposer le port 8069 pour l'accès web à Odoo
EXPOSE 8069

# Définir le répertoire de travail pour Odoo
WORKDIR /opt/odoo

# Installer les dépendances Python d'Odoo
RUN pip3 install -r /opt/odoo/requirements.txt

# Commande par défaut pour exécuter Odoo
CMD ["odoo"]
