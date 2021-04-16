#!/usr/bin/env bash

export INSTALL_PREIFX=/apps/daint/SSL/simonpi/qmcpack-cpuc
export QMC_SOURCE_DIR=${HOME}/qmcpack-3.11.0

mkdir -p ${INSTALL_PREIFX}
# load modules
module swap PrgEnv-cray PrgEnv-intel
# module swap PrgEnv-cray PrgEnv-intel
module load daint-gpu
module load cudatoolkit
module load EasyBuild-custom/cscs
module load cray-hdf5-parallel
module load CMake/3.14.5
module load PyExtensions/python3-CrayGNU-20.11
module load Boost/1.75.0-CrayGNU-20.11
# install libxml2 for CrayGNU
eb libxml2-2.9.7-CrayGNU-20.11.eb -r
module load libxml2/2.9.7-CrayGNU-20.11
module unload cray-libsci
module unload cray-libsci_acc
# make sure there is a recent gcc compiler in the path

# check what is loaded
module list

bdir=/scratch/snx3000/simonpi/qmcpack-cpuc
# build in /dev/shm
(
    # clean build directory
    rm -rf ${bdir}
    # create build directory
    mkdir -p ${bdir}
    cd ${bdir}
    export CRAY_LINK_TYPE=dynamic
    CXX=CC cmake  -DQMC_CUDA=Off \
           -DQMC_MPI=On \
           -DQMC_OMP=On \
           -DQMC_COMPLEX=1 \
           -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment \
           -DENABLE_PHDF5=On \
           -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
           ${QMC_SOURCE_DIR}
    make -j8
    make install
)

# set permissions
find -type d /apps/daint/SSL/simonpi -exec chmod a+rx {} \;
