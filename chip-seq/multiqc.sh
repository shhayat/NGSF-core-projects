${OUTDIR}="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/multiqc"
mkdir ${OUTDIR}

cd /globalhome/hxo752/HPC/tools/

#FASTQC
#./multiqc ${OUTDIR}/fastqc/*_fastqc.zip -o ${OUTDIR}/fastqc

#BOWTIE ALIGNMENT
./multiqc -d /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/alignment/*/*bowtie2.log  -o ${OUTDIR}/bowtie2

#PICARD
./multiqc -d /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/alignment/*/*picard.log  -o ${OUTDIR}/picard
