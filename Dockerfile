FROM odoo:16

# Installer les dépendances requises
RUN apt-get update && apt-get install -y \
    python3-pip \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copier les modules personnalisés
COPY ./custom_addons /mnt/extra-addons

# Définir les permissions
RUN chown -R odoo:odoo /mnt/extra-addons

# Exposer le port par défaut d'Odoo
EXPOSE 8069

# Démarrer Odoo
CMD ["odoo", "--addons-path=/mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons"]
