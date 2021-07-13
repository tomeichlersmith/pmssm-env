FROM ubuntu:20.04

RUN apt-get update &&\
    apt-get install -y \
      build-essential \
      libssl-devl \
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
      python-pip &&\
    apt-get clean all &&\
    python pip install --upgrade &&\
      numpy \
      scipy \
      matplotlib \
      pandas \
      uproot \
      root_numpy \
      cmake \
      tqdm 

RUN mkdir src &&\
    ${__wget} https://root.cern/download/root_v6.12.06.source.tar.gz |\
     ${__untar} &&\
    cmake \
      -Droofit=ON \
      -Dminuit2=ON \
      -DCMAKE_C_COMPILER=`which gcc` \
      -DCMAKE_CXX_COMPILER=`which g++` \
      -B build \
      -S src \
    && cmake --build build --target install &&\
    rm -rf build src &&\
    echo "source /usr/local/bin/thisroot.sh" >> $HOME/.bashrc

RUN python pip install --upgrade pyslha

RUN git clone https://github.com/jennetd/pMSSM_McMC &&\
    cd pMSSM_McMC/packages &&\
    tar -zxf FeynHiggs-2.18.0-patched.tar.gz &&\
    cd FeynHiggs-2.18.0 &&\
    ./configure &&\
    make && make install &&\
    cd .. &&\
    tar -zxvf SPheno-4.0.4.tar.gz &&\
    cd SPheno-4.0.4 &&\
    sed -i "/^F90/c\F90=gfortran" Makefile &&\
    make &&\
    cd .. &&\
    tar -zxf superiso_v4.0.tgz &&\
    cd superiso_v4.0 &&\
    cp ../slha.c . &&\
    cp ../slha_chi2_reduced.c . &&\
    make && make slha && make slha_chi2 &&\
    make slha_chi2_reduced &&\
    cd .. &&\
    tar -zxf v1.7.3.tar.gz &&\
    cd GM2Calc-1.7.3 &&\
    mkdir build && cd build &&\
    cmake .. && make &&\
    cd .. &&\
    tar -zxf higgsbounds.tar.gz && cd higgsbounds &&\
    mkdir build && cd build &&\
    cmake .. -DFeynHiggs_ROOT=../../FeynHiggs-2.16.1 -DLEP_CHISQ=ON &&\
    make &&\
    cd .. &&\
    tar -zxf higgssignals.tar.gz && cd higgssignals &&\
    mkdir build && cd build &&\
    cmake .. -DFeynHiggs_ROOT=../../FeynHiggs-2.16.1 && make &&\
    cd .. &&\
    tar -zxvf micromegas_5.2.4.tgz &&\
    cp main.c micromegas_5.2.4/MSSM/main.c && cd micromegas_5.2.4 &&\
    make && cd MSSM && make main=main.c &&\
    cd .. &&\
    chmod a+rwx -R /pMSSM_McMC/packages/
