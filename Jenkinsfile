pipeline {
    agent any

    tools {
        // Define Maven tool by name; ensure this matches a configured tool in Jenkins global tools
        maven 'maven-3.9.11'
    }

    environment {
        MAVEN_HOME = tool 'maven-3.9.11'
        PATH = "${env.MAVEN_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/TeamITSpark/smp-webapp.git'
            }
        }
		stage('Build with Maven') {
            steps {
                sh 'mvn validate'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
		
		stage('Performing Dependency Scan') {
            steps {
                sh 'mvn dependency-check:check -Dformat=all'
            }
        }
    }
	post {
        always {
            // Publish JUnit test results
            junit 'target/surefire-reports/*.xml'
        }
    }
}
