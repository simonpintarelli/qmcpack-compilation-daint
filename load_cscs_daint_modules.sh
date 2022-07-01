#!/bin/bash
echo "Loading QMCPACK dependency modules for cscs piz-daint"
echo "https://user.cscs.ch/access/running/piz_daint/"
echo
# load modules
module swap PrgEnv-cray PrgEnv-gnu
# module swap PrgEnv-cray PrgEnv-intel
module load daint-gpu
module load EasyBuild-custom/cscs
module load cray-hdf5-parallel
module load CMake
module load PyExtensions/python3-CrayGNU-21.09
module load Boost/1.78.0-CrayGNU-21.09
# install libxml2 for CrayGNU
eb libxml2-2.9.10-CrayGNU-21.09.eb -r
module load libxml2/2.9.10-CrayGNU-21.09
module load cudatoolkit
module load cray-fftw
module load intel
# check what is loaded
module list

