#!/bin/sh

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=germline
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=40G
#SBATCH --time=48:00:00
#SBATCH --output=%j.out

module --force purge
module load StdEnv/2020
module load nextflow/22.10.6
module load gentoo/2020
module load singularity/3.9.2
                       
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/
dbSNP=/datastore/NGSF001/analysis/dbsnp/GCF_000001405.40.vcf
mkdir -p ${DIR}/analysis

nextflow run nf-core/sarek -profile singularity \
                           --input ${DIR}/sample_sheet.csv \
                           --genome GATK.GRCh38 \
                           --step mapping \
                           --save_mapped 'TRUE' \
                           --wes 'TRUE' \
                           --no_intervals 'TRUE' \
                           --tools HaplotypeCaller,snpEff,VEP \
                           --known_snps ${dbSNP} \
                           --joint_germline 'TRUE' \
                           --outdir ${DIR}/analysis
                           
