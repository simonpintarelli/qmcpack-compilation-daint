#!/usr/bin/env bash

export INSTALL_PREIFX=/apps/daint/SSL/simonpi/qmcpack-cpur
export QMC_SOURCE_DIR=${HOME}/qmcpack-3.10.0

mkdir -p ${INSTALL_PREIFX}
# load modules
module purge
# export EASYBUILD_PREFIX=/users/simonpi/jenkins/daint-haswell
module load modules
module load craype
module load PrgEnv-intel
# module swap PrgEnv-cray PrgEnv-intel
module load cudatoolkit
module load daint-gpu
module load EasyBuild-custom/cscs
module load cray-hdf5-parallel
module load CMake/3.14.5
module load PyExtensions/python3-CrayGNU-20.08
module load Boost/1.70.0-CrayGNU-20.08
# install libxml2 for CrayIntel
eb libxml2-2.9.7-CrayIntel-20.08.eb -r
module load libxml2/2.9.7-CrayIntel-20.08
module unload cray-libsci
module unload cray-libsci_acc
# make sure there is a recent gcc compiler in the path
module load gcc/8.3.0

# check what is loaded
module list

# CUDA 9.2 refuses to work with icc 18 set gcc as host compiler, need to avoid
# passing host flags to cuda (they are for the intel compiler)

bdir=/scratch/snx3000/simonpi/qmcpack-cpur
# build in /dev/shm
(
    # clean build directory
    rm -rf ${bdir}
    # create build directory
    mkdir -p ${bdir}
    cd ${bdir}
    export CRAY_LINK_TYPE=dynamic
    cmake  -DQMC_CUDA=Off \
           -DQMC_MPI=On \
           -DQMC_OMP=On \
           -DQMC_COMPLEX=1 \
           -DENABLE_PHDF5=On \
           -DCMAKE_SYSTEM_NAME=CrayLinuxEnvironment \
           -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
           ${QMC_SOURCE_DIR}
    make -j8
    make install
)

# set permissions
find -type d /apps/daint/SSL/simonpi -exec chmod a+rx {} \;
