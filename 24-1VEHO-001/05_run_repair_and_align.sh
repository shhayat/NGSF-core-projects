#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=run_repair
#SBATCH --ntasks=1
#BATCH --cpus-per-task=10
#SBATCH --time=20:00:00
#SBATCH --mem=5G
#SBATCH --output=/project/anderson/%j.out

module load bbmap//39.06

repair.sh in= \
          in2= \
          out= \
          out2= \
          outs= \
          repair=t


