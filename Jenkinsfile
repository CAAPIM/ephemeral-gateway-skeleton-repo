import java.time.*
pipeline {
    agent any

    environment {
        GIT_REPOSITORY = '<git.repository>'
	GIT_LAST_COMMIT = sh ([script: "git rev-parse HEAD", returnStdout: true]).trim()
        BASE_IMAGE_NAME = 'gateway'
        BASE_IMAGE_TAG = 'wlui-test'
        BASE_IMAGE_REGISTRY_HOSTNAME = 'docker.stable1.apimgcp.com'
        BASE_IMAGE_REGISTRY_REPOSITORY    = 'docker-hosted'
        NEW_IMAGE_NAME = '<image.name>'
	CURRENT_TIME = new Date().getTime()
        NEW_IMAGE_TAG = "${CURRENT_TIME}_${GIT_LAST_COMMIT}"
        NEW_IMAGE_REGISTRY_HOSTNAME = 'docker.stable1.apimgcp.com'
        NEW_IMAGE_REGISTRY_REPOSITORY    = 'docker-hosted'
    }

    stages {
        stage('Pull from Git') {
            steps {
                git "${env.GIT_REPOSITORY}"
            }
        }
        stage('Gradle Preparation & Build') {
            steps {
                sh '''./gradlew clean
                        ./gradlew build'''

            }
        }
        stage('Build Image with Docker') {
            steps {
                sh """docker login ${env.BASE_IMAGE_REGISTRY_HOSTNAME} -u ${params.BASE_IMAGE_REGISTRY_USER} --password ${params.BASE_IMAGE_REGISTRY_PASSWORD}
                        docker pull ${env.BASE_IMAGE_REGISTRY_HOSTNAME}/repository/${env.BASE_IMAGE_REGISTRY_REPOSITORY}/${env.BASE_IMAGE_NAME}:${env.BASE_IMAGE_TAG}
                        ./gradlew -DimageName=${env.NEW_IMAGE_NAME} -DimageTag=${env.NEW_IMAGE_TAG} buildDockerImage"""
            }
        }
        stage('Testing Docker image') {
            steps {
                script {
                    def jobDir = pwd()
                    env.GATEWAY_CONTAINER_ID = sh script: "docker run --env ACCEPT_LICENSE=true --env EXTRA_JAVA_ARGS=-Dcom.l7tech.bootstrap.env.license.enable=true --env SSG_LICENSE=\$(cat $jobDir/../../license.xml | gzip | base64 --wrap=0) -p 8080 -p 8443 -d ${env.NEW_IMAGE_NAME}:${env.NEW_IMAGE_TAG} | cut -c 1-12", returnStdout: true
                    env.GATEWAY_CONTAINER_IP = sh([script: "docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${env.GATEWAY_CONTAINER_ID}", returnStdout: true]).trim()
                }

                timeout(4) {
                    waitUntil {
                        script {
                            def r = sh script: "wget http://${env.GATEWAY_CONTAINER_IP}:8080/quota", returnStatus: true
                            return (r == 0);
                        }
                    }

                }
                sh "docker stop ${env.GATEWAY_CONTAINER_ID}"
            }
        }
	   stage('Login Docker, Tag and push docker image to Nexus') {
            steps {
		        sh """docker login ${env.NEW_IMAGE_REGISTRY_HOSTNAME} -u ${params.NEW_IMAGE_REGISTRY_USER} --password ${params.NEW_IMAGE_REGISTRY_PASSWORD}
                     docker tag ${env.NEW_IMAGE_NAME}:${env.NEW_IMAGE_TAG} ${env.NEW_IMAGE_REGISTRY_HOSTNAME}/repository/${env.NEW_IMAGE_REGISTRY_REPOSITORY}/${env.NEW_IMAGE_NAME}:${env.NEW_IMAGE_TAG}
			         docker push ${env.NEW_IMAGE_REGISTRY_HOSTNAME}/repository/${env.NEW_IMAGE_REGISTRY_REPOSITORY}/${env.NEW_IMAGE_NAME}:${env.NEW_IMAGE_TAG}"""
            }
        }
        stage('Update current gateway with the latest gateway image from nexus') {
            steps {
                sh """kubectl get svc
                    kubectl set image deployment/gw-default gw=${env.NEW_IMAGE_REGISTRY_HOSTNAME}/repository/${env.NEW_IMAGE_REGISTRY_REPOSITORY}/${env.NEW_IMAGE_NAME}:${env.NEW_IMAGE_TAG}"""
            }
        }
    }
}
