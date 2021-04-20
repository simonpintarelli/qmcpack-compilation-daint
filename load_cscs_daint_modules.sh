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

