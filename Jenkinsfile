pipeline {
    agent any 
    stages {
        stage('---Version---') { 
            steps {
                sh "mvn -version"
            }
        }   
       
        stage('Run CI?') {
          agent any
          steps {
            script {
              if (sh(script: "git log -1 | grep '.*\\[ci skip\\].*'", returnStatus: true) == 0) {
                currentBuild.result = 'NOT_BUILT'
                error "'[ci skip]' found in git commit message. Aborting..."
              }
            }
          }
        }        
        
        stage('---Clean---') { 
            steps {
                sh "mvn clean"
            }
        }
        stage('---Test---') { 
            steps {
                sh "mvn test"
            }
        }
        stage('---Package---') { 
            steps {
                sh "mvn package"
            }
        }
    }
}
