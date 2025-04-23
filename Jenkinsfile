pipeline {
    agent any

    environment {
        // Docker image name used during build and test.
        DOCKER_IMAGE = 'mlmodel:latest'
        // Docker Hub repository path.
        DOCKER_HUB_REPO = 'advaitdoc1204/mlmodel'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out the source code..."
                // "checkout scm" uses the configured SCM from the Jenkins job.
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Building Docker Image: ${env.DOCKER_IMAGE}"
                script {
                    def buildCommand = "docker build -t ${env.DOCKER_IMAGE} ."
                    if (isUnix()) {
                        sh buildCommand
                    } else {
                        bat buildCommand
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo "Running tests inside Docker container..."
                script {
                    def dockerImage = env.DOCKER_IMAGE
                    def runCommand = "docker run --rm ${dockerImage}"
                    def output = ""
                    if (isUnix()) {
                        output = sh(script: runCommand, returnStdout: true).trim()
                    } else {
                        // On Windows, bat supports returnStdout as well.
                        output = bat(script: runCommand, returnStdout: true).trim()
                    }
                    echo "Container output:\n${output}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Tagging the image as ${env.DOCKER_HUB_REPO}:latest"
                script {
                    def dockerImage = env.DOCKER_IMAGE
                    def dockerHubRepo = env.DOCKER_HUB_REPO
                    def tagCommand = "docker tag ${dockerImage} ${dockerHubRepo}:latest"
                    def pushCommand = "docker push ${dockerHubRepo}:latest"
                    
                    if (isUnix()) {
                        sh tagCommand
                        sh pushCommand
                    } else {
                        bat tagCommand
                        bat pushCommand
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
