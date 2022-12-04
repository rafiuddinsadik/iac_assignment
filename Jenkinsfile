pipeline{
    agent any
    tools { 
        maven 'maven 3.8.6'
    }
    stages {

        stage("Building Source Code"){
            steps {
                git 'https://github.com/dannybritto96/HelloWorld-WAR'
                withMaven {
                    sh "mvn clean package"
                }
            }
        }

        // stage("Generating Machine Image"){
            
        // }

        // stage("Infra Creation"){
            
        // }
    }
}