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
        ARM_CLIENT_ID = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('ARM_CLIENT_SECRET')
        acr_password = credentials('ACR_PASSWORD')
        ARM_SUBSCRIPTION_ID = "d7ebd1a3-506e-4870-b872-38bf70130d51"
        ARM_TENANT_ID = "cf8f9cba-67c5-46b4-9dcb-d8d142f7e567"
    }

    stages {
       stage('Login to ACR') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'ACR_PASSWORD', variable: 'ACR_PASS')]) {
                        sh '''
                        az acr login --name $ACR_NAME --username $ACR_NAME --password "$ACR_PASS"
                        '''
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
                    withCredentials([
                        string(credentialsId: 'AZURE_CLIENT_ID', variable: 'ARM_CLIENT_ID'),
                        string(credentialsId: 'ARM_CLIENT_SECRET', variable: 'ARM_CLIENT_SECRET')
                    ]) {
                        sh '''
                        export ARM_CLIENT_ID="$ARM_CLIENT_ID"
                        export ARM_CLIENT_SECRET="$ARM_CLIENT_SECRET"
                        export ARM_SUBSCRIPTION_ID="d7ebd1a3-506e-4870-b872-38bf70130d51"
                        export ARM_TENANT_ID="cf8f9cba-67c5-46b4-9dcb-d8d142f7e567"

                        terraform init
                        terraform validate
                        terraform apply -auto-approve -var="acr_password=$acr_password"
                        '''
                    }
                }
            }
        }
    }
}
