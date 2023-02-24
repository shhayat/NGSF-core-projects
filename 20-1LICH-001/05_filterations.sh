#!/bin/bash
#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=bcftools-filter
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mem=2G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux

##loading required modules
module load StdEnv/2020
module load gcc/9.3.0
module load bcftools/1.13

PROJECT_ID='20-1LICH-001'
CLONE_ID=$1
PREP1=$2
PREP2=$3
SAMPLE_TYPE=$4


if [[ $SAMPLE_TYPE == "filtered induced" ]] #uninduced sample snvs were subracted from induced samples
then
INPUT_DIR="${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/filtered_vcfs/"
#filter induced vcfs on Read Depth and TLOD for induced samples
bcftools filter \
              ${INPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}.vcf.gz \
              -i 'FORMAT/DP>=10 && TLOD >=6.3' \
              -o ${INPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod.vcf.gz
#Generate Stats        
bcftools stats \
             ${INPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod.vcf.gz > ${INPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod.stats
             
#select only SNVs
bcftools view \
            ${INPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod.vcf.gz \
            -v snps \
            -o ${INPUT_DIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod_only_SNVs.vcf.gz

elif [[ $SAMPLE_TYPE == "induced" ]]
then
INPUT_DIR="/datastore/NGSF001/projects/20-1LICH-001/mutect2-pipeline/mutect2_calling/"
OUTDIR="${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/filtered_vcfs/"
bcftools filter \
              ${INPUT_DIR}${PREP1}_${PREP2}.vcf.gz \
              -i 'FORMAT/DP>=10 && TLOD >=6.3' \
              -o ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod_orignial.vcf.gz
#Generate Stats        
bcftools stats \
             ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod_orignial.vcf.gz > ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod_orignial.stats
             
#select only SNVs
bcftools view \
             ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod_orignial.vcf.gz \
            -v snps \
            -o ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_and_tlod_only_SNVs_original.vcf.gz

else
INPUT_DIR="/datastore/NGSF001/projects/20-1LICH-001/mutect2-pipeline/mutect2_calling/"
OUTDIR="${HOME}/projects/${PROJECT_ID}/mutect2-pipeline/filtered_vcfs/"
bcftools filter \
              ${INPUT_DIR}${PREP1}_${PREP2}.vcf.gz \
              -i 'FORMAT/DP>=10' \
              -o ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp.vcf.gz
#Generate Stats        
bcftools stats \
             ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp.vcf.gz > ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp.stats
             
#select only SNVs
bcftools view \
            ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp.vcf.gz \
            -v snps \
            -o ${OUTDIR}${CLONE_ID}_${PREP1}_${PREP2}_filtered_on_dp_only_SNVs.vcf.gz

fi

#bcftools query \
#             ${INPUT_DIR}${CLONE_ID}_filtered_on_dp_and_tlod.vcf.gz \
#             -f '%POS\n' | wc -l \
#             -o ${INPUT_DIR}${CLONE_ID}_filtered_on_dp_and_tlod_stats.vcf.gz


#bcftools query -i 'FORMAT/DP>=15 && AF <=0.05' -f '%CHROM %POS %REF %ALT %DP [%AF] %TYPE\n' MCF7_A3A_uninduced_concat.vcf.gz -o MCF7_A3A_uninduced_filtered.vcf.gz

#https://gatk.broadinstitute.org/hc/en-us/community/posts/360076993852-QUAL-values-not-present-in-Mutect2-VCF
#https://www.biostars.org/p/184955/
#https://www.biostars.org/p/490144/
#https://genomemedicine.biomedcentral.com/articles/10.1186/s13073-020-00791-w
