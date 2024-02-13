#!/bin/bash

#SBATCH -p short
#SBATCH -c 2
#SBATCH --time=2:00:00
#SBATCH --mem=4G

# variables for setup
VIRTUAL_ENVIRONMENT_NAME="rfvenv"
RFdiffusion_name=rfdiffusion

# load in python version -- your choices might be different depending on your cluster provider
module load python/3.10.11

# Download RFdiffusion code
git clone https://github.com/RosettaCommons/RFdiffusion $RFdiffusion_name
cd $RFdiffusion_name
# Download RFdiffusion models
mkdir models && cd models
wget http://files.ipd.uw.edu/pub/RFdiffusion/6f5902ac237024bdd0c176cb93063dc4/Base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/e29311f6f1bf1af907f9ef9f44b8328b/Complex_base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/60f09a193fb5e5ccdc4980417708dbab/Complex_Fold_base_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/74f51cfb8b440f50d70878e05361d8f0/InpaintSeq_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/76d00716416567174cdb7ca96e208296/InpaintSeq_Fold_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/5532d2e1f3a4738decd58b19d633b3c3/ActiveSite_ckpt.pt
wget http://files.ipd.uw.edu/pub/RFdiffusion/12fc204edeae5b57713c5ad7dcb97d39/Base_epoch8_ckpt.pt

#Optional: comment out if you don't want it
wget http://files.ipd.uw.edu/pub/RFdiffusion/f572d396fae9206628714fb2ce00f72e/Complex_beta_ckpt.pt

# original structure prediction weights
wget http://files.ipd.uw.edu/pub/RFdiffusion/1befcb9b28e2f778f53d47f18b7597fa/RF_structure_prediction_weights.pt

# change back to main directory
cd ../../

# create rfdiffusion virtual environment
virtualenv $VIRTUAL_ENVIRONMENT_NAME
source $VIRTUAL_ENVIRONMENT_NAME/bin/activate

# install dependencies in requirements text file
python3 -m pip install -r requirements.txt

# install RFdiffusion
cd $RFdiffusion_name
pip install .
cd ..

# link the models and the examples to the pip install
mkdir $VIRTUAL_ENVIRONMENT_NAME/lib/python3.10/site-packages/models
cd $VIRTUAL_ENVIRONMENT_NAME/lib/python3.10/site-packages/models
ln -s ../../../../../$RFdiffusion_name/models/* .
cd ../../../../../

mkdir $VIRTUAL_ENVIRONMENT_NAME/lib/python3.10/site-packages/examples
cd $VIRTUAL_ENVIRONMENT_NAME/lib/python3.10/site-packages/examples
ln -s ../../../../../$RFdiffusion_name/examples/* .
cd ../../../../../

# Run test to see if you successfully installed RFdiffusion
./$RFdiffusion_name/scripts/run_inference.py 'contigmap.contigs=[10-10]' inference.output_prefix=test_outputs/test inference.num_designs=1