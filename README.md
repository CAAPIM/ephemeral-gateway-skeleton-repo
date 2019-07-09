# ephemeral-gateway-skeleton-repo
Use this repository to start creating your own CI/CD pipeline with gateway configuration.

# About
This is a skeleton repository that you can use as a starting point for your gateway projects.

In order to use this as a starting point for you projects follow these steps:
1) Fork the repo and clone the forked repo on your local.
2) Fill in details in the following files:
   * `build.gradle`: build.gradle replace `<project-folder>` with the path of the folder that your solution is located on the Gateway. It must start with a `/`
   * : docker-compose.yml replace `<project.name>` with the name of your project. If not explicitly set it is usually the same as the name of the folder that your project is in (the one you created in step #2)

See more detail on using the gateway-developer-plugin here: [gateway-developer-plugin](https://github.com/ca-api-gateway/gateway-developer-plugin/wiki)

# Starting your project.
Put a valid gateway license in the `docker` folder. The license file should be called `license.xml`. For information on getting a license see the [License Section from the Gateway Container readme](https://hub.docker.com/r/caapim/gateway/).

## Exporting from your Gateway
If you connect to the running gateway with the CA API Gateway Policy Manager and make changes to the services and policies you can export those changes by running:

```./gradlew export```

This will export the changes to the various project folders. Note that your local edits will be overridden by changes from the gateway

## Building a Solution
In order to package the solution into something that can be applied to the CA API Gateway run the following Gradle command:

```./gradlew build```

## Running the Solution
In order to run the solution you need to do the following:

1) Put a valid gateway license in the `docker` folder. The license file should be called `license.xml`. For information on getting a license see the [License Section from the Gateway Container readme](https://hub.docker.com/r/caapim/gateway/).
2) Make sure you have already built the solution by running `./gradlew build`
3) Start the Gateway Container by running: `docker-compose up --force-recreate`

After the container is up and running you can connect the CA API Gateway Policy Manager to it.

## Stopping Docker container
To stop the running Gateway Container, run the following command:

`docker-compose  down`

## Adding webhook
You can add webhook in github repo under settings for jenkins job, so that jenkins job is ran each time there is commit in branch.
`http://<jenkins-host>/github-webhook/`

You can add project url in jenkins job, so that you can manually trigger job from jenkins directly.

## Usage
Modify below mentioned files for simple export from your existing gateway cluster:

	i. build.gradle
		a) my.group.id
		b) version
		c) host.name
		d) project.folder
	ii. settings.gradle
		a) project.name
	iii. Docker-compose (for local testing)
		a) project.name
		b) Version
		c) Add this under volume (if needed) "- ./src/main/gateway/config/env.properties:/opt/SecureSpan/Gateway/node/default/etc/bootstrap/env/env.properties"
	iv. Jenkinsfile (for K8s testing)
		a) git.repository
		b) image.name
	v. Dockerfile (for K8s testing)
		a) project.name
		b) version
    c) Add this below copy gw7 (if needed) "COPY src/main/gateway/config/env.properties /opt/SecureSpan/Gateway/node/default/etc/bootstrap/env/env.properties"


## Versioning
If you have setup github with a webhook to jenkins, then each commit/merge to master will create artifacts using Jenkins build job. If you do not want to create artifact on each merge, you can remove github webhook, keep git url in Jenkins job, so that you can run this job manually.

# Giving Back
## How You Can Contribute
Contributions are welcome and much appreciated. To learn more, see the [Contribution Guidelines][contributing].

## License

Copyright (c) 2018 CA. All rights reserved.

This software may be modified and distributed under the terms
of the MIT license. See the [LICENSE][license-link] file for details.


 [license-link]: /LICENSE
 [contributing]: /CONTRIBUTING.md
