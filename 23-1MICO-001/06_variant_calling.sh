#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=varaint_calling
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=08:00:00
#SBATCH --mem=20G
#SBATCH  --output=%j_variantcalling.out

#https://genomemedicine.biomedcentral.com/articles/10.1186/s13073-020-00791-w
module load varscan
module load htslib/1.14

sample_name=$1;shift
BAM_FILE=$1;

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2
REF=/datastore/NGSF001/analysis/references/iGenomes/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa
mkdir -p ${OUTDIR}

samtools mpileup -B -f ${REF} ${BAM_FILE} > ${OUTDIR}/${sample_name}.pileup


#base quality > 30 and read depth > 20, #--min-var-freq 0  means all vaiants are selected
java -jar $EBROOTVARSCAN/VarScan.v2.4.2.jar mpileup2snp ${OUTDIR}/${sample_name}.pileup \
            --min-coverage 20 \
            --min-avg-qual 30 \
            --min-var-freq 0 \
            --variants SNP \
            --p-value 0.05 \
            --output-vcf 1 > ${OUTDIR}/${sample_name}_snps_ReadDepth20_BaseQuality30.vcf

bgzip -c ${OUTDIR}/${sample_name}_snps_ReadDepth20_BaseQuality30.vcf > ${OUTDIR}/${sample_name}_snps_ReadDepth20_BaseQuality30.vcf.gz
