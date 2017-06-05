node {
  tools {
      maven 'Maven 3.5.0'
      jdk 'jdk8'
  }
  def project = 'cogent-emblem-169721'
  def appName = 'website-home-page'
  def feSvcName = "${appName}"
  def imageTag = "gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

  checkout scm

  stage 'Build image'
   sh '''echo "PATH = ${PATH}"'''
   sh '''echo "M2_HOME = ${M2_HOME}"'''

  sh("docker build -t ${imageTag} .")

  stage 'Push image to registry'
  sh("gcloud docker push ${imageTag}")

  stage "Deploy Application"
  switch (env.BRANCH_NAME) {

    // Roll out to production
    case "master":
        sh("kubectl --namespace=production apply -f k8s/services/")
        sh("kubectl --namespace=production apply -f k8s/production/")
        sh("echo http://`kubectl --namespace=production get service/${feSvcName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip'` > ${feSvcName}")
        break

  }
}
