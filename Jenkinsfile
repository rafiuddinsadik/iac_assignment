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
            }
        }

        stage("Generating Machine Image"){
            matrix {
                axes {
                    axis {
                        name 'TYPES'
                        values "web", "db"
                    }
                }
                stages {
                    stage('AMI Build') {
                        steps {
                            dir("Packer"){
                                sh "packer build -var 'type=${TYPES}' packer.json"
                            }
                        }
                    }
                }
            }
        }

        stage("Infra init"){
            steps {
                sh "terraform init"
            }
        }

        stage("Infra Planning"){
            steps {
                sh "terraform plan"
            }
        }

        stage("Infra Deploy"){
            steps {
                input 'Do you want to proceed?'
                sh "terraform apply --auto-approve"
            }
        }
    }
}