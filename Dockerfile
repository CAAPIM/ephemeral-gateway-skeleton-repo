FROM docker.stable1.apimgcp.com/repository/docker-hosted/gateway:wlui-test
## Copying the deployment package
COPY build/gateway/<project.name>-<version>.gw7 /opt/docker/rc.d/deployment.gw7
## Make restman available
RUN touch /opt/SecureSpan/Gateway/node/default/etc/bootstrap/services/restman
