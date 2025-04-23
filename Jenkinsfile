pipeline {
    agent any

    // Define environment variables to be used throughout the pipeline.
    environment {
        DOCKER_IMAGE = 'mlmodel:latest'
        DOCKER_HUB_REPO = 'advaitdoc1204/mlmodel'  
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the repository. "checkout scm" uses the SCM configuration from the Jenkins job.
                checkout scm
            }
        }
        stage('Build') {
            steps {
                // Build the Docker image using the Dockerfile from the repository.
                echo "Building Docker Image: ${env.DOCKER_IMAGE}"
            	script {
                    if (isUnix()) {
                        sh 'docker build -t my_app:latest .'
                    } else {
                        bat 'docker build -t my_app:latest .'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                // Run the Docker image to test if the container starts correctly.
                // Capture and print the output if necessary.
                echo "Running tests inside Docker container..."
                script {
                    def output = sh(script: "docker run --rm ${DOCKER_IMAGE}", returnStdout: true).trim()
                    echo "Container output:\n${output}"
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                // Tag and push the Docker image. Ensure Jenkins has credentials to access Docker Hub.
                echo "Tagging the image as ${DOCKER_HUB_REPO}:latest"
                sh 'docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_REPO}:latest'
                echo "Pushing the image to Docker Hub..."
                sh 'docker push ${DOCKER_HUB_REPO}:latest'
            }
        }
    }
    
    post {
        always {
            // Post actions: Clean up the workspace once the pipeline runs.
            echo "Cleaning workspace..."
            cleanWs()
        }
        success {
            // Notify success.
            echo 'Pipeline executed successfully!'
        }
        failure {
            // If any stage fails.
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
