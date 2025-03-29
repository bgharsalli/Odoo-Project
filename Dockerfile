# Utilisation de l'image officielle d'Odoo comme base
FROM odoo:17.0

# Définition des variables d'environnement
ENV ODOO_VERSION=17.0 \
    ODOO_USER=odoo \
    ODOO_HOME=/home/odoo \
    ODOO_CUSTOM_ADDONS=/mnt/extra-addons

# Mise à jour du système et installation des dépendances
RUN apt-get update && apt-get install -y \
    git \
    wget \
    python3-pip \
    libpq-dev \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Création du répertoire des modules personnalisés
RUN mkdir -p $ODOO_CUSTOM_ADDONS && chown -R $ODOO_USER:$ODOO_USER $ODOO_CUSTOM_ADDONS

# Clonage du code source d'Odoo depuis GitHub
WORKDIR $ODOO_HOME
RUN git clone --depth 1 --branch $ODOO_VERSION https://github.com/odoo/odoo.git .

# Installation des dépendances Python requises
RUN pip3 install -r requirements.txt

# Définition du fichier de configuration Odoo
COPY odoo.conf /etc/odoo/odoo.conf

# Exposition des ports pour Odoo
EXPOSE 8069 8072

# Commande de lancement d'Odoo
CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
