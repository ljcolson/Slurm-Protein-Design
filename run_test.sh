#!/bin/bash

#SBATCH -p short
#SBATCH -c 2
#SBATCH --time=1:00:00
#SBATCH --mem=4G

# variables for setup
VIRTUAL_ENVIRONMENT_NAME="rfvenv"
RFdiffusion_name=rfdiffusion

source $VIRTUAL_ENVIRONMENT_NAME/bin/activate

# Run test to see if you successfully installed RFdiffusion
./$RFdiffusion_name/scripts/run_inference.py 'contigmap.contigs=[10-10]' inference.output_prefix=test_outputs/test inference.num_designs=1