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

### Usage

The entry-point for this container sets-up ROOT before running any provided commands, 
so you can assume that ROOT has already been sourced. 
Moreover, the default command defined is `/bin/bash`, 
so if you just want to enter the container in a shell, 
you don't need to provide any arguments.

```bash
singularity run <mount-directories-and-other-flags> docker://tomeichlersmith/pmssm-env
```

> **Note**: The above command assumes that your `SINGULARITY_CACHEDIR` is large enough to hold this image for you. Alternatively, you can build a `.sif` file before attempting to run.

```bash
SINGULARITY_CACHEDIR="<big-temp-dir>" TMPDIR="<big-temp-dir>" \
  singularity build tomeichlersmith_pmssm-env.sif docker://tomeichlersmith/pmssm-env
singularity run <flags> tomeichlersmith_pmssm-env.sif
```

### Context for the Build Context
I offered to help [@JHiltbrand](https://github.com/JHiltbrand) include some helper python packages in this container image since I have experience with developing these types of images.
I could not find the build context for the image I am trying to replicate ([jdickins/pmssm-env](https://hub.docker.com/r/jdickins/pmssm-env)),
so I wrote a context from scratch using the public listing of the image's layers on DockerHub.

The main difference between the tomeichlersmith version and the jdickins version is that I install ROOT and remove the build and source files.
This allows the image to be much lighter without removing any capabilities.
