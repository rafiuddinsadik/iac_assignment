pipeline{
    agent any
    tools { 
        maven 'maven-3.8.6'
        git 'Default'
    }
    stages {

        stage("Fetching Source Code"){
            steps {
                git 'https://github.com/dannybritto96/HelloWorld-WAR'
            }
        }

        stage("Building Source Code"){
            steps {
                sh "mvn clean package"
            }
        }

        // stage("Generating Machine Image"){
            
        // }

        // stage("Infra Creation"){
            
        // }
    }
}