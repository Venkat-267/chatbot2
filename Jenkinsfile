pipeline {
    agent any

    environment {
        ACR_NAME = "chatyregistry"
        ACR_LOGIN_SERVER = "chatyregistry.azurecr.io"
        IMAGE_NAME = "chaty/hello-world"
        IMAGE_VERSION = "latest"
        RESOURCE_GROUP = "my-frontend-container"
        ACI_NAME = "hello-world-container"
        CPU_COUNT = "1.0"
        MEMORY_GB = "2.5"
        PORT_NUMBER = "80"
        DNS_LABEL = "chatbot"
    }

    stages {
        // stage('Checkout Code') {
        //     steps {
        //         git 'https://github.com/Venkat-267/chatbot2.git'
        //     }
        // }

        stage('Login to ACR') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'ACR_PASSWORD', variable: 'ACR_PASS')]) {
                        sh "az acr login --name ${ACR_NAME}"
                    }
                }
            }
        }

        stage('Build & Tag Docker Image') {
            steps {
                script {
                    sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_VERSION} .
                    docker tag ${IMAGE_NAME}:${IMAGE_VERSION} ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_VERSION}
                    """
                }
            }
        }

        stage('Push Image to ACR') {
            steps {
                script {
                    sh "docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_VERSION}"
                }
            }
        }

        stage('Deploy to ACI using Terraform') {
            steps {
                script {
                    withCredentials([azureServicePrincipal('AZURE_CREDENTIALS')]) {
                        sh """
                        cd terraform
                        terraform init
                        terraform apply -auto-approve
                        """
                    }
                }
            }
        }

        stage('Deploy ACI using CLI') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'ACR_PASSWORD', variable: 'ACR_PASS')]) {
                        sh """
                        az container create \\
                            --resource-group ${RESOURCE_GROUP} \\
                            --name ${ACI_NAME} \\
                            --image ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_VERSION} \\
                            --cpu ${CPU_COUNT} \\
                            --memory ${MEMORY_GB} \\
                            --registry-login-server ${ACR_LOGIN_SERVER} \\
                            --registry-username ${ACR_NAME} \\
                            --registry-password "${ACR_PASS}" \\
                            --dns-name-label ${DNS_LABEL} \\
                            --ports ${PORT_NUMBER} \\
                            --os-type Linux
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh "docker logout ${ACR_LOGIN_SERVER}"
        }
    }
}