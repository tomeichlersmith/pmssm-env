# pmssm-env

<p align="center">
    <a href="http://perso.crans.org/besson/LICENSE.html" alt="GPLv3 license">
        <img src="https://img.shields.io/badge/License-GPLv3-blue.svg" />
    </a>
    <a href="https://github.com/tomeichlersmith/pmssm-env/actions" alt="Actions">
        <img src="https://github.com/tomeichlersmith/pmssm-env/workflows/Build/badge.svg" />
    </a>
    <a href="https://hub.docker.com/r/tomeichlersmith/pmssm-env" alt="DockerHub">
        <img src="https://img.shields.io/github/v/release/tomeichlersmith/pmssm-env" />
    </a>
</p>


Build context for DockerHub repository [tomeichlersmith/pmssm-env](https://hub.docker.com/r/tomeichlersmith/pmssm-env). This image is designed to run the code linked as a submodule [jennetd/pMSSM_McMC](https://github.com/jennetd/pMSSM_McMC).

### Context for the Build Context
I offered to help [@JHiltbrand](https://github.com/JHiltbrand) include some helper python packages in this container image since I have experience with developing these types of images.
I could not find the build context for the image I am trying to replicate ([jdickins/pmssm-env](https://hub.docker.com/r/jdickins/pmssm-env)),
so I wrote a context from scratch using the public listing of the image's layers on DockerHub.

The main difference between the tomeichlersmith version and the jdickins version is that I install ROOT and remove the build and source files.
This allows the image to be much lighter without removing any capabilities.
