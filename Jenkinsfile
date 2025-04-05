pipeline {
    agent any

    environment {
        SONARQUBE_URL = 'SonarQube'
        GIT_REPO = 'https://github.com/bgharsalli/Odoo-Project.git'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    bat 'sonar-scanner'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = "odoo_custom-${env.BUILD_ID}"
                    bat "docker build -t ${tag} ."
                }
            }
        }

        stage('Deploy Odoo + PostgreSQL') {
            steps {
                bat 'docker-compose up -d'
            }
        }

        stage('Database Migration') {
            steps {
                script {
                    def containerName = 'odoo_app'  // Assurez-vous que c'est le bon nom de conteneur
                    bat "docker exec -it ${containerName} odoo -u all -d odoo --stop-after-init"
                }
            }
        }

        stage('Check Odoo Logs') {
            steps {
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
