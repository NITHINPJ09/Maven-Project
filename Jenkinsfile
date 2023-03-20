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
                    sh '''
                        ssh -o StrictHostKeyChecking=accept-new -T azureuser@74.235.79.120 <<'EOF'
                        echo "These commands will be run on: $( uname -a )"
                        echo "They are executed by: $( whoami )"
                        scp target/Calculator-1.0-SNAPSHOT.jar azureuser@74.235.79.120:/home/azureuser
                        exit
                        EOF
                        '''
                }
            }
        }
             
    }
}
