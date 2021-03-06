node {
  def project = 'cogent-emblem-169721'
  def appName = 'website-home-page'
  def feSvcName = "${appName}"
  def imageTag = "gcr.io/${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"

  checkout scm

  stage 'Build image'
  def mvnHome = tool 'maven'
  sh "${mvnHome}/bin/mvn clean install -DskipTests"
  sh("docker build -t ${imageTag} .")

  stage 'Push image to registry'
  sh("gcloud docker -- push ${imageTag}")

  stage "Deploy Application"
  switch (env.BRANCH_NAME) {

    // Roll out to production
    case "master":
	sh("sed -i.bak 's#gcr.io/cogent-emblem-169721/website-home-page#${imageTag}#' ./k8s/production/*.yaml")
        sh("kubectl --namespace=production apply -f k8s/services/")
	sh("kubectl --namespace=production apply -f k8s/production/")
        sh("echo http://`kubectl --namespace=production get service/${feSvcName} --output=json | jq -r '.status.loadBalancer.ingress[0].ip'` > ${feSvcName}")
        break

  }
}
