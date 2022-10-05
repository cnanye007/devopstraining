pipeline {
  agent any
  tools {
    terraform 'terraform.io'
}
  options {
    skipDefaultCheckout(true)
  }
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        git branch: 'terraform', credentialsId: 'Github_credentials', url: 'https://github.com/cnanye007/devopstraining.git'
      }
    }
    stage('terraform_init') {
      steps {
        sh label: '', script: 'terraform init'
      }
    }
    stage('terraform_plan') {
      steps {
        sh label: '', script: 'terraform plan'
      }
    }
    stage('terraform_apply') {
      steps {
        sh label: '', script: 'terraform apply --auto-approve'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
