DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/fastqc
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/multiqc
cd /globalhome/hxo752/HPC/tools
multiqc ${DIR}/*_fastqc.zip -o ${OUTDIR} -n fastqc

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/fastqc_trimmed
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/multiqc
cd /globalhome/hxo752/HPC/tools
multiqc ${DIR}/*_fastqc.zip -o ${OUTDIR} -n fastqc_trimmed

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/star_alignment
cd /globalhome/hxo752/HPC/tools
multiqc ${DIR}/*/Log.final.out -o ${OUTDIR} -n alignment

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1CHXI-001/analysis/rnaseqc
cd /globalhome/hxo752/HPC/tools
multiqc ${DIR}/*.metrics.tsv -o ${OUTDIR} -n rnaseqc
