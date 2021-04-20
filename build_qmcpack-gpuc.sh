#!/usr/bin/env bash

export mode=gpuc
export QMC_SOURCE_DIR=${HOME}/qmcpack-3.11.0
bdir=${QMC_SOURCE_DIR}/build_$mode


# load modules
module swap PrgEnv-cray PrgEnv-gnu
# module swap PrgEnv-cray PrgEnv-intel
module load daint-gpu
module load EasyBuild-custom/cscs
module load cray-hdf5-parallel
module load CMake/3.14.5
module load PyExtensions/python3-CrayGNU-20.11
module load Boost/1.75.0-CrayGNU-20.11
# install libxml2 for CrayGNU
eb libxml2-2.9.7-CrayGNU-20.11.eb -r
module load libxml2/2.9.7-CrayGNU-20.11
module load cudatoolkit
module load cray-fftw
module load intel

# check what is loaded
module list


(
    # clean build directory
    rm -rf ${bdir}
    # create build directory
    mkdir -p ${bdir}
    cd ${bdir}
    export CRAY_LINK_TYPE=dynamic
    # qmcpack wants to set this, but it breaks FindCUDA.cmake:
    # -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment
    # install in default dir, into build
    # -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
    CXX=CC cmake  \
       -DENABLE_CUDA=On \
           -DQMC_MPI=On \
           -DQMC_OMP=On \
           -DCUDA_ARCH=sm_60 \
           -DQMC_COMPLEX=1 \
           -DENABLE_PHDF5=On \
           ${QMC_SOURCE_DIR}
    make -j8
    make install
)

# set permissions
# export INSTALL_PREIFX=/apps/daint/SSL/simonpi/qmcpack-gpuc
# find -type d /apps/daint/SSL/simonpi -exec chmod a+rx {} \;
