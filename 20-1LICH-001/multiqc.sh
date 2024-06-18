OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/multiqc"
mkdir -p ${OUTDIR}

cd /globalhome/hxo752/HPC/tools/

DIR1="/datastore/NGSF001/projects/2020/20-1LICH-001/fastqc"
DIR2="/project/anderson"

multiqc -o ${OUTDIR} -n multiqc_report ${DIR1}/fastqc/*_fastqc \
                                       ${DIR2}/alignment/*/*bowtie2.log \
                                       ${DIR2}/alignment/*/*_dup_metrics.txt \
                                       ${DIR}/alignment/*/*.table
