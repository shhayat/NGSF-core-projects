OUTDIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis/multiqc"
DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis"
mkdir -p ${OUTDIR}

cd /globalhome/hxo752/HPC/tools/

#FASTQC
multiqc -d ${DIR}/fastqc/*_fastqc -o ${OUTDIR}/fastqc -n fastqc

#BOWTIE ALIGNMENT
multiqc -d ${DIR}/alignment/*/*bowtie2.log  -o ${OUTDIR}/bowtie2 -n bowtie2

#phantompeakqualtools
mkdir ${OUTDIR}/phantompeakqual_after_alignment
multiqc -d ${DIR}/QC/phantompeakqualtools/xcor_*.pdf  -o ${OUTDIR}/phantompeakqual_QC -n phantompeakqual_xcor
multiqc -d ${DIR}/QC/phantompeakqualtools/xcor_*.txt -o ${OUTDIR}/phantompeakqual_QC -n phantompeakqual_metrics

#PICARD
multiqc -d ${DIR}/alignment/*/dedup_metrics.txt  -o ${OUTDIR}/picard -n picard


$MACS3
multiqc -d ${DIR}/peakcall_with_pval0.05/*/*_peaks.xls -o ${OUTDIR}/MACS3_statistics -n MACS3
#./multiqc -d ${DIR}/peakcall/*/*peaks.narrowPeak -o ${OUTDIR}/MACS3 -n MACS3_narrowPeak
#./multiqc -d ${DIR}/peakcall/*/*summits.bed -o ${OUTDIR}/MACS3 -n MACS3_bed
