
def registry = 'https://tojo26.jfrog.io/artifactory'
def imageName = 'tojo26.jfrog.io/valaxytest-docker-local/ttrendfinal'
def version   = '2.1.3'
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
        // stage("SonarQube analysis") {
        //     environment {
        //         scannerHome = tool 'galaxy-sonar-scanner'
        //     }
        //     steps {
        //         echo "........SonarQube analysis started......."
        //         withSonarQubeEnv('sonarqube-server') {
        //             sh "${scannerHome}/bin/sonar-scanner -X"
        //         }
        //         echo "........SonarQube analysis completed......."
        //     }
        // }
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
                     def server = Artifactory.newServer url:registry ,  credentialsId:"jfrogcred"
                    //  def buildId = env.BUILD_ID ?: 'unknown-build'
                    //  def commitId = GIT_COMMIT ?: 'unknown-commit'
                    //  def version = "2.1.2"
                    def buildId = env.BUILD_ID ?: 'unknown-build' // This should work now
                    def commitId = env.GIT_COMMIT ?: 'unknown-commit' // Ensure GIT_COMMIT is also defined
                     def properties = "buildid=${buildId},commitid=${commitId}"
                    //  def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release-local-libs-release/{1}/",
                              "flat": "true",
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
    stage(" Docker Build ") {
      steps {
        script {
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build(imageName+":"+version)
           echo '<--------------- Docker Build Ends --------------->'
        }
      }
    }

            stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'  
                docker.withRegistry(registry, 'jfrogcred'){
                    app.push()
                }    
               echo '<--------------- Docker Publish Ended --------------->'  
            }
        }
    }
    stage("Deploy"){
        steps{
            script{
                sh './deploy.sh'
            }
        }
    }
// stage(" Deploy ") {
//        steps {
//          script {
//             echo '<--------------- Helm Deploy Started --------------->'
//             sh 'helm install ttrend ttrend-1.0.1.tgz'
//             echo '<--------------- Helm deploy Ends --------------->'
//          }
//        }
//      }
    }

}
