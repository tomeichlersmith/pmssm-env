# pmssm-env

Build context for DockerHub repository [tomeichlersmith/pmssm-env](https://hub.docker.com/repository/docker/tomeichlersmith/pmssm-env).

I offered to help @JHiltbrand include some helper python packages in this container image since I have experience with developing these types of images.
I could not find the build context for the image I am trying to replicate ([jdickins/pmssm-env](https://hub.docker.com/r/jdickins/pmssm-env)),
so I wrote a context from scratch using the public listing of the image's layers on DockerHub.

The main difference between the tomeichlersmith version and the jdickins version is that I install ROOT and remove the build and source files.
This allows the image to be much lighter without removing any capabilities.
