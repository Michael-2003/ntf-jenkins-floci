pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['dev', 'stg', 'prod'], description: 'Target environment (selects <env>.tfvars + workspace)')
  }

  environment {
    AWS_ACCESS_KEY_ID     = 'test'
    AWS_SECRET_ACCESS_KEY = 'test'
    AWS_DEFAULT_REGION    = 'us-east-1'
    // Jenkins container reaches Floci via Docker network; host runs use localhost:4566
    AWS_ENDPOINT_URL      = 'http://floci:4566'
    TF_VAR_aws_endpoint   = 'http://floci:4566'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init -input=false'
      }
    }

    stage('Workspace Select') {
      steps {
        sh '''
          terraform workspace new ${ENV} 2>/dev/null || true
          terraform workspace select ${ENV}
          terraform workspace list
        '''
      }
    }

    stage('Plan') {
      steps {
        sh 'terraform plan -input=false -var-file=${ENV}.tfvars -out tfplan'
        archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
      }
    }

    stage('Approve') {
      steps {
        input message: "Please Michael ba4a, can u apply ${params.ENV} plan?", ok: 'Yes ba4a, Apply'
      }
    }

    stage('Apply') {
      steps {
        sh 'terraform apply -input=false -auto-approve tfplan'
        sh 'terraform output'
      }
    }
  }

  post {
    success {
      echo "SUCCESS: ${params.ENV} applied."
      mail to: 'michaelhany0303@gmail.com', subject: "SUCCESS: ${env.JOB_NAME} ${params.ENV} #${env.BUILD_NUMBER}", body: "Apply succeeded.\nJob: ${env.JOB_NAME}\nEnv: ${params.ENV}\nBuild: ${env.BUILD_URL}\nOutputs: see console log."
    }
    failure {
      echo "FAIL: ${params.ENV} failed."
      mail to: 'michaelhany0303@gmail.com', subject: "FAIL: ${env.JOB_NAME} ${params.ENV} #${env.BUILD_NUMBER}", body: "Apply failed.\nJob: ${env.JOB_NAME}\nEnv: ${params.ENV}\nBuild: ${env.BUILD_URL}\nCheck console output."
    }
  }
}
