pipeline {
    agent any
    triggers {
        pollSCM('H/5 * * * *') // Check for changes every 5 minutes
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // docker build
                    sh 'docker build -t wordpress-app .'
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
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com'
                    // Push image to ECR
                    sh 'docker tag wordpress-app:latest <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/wordpress-repo:latest'
                    sh 'docker push <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/wordpress-repo:latest'
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                script {
                    // Deployment to Kubernetes
                    sh 'helm upgrade --install my-release ./helm-chart'
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
