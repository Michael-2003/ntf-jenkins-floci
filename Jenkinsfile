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
        input message: "Apply ${params.ENV} plan?", ok: 'Apply'
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
      // Configure SMTP in Jenkins for real mail:
      // mail to: 'team@example.com', subject: "SUCCESS: ${env.JOB_NAME} ${params.ENV}", body: "Apply succeeded. ${env.BUILD_URL}"
    }
    failure {
      echo "FAIL: ${params.ENV} failed."
      // mail to: 'team@example.com', subject: "FAIL: ${env.JOB_NAME} ${params.ENV}", body: "Apply failed. ${env.BUILD_URL}"
    }
  }
}
