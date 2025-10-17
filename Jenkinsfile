pipeline {
    agent { label 'linux-agt-2 || linux' }

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
		stage('Validate and Build') {
            parallel {
                stage('Validate') {
                    steps {
                        sh 'mvn validate'
                    }
                }
                stage('Build') {
                    steps {
                        sh 'mvn clean package'
                    }
                }
            }
        }
		
		stage('Performing Dependency Scan') {
            steps {
                sh 'mvn dependency-check:check -Dformat=all'
            }
        }
		stage('Deploy to Dev') {
            steps {
                script {
                    def branchName = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    echo "Branch name is: ${branchName}"

                    if (branchName == 'main') {
                        echo "Deploying to 192.168.56.11 (Develop Environment)"
                        sh '''
                            ssh vagrant@192.168.56.11 "sudo systemctl stop tomcat9"
                            scp -v target/*.war vagrant@192.168.56.11:/var/lib/tomcat9/webapps/
                            ssh vagrant@192.168.56.11 "sudo systemctl start tomcat9"
                        '''
                    } else {
                        echo "Skipping deployment — not on main branch."
                    }
                }
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
