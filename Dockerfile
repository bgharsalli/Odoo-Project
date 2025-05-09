
# Base Odoo
FROM odoo:17.0

USER root

# Mise à jour et installation des dépendances pour Odoo + Jenkins + Docker + SonarScanner
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
    openjdk-11-jdk \
    unzip \
    curl \
    gnupg \
    sudo \
    apt-transport-https \
    ca-certificates \
    software-properties-common

# ---- Docker CLI ----
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose

# ---- SonarScanner ----
ENV SONAR_SCANNER_VERSION=5.0.1.3006
RUN curl -sL -o sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    unzip sonar-scanner.zip -d /opt && \
    mv /opt/sonar-scanner-* /opt/sonar-scanner && \
    ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    rm sonar-scanner.zip

ENV PATH="/opt/sonar-scanner/bin:$PATH"
ENV SONAR_SCANNER_OPTS="-Xmx512m"

# ---- Odoo spécifique ----

# Installer les dépendances Python requises par Odoo
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Copier la config et les modules
COPY config/odoo.conf /etc/odoo/odoo.conf
COPY custom_addons/ /mnt/extra-addons/
RUN chown -R odoo:odoo /etc/odoo/odoo.conf /mnt/extra-addons/

# Exposer les ports nécessaires
EXPOSE 8069   # Odoo
EXPOSE 8080   # Jenkins si tu lances l’interface
EXPOSE 50000  # Jenkins agent port

# CMD : tu peux personnaliser pour lancer Odoo, Jenkins ou les deuxgit