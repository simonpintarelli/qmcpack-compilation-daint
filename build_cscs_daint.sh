#!/bin/bash

export QMC_SOURCE_DIR=${HOME}/qmcpack-3.11.0
export QMC_BUILD_DIR=/scratch/snx3000/azen/BUILD_qmcpack-3.11.0
BUILD_MODULES=load_cscs_daint_modules.sh

# module purge
echo "Purging current module set"
echo "Sourcing file: $BUILD_MODULES to build QMCPACK"

. $BUILD_MODULES

echo "Either source $BUILD_MODULES or load these same modules to run QMCPACK"

declare -A builds=( \
	["cpu"]="-DQMC_COMPLEX=0 -DQMC_CUDA=0" \
	["complex_cpu"]="-DQMC_COMPLEX=1 -DQMC_CUDA=0" \
	["legacy_gpu"]="-DQMC_COMPLEX=0 -DQMC_CUDA=1" \
	["complex_legacy_gpu"]="-DQMC_COMPLEX=1 -DQMC_CUDA=1" \
)

mkdir bin

for build in "${!builds[@]}"
do
    echo "building: $build with ${builds[$build]}"
    export QMC_INSTALL_DIR=${QMC_SOURCE_DIR}/bin_${build}
#    rm bin/qmcpack_${build}
    rm -rf ${QMC_BUILD_DIR}/${build}
    mkdir ${QMC_BUILD_DIR}/${build}
    cd ${QMC_BUILD_DIR}/${build}
    export CRAY_LINK_TYPE=dynamic
    CXX=CC cmake \
           -DQMC_MPI=On \
           -DQMC_OMP=On \
           -DENABLE_PHDF5=On \
           ${builds[$build]} \
           -DCMAKE_INSTALL_PREFIX=${QMC_INSTALL_DIR} \
           ${QMC_SOURCE_DIR}
          ..
    make -j 20
    make install
#    if [ $? -eq 0 ]; then
#      build_dir=$(pwd)
#      ln -sf ${build_dir}/bin/qmcpack ${build_dir}/../bin/qmcpack_${build}
#    fi
    cd ..
done
