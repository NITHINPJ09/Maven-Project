pipeline {
    agent any 
    stages {
        
        stage('Run CI?') {
          steps {
            script {
              sh 'git log -1'
              if (sh(script: "git log -1 | grep '.*\\[ci skip\\].*'", returnStatus: true) == 0) {
                currentBuild.result = 'NOT_BUILT'
                error "'[ci skip]' found in git commit message. Aborting..."
              }
            }
          }
        } 
        
        stage('---Version---') { 
            steps {
                sh "mvn -version"
            }
        }   
                     
        stage('---Clean---') { 
            steps {
                sh "mvn clean"
            }
        }
        
        stage('---Package---') { 
            steps {
                sh "mvn package"
            }
        }
        
        stage('---Deployment---') { 
            steps {
                sshagent(['server_id']) {
                    sh 'scp target/Calculator-1.0-SNAPSHOT.jar azureuser@20.163.225.176:/home/azureuser'
                }
            }
        }
             
    }
}
