pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    }
    stages {
        stage("Build") {
            steps {
                echo "........build started......."
                sh 'mvn clean deploy'
                echo ".........build completed..........."
            }
        }
        stage("Test") {
            steps {
                echo ".............unit test started....."
                sh 'mvn test'
                echo "........unit test completed....."
            }
        }
        stage("SonarQube analysis") {
            environment {
                scannerHome = tool 'galaxy-sonar-scanner'
            }
            steps {
                echo "........SonarQube analysis started......."
                withSonarQubeEnv('sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner -X"
                }
                echo "........SonarQube analysis completed......."
            }
        }
        stage("Quality Gate") {
            steps {
                echo "........Waiting for Quality Gate result......."
        // Add a small delay before checking
                  sleep time: 30, unit: 'SECONDS'
                // Wait for SonarQube quality gate result
                script {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
                    }
                }
                echo "........Quality Gate passed......."
            }
        }
    }

}
