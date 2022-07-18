OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/multiqc"
DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/"
mkdir ${OUTDIR}

cd /globalhome/hxo752/HPC/tools/

#FASTQC
./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc -n fastqc

#BOWTIE ALIGNMENT
./multiqc -d ${DIR}/alignment/*/*bowtie2.log  -o ${OUTDIR}/bowtie2 -n bowtie2

#PICARD
./multiqc -d ${DIR}/alignment/*/dedup_metrics.txt  -o ${OUTDIR}/picard -n picard

$MACS2
./multiqc -d ${DIR}/peakcall/*/*_peaks.xls -o ${OUTDIR}/MACS3 -n MACS3
