OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/multiqc"
DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis"
mkdir -p ${OUTDIR}

cd /globalhome/hxo752/HPC/tools/

#FASTQC
multiqc -d ${DIR}/fastqc/*_fastqc -o ${OUTDIR}/fastqc -n fastqc

#BOWTIE ALIGNMENT
multiqc -d ${DIR}/alignment/*/*bowtie2.log  -o ${OUTDIR}/bowtie2 -n bowtie2

#PICARD
multiqc -d ${DIR}/alignment/*/dedup_metrics.txt  -o ${OUTDIR}/picard -n picard



