pipeline {
    agent any
    
    tools { 
        maven 'mvn3.8.1' 
        jdk 'jdk8' 
    }
  
    stages {
      stage ('Initialize') {
         steps {
           sh '''
              echo "JAVA_HOME = ${JAVA_HOME}"
              echo "MAVEN_HOME = ${MAVEN_HOME}"
              echo "CurrentBuildNumb = ${BUILD_NUMBER}"
              echo "CurrentBuildWorkspace = ${WORKSPACE}"
           '''
         }
      }
      stage('gitlab') {
        steps {
          sh 'echo "Start Gitlab"'
          updateGitlabCommitStatus name: 'build', state: 'pending'
          updateGitlabCommitStatus name: 'build', state: 'success'
        }
      }  
      stage('Package') {
        steps {
          sh 'echo "Start  Packaging"'
          sh 'mvn clean compile package -DskipTests=true'
          sh 'cd ${WORKSPACE}/target'
          sh 'ls'
        }
      }
      stage('Dockerizing') {
        steps {
          sh 'echo "Start Dockerizing"'
          
          sh 'cd ${WORKSPACE}'
          sh 'docker build -f ./Dockerfile -t worker-node2:8123/msrsample:0.1 .'    
          //sh 'docker rmi $(docker images -aq --filter dangling=true)'      
          sh 'docker images'
          sh 'docker push worker-node2:8123/msrsample:0.1'
        }
      }
      stage('Deploy') {
        steps {    
          sh 'echo "Start Deploying"'
          
          // apply deployment
          sh 'kubectl apply -f ./k8s/msr-deployment.yaml'
          sh 'kubectl get deployment'
          sh 'kubectl -n default get pods'
          sh 'kubectl -n default describe deployment msrsample'

          // apply service
          sh 'kubectl apply -f ./k8s/msr-service.yaml'
          sh 'kubectl -n default get svc'
          sh 'kubectl -n default describe svc msrsample-svc'

          // apply ingress
          sh 'kubectl apply -f ./k8s/msr-ingress.yaml'
          sh 'kubectl -n default get ingress'
          sh 'kubectl -n default describe ingress msrsample-ingress-svc'
        }
      }
    }

    post {
      cleanup {
        deleteDir()
      }
    }
}
