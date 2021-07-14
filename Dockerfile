#FROM ubuntu:18.04
#
#RUN apt-get update &&\
#    apt-get install -y \
#      build-essential \
#      libssl-dev \
#      gcc \
#      g++ \
#      make \
#      gfortran \
#      git \
#      emacs \
#      wget \
#      libxft-dev \
#      libxext-dev \
#      libx11-dev \
#      libxpm-dev \
#      libboost-all-dev \
#      libeigen3-dev \
#      python2.7 \
#      python-pip &&\
#    apt-get clean all &&\
#    python -m pip install --upgrade --no-cache-dir \
#      numpy \
#      scipy \
#      matplotlib \
#      pandas \
#      cmake \
#      tqdm 
#
#RUN mkdir src &&\
#    wget -q -O - https://root.cern/download/root_v6.12.06.source.tar.gz |\ 
#      tar -xz --strip-components=1 --directory src &&\
#    cmake \
#      -Droofit=ON \
#      -Dminuit2=ON \
#      -DCMAKE_C_COMPILER=`which gcc` \
#      -DCMAKE_CXX_COMPILER=`which g++` \
#      -B build \
#      -S src \
#    && cmake --build build --target install &&\
#    rm -rf build src &&\
#    ln -s /usr/local/bin/thisroot.sh /etc/profile.d/thisroot.sh
#
#RUN python -m pip install --upgrade --no-cache-dir \
#      pyslha \
#      uproot \
#      root_numpy

# DEVELOPMENT - use image built with above lines as base for now
FROM tomeichlersmith/pmssm-env:sha-5522744c

COPY ./pMSSM_McMC /pMSSM_McMC
RUN cd pMSSM_McMC/packages &&\
    echo ::group::FeynHiggs-2.18.0-patched &&\
    tar -zxf FeynHiggs-2.18.0-patched.tar.gz &&\
    cd FeynHiggs-2.18.0 &&\
    ./configure &&\
    make && make install &&\
    cd .. &&\
    echo ::endgroup:: && echo ::group::SPheno-4.0.4 &&\
    tar -zxvf SPheno-4.0.4.tar.gz &&\
    cd SPheno-4.0.4 &&\
    sed -i "/^F90/c\F90=gfortran" Makefile &&\
    make &&\
    cd .. &&\
    echo ::endgroup:: && echo ::group::superiso_v4.0 &&\
    tar -zxf superiso_v4.0.tgz &&\
    cd superiso_v4.0 &&\
    cp ../slha.c . &&\
    cp ../slha_chi2_reduced.c . &&\
    make && make slha && make slha_chi2 &&\
    make slha_chi2_reduced &&\
    cd .. &&\
    echo ::endgroup:: && echo ::group::v1.7.3 &&\
    tar -zxf v1.7.3.tar.gz &&\
    cd GM2Calc-1.7.3 &&\
    mkdir build && cd build &&\
    cmake .. && make &&\
    cd .. &&\
    echo ::endgroup:: && echo ::group::higgsbounds &&\
    tar -zxf higgsbounds.tar.gz && cd higgsbounds &&\
    mkdir build && cd build &&\
    cmake .. -DFeynHiggs_ROOT=../../FeynHiggs-2.16.1 -DLEP_CHISQ=ON &&\
    make &&\
    cd .. &&\
    echo ::endgroup:: && echo ::group::higgssignals &&\
    tar -zxf higgssignals.tar.gz && cd higgssignals &&\
    mkdir build && cd build &&\
    cmake .. -DFeynHiggs_ROOT=../../FeynHiggs-2.16.1 && make &&\
    cd .. &&\
    echo ::endgroup:: && echo ::group::micromegas_5.2.4 &&\
    tar -zxvf micromegas_5.2.4.tgz &&\
    cp main.c micromegas_5.2.4/MSSM/main.c && cd micromegas_5.2.4 &&\
    make && cd MSSM && make main=main.c &&\
    cd .. &&\
    echo ::endgroup:: &&\
    chmod a+rwx -R /pMSSM_McMC/packages/
