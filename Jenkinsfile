
def registry = 'https://tojo26.jfrog.io/artifactory/maven-libs-release/'
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
        // stage("Quality Gate") {
        //     steps {
        //         echo "........Waiting for Quality Gate result......."
        // // Add a small delay before checking
        //           sleep time: 30, unit: 'SECONDS'
        //         // Wait for SonarQube quality gate result
        //         script {
        //             def qualityGate = waitForQualityGate()
        //             if (qualityGate.status != 'OK') {
        //                 error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
        //             }
        //         }
        //         echo "........Quality Gate passed......."
        //     }
        // }
        stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry ,  credentialsId:"jfrog-cred"
                     def buildId = env.BUILD_ID ?: 'unknown-build'
                     def commitId = GIT_COMMIT ?: 'unknown-commit'
                     def version = "2.1.2"
                     def properties = "buildid=${buildId},commitid=${commitId}"
                    //  def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release-local/demo-workshop/${version}/",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }
    }

}
