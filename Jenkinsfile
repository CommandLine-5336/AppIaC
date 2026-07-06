pipeline {
    agent any

    environment {
        ANSIBLE_CONFIG = 'Ansible/ansible.cfg'
    }

    stages {
        stage('Clone App repo') {
            steps {
                dir('BirdWathcingApp') {
                    git(url: 'https://github.com/CommandLine-5336/BirdWatchingApp.git', branch: 'main')
                }
            }
        }
        
        stage('MariaDB playbook') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'database_name',
                        variable: 'DB_NAME'
                    ),
                    usernamePassword(
                        credentialsId: 'database_credentials',
                        passwordVariable: 'DB_PASSWORD',
                        usernameVariable: 'DB_USER'
                    )
                ]) {
                    ansiblePlaybook(
                        credentialsId: 'vm_ssh_key',
                        extraVars: [
                            db_name: "$DB_NAME",
                            db_user: "$DB_USER",
                            db_password: "$DB_PASSWORD"
                        ],
                        installation: 'Ansible',
                        playbook: 'Ansible/db_playbook.yml'
                    )
                }
            }
        }

        stage('Webserver playbook') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'database_name',
                        variable: 'DB_NAME'
                    ),
                    usernamePassword(
                        credentialsId: 'database_credentials',
                        passwordVariable: 'DB_PASSWORD',
                        usernameVariable: 'DB_USER'
                    ),
                    string(
                        credentialsId: 'flask_secret_key',
                        variable: 'SECRET_KEY'
                    )
                ]) {
                    ansiblePlaybook(
                        credentialsId: 'vm_ssh_key',
                        extraVars: [
                            db_name: "$DB_NAME",
                            db_user: "$DB_USER",
                            db_password: "$DB_PASSWORD",
                            secret_key: "$SECRET_KEY"
                        ],
                        installation: 'Ansible',
                        playbook: 'Ansible/app_playbook.yml'
                    )
                }
            }
        }
        
        stage('Load balanser playbook') {
            steps {
                ansiblePlaybook(
                    credentialsId: 'vm_ssh_key',
                    installation: 'Ansible',
                    playbook: 'Ansible/lb_playbook.yml'
                )
            }

            post {
                always {
                    cleanWs()
                }
            }
        }
    }
}
