OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/multiqc"
#DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis"
DIR="/project/anderson"
mkdir -p ${OUTDIR}

cd /globalhome/hxo752/HPC/tools/

#FASTQC
DIR="/datastore/NGSF001/projects/2020/20-1LICH-001/fastqc"
multiqc -d ${DIR}/fastqc/*_fastqc -o ${OUTDIR}/fastqc -n fastqc

#BOWTIE ALIGNMENT
multiqc -d ${DIR}/alignment/*/*bowtie2.log  -o ${OUTDIR}/bowtie2 -n bowtie2

#PICARD
multiqc -d ${DIR}/alignment/*/*_dup_metrics.txt  -o ${OUTDIR}/picard -n picard



