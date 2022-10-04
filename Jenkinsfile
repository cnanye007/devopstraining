pipeline {
  agent { label 'linux'}
  options {
    skipDefaultCheckout(true)
  }
  stages {
    stage('buildChoice') {
        //default choice pull request , ecr publish and deploy stages skipped
        //depends on the deploy type ecr , region, eks loaded from jenkins
        //the variable BuildTypeAndEnv also used in docker.gradle
        steps {
            script {
                properties([
                        parameters([
                                choice(
                                        choices: ['pullRequest', 'uatEnv','devEnv', 'stageEnv', 'testEnv','prodEnv'],
                                        name: 'BuildTypeAndEnv'
                                ),
                                string(description: 'TagName(optional for Stage/Dev , mandatory for Test/Preview/Prod) for deployment', name: 'TagName')
                        ])])
            }
        }
    }
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('terraform_plan') {
      steps {
        sh './terraformw plan -auto-approve -no-color'
      }
    }
    stage('terraform_apply') {
      steps {
        sh './terraformw apply -auto-approve -no-color'
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
