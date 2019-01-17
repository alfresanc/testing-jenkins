/***
    Instance Role needs permissions to S3 Read and Write, cloudformation:UpdateStack, list, create and delete stacks, and EC2:DescribeVpcs and ec2:DescribeSubnets, iam:GetRole, lambda:UpdateFunctionConfiguration

    TODO: Update Lambdas even when there are not changes in CF template,
    Force re-creation of Lambdas with code changed.

    https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-lambda-function.html#cfn-lambda-function-description
    Name::
    If you specify a name, you can't perform updates that require replacement of this resource.
    You can perform updates that require no or some interruption. 
    If you must replace the resource, specify a new name.

    Requirements for Lambda Update::
    ( aws lambda update-function-code --function-name python37 --zip-file fileb://function.zip )
    To update a Lambda function whose source code is in an Amazon S3 bucket, 
    you must trigger an update by updating the S3Bucket, S3Key, or S3ObjectVersion property. 
    Updating the source code alone doesn't update the function.

    When This pipeline runs for the first time, the Lambda functions
    are deployed from the S3 bucket. The functions runs as expected until you change the 
    code and try to redeploy the stack. CloudFormation won’t recognise that the function 
    source code has changed, because the stack itself remains unchanged.

    There is no straightforward way to achieve this!! (ಥ_ಥ)
    Options::
    Official sugestion: 
    1- Enable versioning in the lambda-dep-test bucket
    2 - In your AWS::Lambda::Function declaration in your CloudFormation template, use the 
    S3ObjectVersion property in the Code section to specify which version should be deployed.
    3 - Update the template and specify a new S3ObjectVersion every time the lambda code is 
    updated in the bucket or you can declare it as a parameter in your template and reference 
    it in S3ObjectVersion. Both solutions can be scripted.
    OR Create a script that creates a new folder(S3Key) then load S3Key value from "parameters"
    OR Change template name.json at deployment time, pass new name in --stack-name
    OR use frameworks like serverless... (analyze)
    OR Create an event in S3. Whenever a new file is added, the event will trigger a different Lambda function which will update the original function.
    OR https://github.com/cloudreach/sceptre-zip-code-s3#how-to-install ...

    OR... Delete the stack and create a new one with latest zip files in S3::
    Previous requirements
    • Add to swagger lambda's ARN's values
    • Create APIGW using CLI and swagger definition
        echo 'Creating the API Gateway from .json file...'
        sh 'aws apigateway import-rest-api --fail-on-warnings --body file://swagger/cm-swagger-with-apigw-qas.json --parameters endpointConfigurationTypes=EDGE'
    • Update lambda's CF Template with API_GW's API_ID
        sh 'aws cloudformation update-stack --stack-name bigdata-cm-lambdas-qas --template-url file://IaC/cloudformation-templates/QAS/lambdas.json --parameters [...]'

    TODO: Automatic update of Lambdas CF stack when new Lambdas added to Swagger definition
    TODO: Automatic update of swagger with new lambdas ARN'

    For more info about S3 notifications setup from CloudFormation (LambdaPermission): http://mt.wiglaf.org/aaronm/2016/11/s3-triggered-lambda-via-beanstalk.html#fn1
***/

pipeline {

    agent { dockerfile true }

    stages {

        stage ('Clone & Pack') {
            steps {
                echo 'Downloading latest code version...'
                checkout scm
                notifyBuild('STARTED')
            }
        }
        stage ('Lambdas Zip -> S3') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        echo 'Uploading lambdas to S3...'
                    } else if (env.BRANCH_NAME == "qas"){
                        echo 'Uploading lambdas to S3...'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
            }
        }
        stage ('Lambdas CF Stack Update') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        echo 'Getting the latest stack template from Infraestructure-as-Code repo...'
                    } else if (env.BRANCH_NAME == "qas"){
                        echo 'Getting the latest stack template from Infraestructure-as-Code repo...'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
            }
        }
        stage ('API Update & Deploy') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'develop') {
                        echo 'Updating the API Gateway from latest swagger file, where ha5hs9mjk3 = API Gateway ID'
                    } else if (env.BRANCH_NAME == "qas"){
                        echo 'Updating the API Gateway from latest swagger file, where wz6royprbi = API Gateway ID'
                    } else {
                        echo 'Not allowed by now'
                    }
                }
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