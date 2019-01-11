pipeline {

    agent { dockerfile true }

    stages {

        stage ('Clone') {
            steps {
                // slackSend color: '#00A0D5', message: 'A Jenkins build has started @BackEnd! We will have a break in services for a couple of minutes. Check it out: http://54.208.251.213'
                echo 'Downloading latest code version...'
                checkout scm
            }
        }
        stage ('Coverage') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh 'make coverage'
                    } else if (env.BRANCH_NAME == "master"){
                        echo 'Holi'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
            }
        }
        stage ('Deploy') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh 'make deploy'
                    } else if (env.BRANCH_NAME == "master"){
                        echo 'Not allowed by now'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
            }
        }
        stage ('Clean') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        sh 'make clean'
                    } else if (env.BRANCH_NAME == "master"){
                        echo 'Not allowed by now'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Testing always post condition'
            // TODO: Cleanup step
            // docker system prune --force --all --volumes
            // sh 'docker rmi -f $(docker images -a -q)'
            // sh 'docker rm -vf $(docker ps -a -q)'
        }
        success {
            echo 'Testing always post condition'
            // slackSend color: 'good', message: 'Build has finished! You can continue using the services ʕ•ᴥ•ʔ'
        }
        failure {
            echo 'Testing always post condition'
            // slackSend color: '#C33720', message: 'Jenkins Pipeline execution has failed (ಥ_ಥ) See what happened at: http://54.208.251.213 and in https://console.aws.amazon.com/cloudformation'
        }
    }

}