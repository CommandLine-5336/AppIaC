pipeline {
    agent any

    environment {
        ANSIBLE_CONFIG = 'ansible/ansible.cfg'
    }

    stages {
        stage('Clone App repo') {
            steps {
                dir('BirdWatchingApp') {
                    git(url: 'https://github.com/CommandLine-5336/BirdWatchingApp.git', branch: 'fix/CL-132-Adapt-BirdWatching-code-to-work-on-EC2')
                }
            }
        }

        stage('Consul playbook') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'gossip_key',
                        variable: 'GOSSIP_KEY'
                    )
                ]) {
                    ansiblePlaybook(
                        credentialsId: 'vm_ssh_key',
                        extraVars: [
                            consul_gossip_key: "$GOSSIP_KEY"
                        ],
                        installation: "Ansible",
                        playbook: 'ansible/consul_playbook.yml'
                    )
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
                        playbook: 'ansible/db_playbook.yml'
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
                    ),
                    string(
                        credentialsId: 'app_s3_bucket',
                        variable: 'S3_BUCKET'
                    ),
                    string(
                        credentialsId: 'app_s3_region',
                        variable: 'S3_REGION'
                    )
                ]) {
                    ansiblePlaybook(
                        credentialsId: 'vm_ssh_key',
                        extraVars: [
                            db_name: "$DB_NAME",
                            db_user: "$DB_USER",
                            db_password: "$DB_PASSWORD",
                            secret_key: "$SECRET_KEY",
                            s3_bucket: "$S3_BUCKET",
                            s3_region: "$S3_REGION"
                        ],
                        installation: 'Ansible',
                        playbook: 'ansible/app_playbook.yml'
                    )
                }
            }
        }
        
        stage('Load balanser playbook') {
            steps {
                ansiblePlaybook(
                    credentialsId: 'vm_ssh_key',
                    installation: 'Ansible',
                    playbook: 'ansible/lb_playbook.yml'
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
