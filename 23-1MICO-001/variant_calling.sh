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

sample_name=$1;shift
BAM_FILE=$1;

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/SNPs_using_varscan2
REF=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MICO-001/analysis/genome/genome.fa
mkdir -p ${OUTDIR}

#base quality > 30 mapping quality > 20
#samtools mpileup -B -f ${REF} ${BAM_FILE} > ${OUTDIR}/${sample_name}.pileup

java -jar $EBROOTVARSCAN/VarScan.v2.4.2.jar mpileup2snp ${OUTDIR}/${sample_name}.pileup \
            --min-coverage 10 \
            --min-avg-qual 30 \
            --min-var-freq 0.01 \
            --variants SNP \
            --p-value 0.05 \
            --output-vcf 1 > ${OUTDIR}/${sample_name}_snps_AF0.01_pval0.05_readDepth10.vcf
            

java -jar $EBROOTVARSCAN/VarScan.v2.4.2.jar mpileup2snp ${OUTDIR}/${sample_name}.pileup \
            --min-coverage 30 \
            --min-avg-qual 30 \
            --min-var-freq 0.005 \
            --variants SNP \
            --p-value 0.01 \
            --output-vcf 1 > ${OUTDIR}/${sample_name}_snps_AF0.005_pval0.01_readDepth30.vcf


java -jar $EBROOTVARSCAN/VarScan.v2.4.2.jar mpileup2snp ${OUTDIR}/${sample_name}.pileup \
            --min-coverage 30 \
            --min-avg-qual 30 \
            --min-var-freq 0.001 \
            --variants SNP \
            --p-value 0.01 \
            --output-vcf 1 > ${OUTDIR}/${sample_name}_snps_AF0.001_pval0.01_readDepth30.vcf
            

java -jar $EBROOTVARSCAN/VarScan.v2.4.2.jar mpileup2snp ${OUTDIR}/${sample_name}.pileup \
            --min-coverage 30 \
            --min-avg-qual 30 \
            --min-var-freq 0.0005 \
            --variants SNP \
            --p-value 0.05 \
            --output-vcf 1 > ${OUTDIR}/${sample_name}_snps_AF0.0005_pval0.01_readDepth30.vcf
          
