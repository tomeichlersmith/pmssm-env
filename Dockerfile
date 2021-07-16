FROM ubuntu:18.04

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
      build-essential \
      libssl-dev \
      gcc \
      g++ \
      make \
      gfortran \
      git \
      emacs \
      wget \
      libxft-dev \
      libxext-dev \
      libx11-dev \
      libxpm-dev \
      libboost-all-dev \
      libeigen3-dev \
      python2.7 \
      python-pip \
      python-tk \
    && apt-get clean all &&\
    python -m pip install --upgrade --no-cache-dir \
      numpy \
      scipy \
      matplotlib \
      pandas \
      cmake \
      tqdm 

RUN mkdir src &&\
    wget -q -O - https://root.cern/download/root_v6.12.06.source.tar.gz |\ 
      tar -xz --strip-components=1 --directory src &&\
    cmake \
      -Droofit=ON \
      -Dminuit2=ON \
      -DCMAKE_C_COMPILER=`which gcc` \
      -DCMAKE_CXX_COMPILER=`which g++` \
      -B build \
      -S src \
    && cmake --build build --target install -- -j &&\
    rm -rf build src &&\
    ln -s /usr/local/bin/thisroot.sh /etc/profile.d/thisroot.sh

RUN python -m pip install --upgrade --no-cache-dir \
      pyslha \
      uproot \
      root_numpy

COPY ./pMSSM_McMC /pMSSM_McMC
WORKDIR /pMSSM_McMC/packages

RUN tar -zxf FeynHiggs-2.18.0-patched.tar.gz &&\
    cd FeynHiggs-2.18.0 &&\
    ./configure &&\
    make && make install

RUN tar -zxvf SPheno-4.0.4.tar.gz &&\
    cd SPheno-4.0.4 &&\
    sed -i "/^F90/c\F90=gfortran" Makefile &&\
    make

RUN tar -zxf superiso_v4.0.tgz &&\
    cd superiso_v4.0 &&\
    cp ../slha.c . &&\
    cp ../slha_chi2_reduced.c . &&\
    make && make slha && make slha_chi2 &&\
    make slha_chi2_reduced

RUN tar -zxf v1.7.3.tar.gz &&\
    cmake -S GM2Calc-1.7.3 -B GM2Calc-1.7.3/build &&\
    cmake --build GM2Calc-1.7.3/build

RUN tar -zxf higgsbounds.tar.gz &&\
    cmake -S higgsbounds -B higgsbounds/build \
      -DFeynHiggs_ROOT=../../FeynHiggs-2.16.1 -DLEP_CHISQ=ON &&\
    cmake --build higgsbounds/build

RUN tar -zxf higgssignals.tar.gz &&\
    cmake -S higgssignals -B higgssignals/build \
      -DFeynHiggs_ROOT=../../FeynHiggs-2.16.1 &&\
    cmake --build higgssignals/build

RUN tar -zxvf micromegas_5.2.4.tgz &&\
    cp main.c micromegas_5.2.4/MSSM/main.c && cd micromegas_5.2.4 &&\
    make && cd MSSM && make main=main.c

WORKDIR /pMSSM_McMC
RUN chmod a+rwx -R packages/

# entrypoint can't be over-written,
#   we always go into this script to setup the environment
COPY ./entry.sh /usr/local/entry.sh
RUN chmod a+x /usr/local/entry.sh
ENTRYPOINT ["/usr/local/entry.sh"]

# CMD can be over-written when the run command is provided with
#   any arguments after the image tag
CMD ["/bin/bash"]
