# Utilisation de l'image officielle d'Odoo comme base
FROM odoo:17.0

# Définition des variables d'environnement
ENV ODOO_VERSION=17.0 \
    ODOO_USER=odoo \
    ODOO_HOME=/home/odoo \
    ODOO_CUSTOM_ADDONS=/mnt/extra-addons

# Passer à l'utilisateur root pour installer les dépendances nécessaires
USER root

# Installer les dépendances système nécessaires pour python-ldap et d'autres modules
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    lsb-release \
    git \
    wget \
    python3-pip \
    libpq-dev \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Ajouter le dépôt PostgreSQL
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update

# Création du répertoire des modules personnalisés et donner les droits nécessaires
RUN mkdir -p $ODOO_CUSTOM_ADDONS && chown -R $ODOO_USER:$ODOO_USER $ODOO_CUSTOM_ADDONS

# Clonage du code source d'Odoo depuis GitHub
WORKDIR $ODOO_HOME
RUN git clone --depth 1 --branch $ODOO_VERSION https://github.com/odoo/odoo.git .

# Installation des dépendances Python requises
RUN pip3 install -r requirements.txt

# Définition du fichier de configuration Odoo (avec correction du chemin)
COPY config/odoo.conf /etc/odoo/odoo.conf

# Exposition des ports pour Odoo
EXPOSE 8069 8072

# Revenir à l'utilisateur odoo pour exécuter Odoo avec des droits limités
USER odoo

# Commande de lancement d'Odoo
CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
