pipeline {
    agent {
        node {
            label 'agentodoo'
        }
    }

    environment {
        // Utiliser le socket Docker via WSL2
        DOCKER_HOST = "unix:///var/run/docker.sock"
        SONARQUBE_URL = 'http://localhost:9000'  // URL de SonarQube
        SONARQUBE_TOKEN = 'sqp_02e6dca32122de734f422571b3bd9737285e2937'  // Ton token SonarQube
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/bgharsalli/Odoo-Project.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                bat '''
                sonar-scanner ^
                    -Dsonar.projectKey=Odooprojet ^
                    -Dsonar.sources=. ^
                    -Dsonar.host.url=${SONARQUBE_URL} ^
                    -Dsonar.token=${SONARQUBE_TOKEN}
                '''
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t odoo_project_image .'
            }
        }

        stage('Deploy Odoo + PostgreSQL') {
            steps {
                bat 'docker-compose up -d' // Déploiement avec Docker Compose
            }
        }

        stage('Database Migration') {
            steps {
                // Remplace "odoo_app" par le nom réel du conteneur Odoo que tu utilises.
                script {
                    def containerName = 'odoo_app'  // Assurez-vous que c'est le bon nom de conteneur Odoo
                    bat "docker exec -it ${containerName} odoo -u all -d odoo --stop-after-init"
                }
            }
        }

        stage('Check Odoo Logs') {
            steps {
                // Remplace "odoo_app" par le nom réel du conteneur Odoo que tu utilises.
                bat 'docker logs odoo_app'
            }
        }

        stage('Post-build') {
            steps {
                echo 'Odoo with PostgreSQL is running on port 8069!'
            }
        }
    }
}
