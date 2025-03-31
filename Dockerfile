# Utiliser l'image officielle d'Odoo 17 comme base
FROM odoo:17.0

# Passer en mode superutilisateur pour installer les dépendances
USER root

# Mettre à jour les dépôts et installer les dépendances système nécessaires
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

# Installer les dépendances Python requises par Odoo
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Copier le fichier de configuration Odoo
COPY config/odoo.conf /etc/odoo/odoo.conf

# Copier les modules personnalisés dans le répertoire des addons
COPY custom_addons/ /mnt/extra-addons/

# Changer le propriétaire des nouveaux fichiers pour correspondre à l'utilisateur Odoo
RUN chown -R odoo:odoo /etc/odoo/odoo.conf /mnt/extra-addons/

# Revenir à l'utilisateur Odoo
USER odoo

# Exposer le port par défaut d'Odoo
EXPOSE 8069

# Commande par défaut pour démarrer le serveur Odoo
CMD ["odoo"]
