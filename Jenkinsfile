pipeline {
    agent any 
    stages {
        
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
                    sh 'ssh -o StrictHostKeyChecking=accept-new target/Calculator-1.0-SNAPSHOT.jar azureuser@20.163.185.120:/home/azureuser'
                }
            }
        }
             
    }
}
