
DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastqc
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/multiqc
cd /globalhome/hxo752/HPC/tools
multiqc ${DIR}/*_fastqc.zip -o ${OUTDIR} -n fastqc

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/fastqc_trimmed
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1LICH-001/analysis/multiqc
cd /globalhome/hxo752/HPC/tools
multiqc ${DIR}/*.trimmed_fastqc.zip -o ${OUTDIR} -n fastqc_after_trimming
