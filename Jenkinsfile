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

        stage("Fetching Infra Codebase"){
            steps {
                git 'https://github.com/rafiuddinsadik/iac_assignment.git'
                // sh "cp /var/lib/jenkins/workspace/assignment_deployment/target/myproject-1.war /var/lib/jenkins/workspace/assignment_deployment/Ansible/myproject-1.war"
            }
        }

        stage("Generating Machine Image"){
            steps {
                dir("Packer"){
                    sh "packer build packer.json"
                }
            }
        }

        // stage("Infra Creation"){
            
        // }
    }
}