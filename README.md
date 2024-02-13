
To install RFdiffusion on your Slurm-based cluster:

Download requirements.txt and setup.sh to your repository of interest

Edit setup.sh to name your virtual environment for running RFdiffusion (Default is rfvenv)

run 
`sbatch setup.sh`

running setup.sh will install all dependences, Rfdiffusion, Rfdiffusion models, etc
It will also test that RFdiffusion is working properly by running a test case. 
