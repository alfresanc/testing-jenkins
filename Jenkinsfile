pipeline {

    agent { dockerfile true }

    parameters { 
        string(name: 'DEPLOY_TO', defaultValue: '', description: '') 
        string(name: 'DEPLOY_COMMIT', defaultValue: '', description: '') 
    }

    stages {

        stage ('Clone & Pack') {
            steps {
                echo 'Downloading latest code version...'
                checkout scm
                notifyBuild('STARTED')
            }
        }
        stage('Checkout Commit') {
            when {
                expression { params.DEPLOY_COMMIT != '' }
            }
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: "${params.DEPLOY_COMMIT}"]]
                ])
            }
        }
        stage ('Banch IF') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        echo 'Uploading to develop...'
                    } else if (env.BRANCH_NAME == "qas"){
                        echo 'Uploading to qas...'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
            }
        }
        stage ('When Branch...') {
            when {
                expression { env.BRANCH_NAME == "develop" }
            }
            steps {
                echo 'When BRANCH_NAME == "develop"...'
            }
        }
        stage('Deploy Production') {
            when {
                expression { params.DEPLOY_TO == 'production' }
            }
            steps {
                echo 'Deploy to production'   
            }
        }
    }

    post {
        always {
            notifyBuild(currentBuild.result)
            cleanWs()
            // TODO: Cleanup step
            // docker system prune --force --all --volumes
            // sh 'docker rmi -f $(docker images -a -q)'
            // sh 'docker rm -vf $(docker ps -a -q)'
        }
        success {
            echo 'ʕ•ᴥ•ʔ'
        }
        failure {
            echo 'ʕ•ᴥ•ʔ'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
    }
}
def notifyBuild(String buildStatus = 'STARTED') {
    buildStatus = buildStatus ?: 'SUCCESS'
    String buildPhase = (buildStatus == 'STARTED') ? 'STARTED' : 'FINALIZED'
    commit = (buildStatus == 'STARTED') ? 'null' : sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'")
    
    sh """curl -H "Content-Type: application/json" -X POST -d '{
        "name": "${env.JOB_NAME}",
        "type": "pipeline",
        "build": {
            "phase": "${buildPhase}",
            "status": "${buildStatus}",
            "number": ${env.BUILD_ID},
            "scm": {
                "commit": "${commit}"
            },
            "artifacts": {}
        }
    }' https://devops.belcorp.biz/gestionar_despliegues_qa"""
}