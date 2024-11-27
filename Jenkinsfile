pipeline {
    agent any
    triggers {
        pollSCM('H/5 * * * *') // Check for changes every 5 minutes
    }

    environment {
        ECR_REGISTRY = "905418277051.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO = "nodejs-app-repo"
        CONTAINER_NAME = "nodejs-app"
        IMAGE_TAG = "latest"
        NAMESPACE = "default"
        HELM_CHART_DIR = "helm-chart"
        AWS_REGION = "us-east-1"
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // docker build
                    echo "Build Docker image"
                    sh """
                    docker version
                    sh 'docker build -t nodejs-app .
                    docker images  # Verify it was built
                    """
                }
            }
        }

        stage('Run Image Locally') {
            steps {
                script {
                    echo "Running Docker image locally to test..."
                    sh """
                    docker run -d --name ${CONTAINER_NAME} ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                    sleep 5  
                    # curl http://localhost:8080  # Test the service locally (replace with your actual test)
                    docker ps  # Verify it's running
                    """
                }
            }
        }        
        stage('Test') {
            steps {
                script {
                    // get tests
                    sh 'npm test' 
                }
            }
        }
        stage('Security Check') {
            steps {
                script {
                    // Security Check SonarQube
                    sh 'sonar-scanner'
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Login to ECR
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 905418277051.dkr.ecr.us-east-1.amazonaws.com'
                    // Push image to ECR
                    sh 'docker tag nodejs-app:latest 905418277051.dkr.ecr.us-east-1.amazonaws.com/nodejs-app-repo:latest'
                    sh 'docker push 905418277051.dkr.ecr.us-east-1.amazonaws.com/nodejs-app-repo:latest'
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                script {
                    // Deployment to Kubernetes
                    sh 'helm upgrade --install my-nodejs-app ./helm-chart'
                }
            }
        }
    }
    post {
        success {
            // Success Notifications
            echo 'Pipeline succeeded!'
        }
        failure {
            // Failure Notifications
            echo 'Pipeline failed!'
        }
    }
}
