pipeline {
    agent {
        node {
            label 'maven'
        } 
    }
    environment{
         PATH ="/opt/apache-maven-3.9.9/bin:$PATH"
    }
    stages {
        stage("build"){
            steps {
                sh 'mvn clean deploy'}
        }
        stage("SonarQube analysis"){
            environment{
                scannerHome = tool 'galaxy-sonar-scanner'
                echo "SonarQube Scanner Home: ${scannerHome}"
            }
            steps{
                withSonarQubeEnv('sonarqube-server'){
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }


}
