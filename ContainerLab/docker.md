## Pull the hello-world image from Microsoft Container Registry.

docker pull mcr.microsoft.com/hello-world

## Tag the image using the docker tag command. Replace <login-server> with the login server name of your ACR instance.

docker tag mcr.microsoft.com/hello-world <login-server>/hello-world:v1

## For examp

docker tag mcr.microsoft.com/hello-world newregistryapl.azurecr.io/hello-world:v1

## This example creates the hello-world repository, containing the hello-world:v1 image.

docker push <login-server>/hello-world:v1

## For example:

docker push newregistryapl.azurecr.io/hello-world:v1

## The docker rmi command doesn't remove the image from the hello-world repository in your Azure container registry.

docker rmi <login-server>/hello-world:v1


## Now you can pull and run the hello-world:v1 container image from your container registry by using docker run:

docker run <login-server>/hello-world:v1

## For example:

docker run newregistryapl.azurecr.io/hello-world:v1
