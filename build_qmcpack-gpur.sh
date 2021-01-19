#!/usr/bin/env bash

export INSTALL_PREIFX=/apps/daint/SSL/simonpi/qmcpack-gpur
export QMC_SOURCE_DIR=${HOME}/qmcpack

mkdir -p ${INSTALL_PREIFX}
# load modules
module purge
# export EASYBUILD_PREFIX=/users/simonpi/jenkins/daint-haswell
module load modules
module load craype
module load PrgEnv-intel
# module swap PrgEnv-cray PrgEnv-intel
module load cudatoolkit/9.2.148_3.19-6.0.7.1_2.1__g3d9acc8
module load daint-gpu
module load EasyBuild-custom/cscs
module load cray-hdf5-parallel
module load CMake/3.12.4
module load PyExtensions/2.7.15.1-CrayGNU-18.08
module load Boost/1.67.0-CrayGNU-18.08
# install libxml2 for CrayIntel
eb libxml2-2.9.7-CrayIntel-18.08 -r
module load libxml2/2.9.7-CrayIntel-18.08
module unload cray-libsci
module unload cray-libsci_acc
# make sure there is a recent gcc compiler in the path
module load gcc/6.2.0

# check what is loaded
module list

# CUDA 9.2 refuses to work with icc 18 set gcc as host compiler, need to avoid
# passing host flags to cuda (they are for the intel compiler)

bdir=/scratch/snx3000/simonpi/qmcpack-gpur
# build in /dev/shm
(
    # clean build directory
    rm -rf ${bdir}
    # create build directory
    mkdir -p ${bdir}
    cd ${bdir}
    export CRAY_LINK_TYPE=dynamic
    cmake  -DQMC_CUDA=On \
           -DQMC_MPI=On \
           -DQMC_OMP=On \
           -DQMC_COMPLEX=0 \
           -DCUDA_ARCH=sm_60 \
           -DENABLE_PHDF5=On \
           -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
           -DCUDA_PROPAGATE_HOST_FLAGS=Off \
           -DCUDA_HOST_COMPILER=`which gcc` \
           ${QMC_SOURCE_DIR}
    make -j8
    make install
)

# set permissions
find -type d /apps/daint/SSL/simonpi -exec chmod a+rx {} \;
