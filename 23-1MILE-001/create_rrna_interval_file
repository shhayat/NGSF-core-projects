
#Create conda enviornments for the following tools
#/globalhome/hxo752/HPC/anaconda3/condabin/conda create -n gtfToGenePred -c bioconda ucsc-gtftogenepred
#/globalhome/hxo752/HPC/anaconda3/condabin/conda create -n genepredtobed -c bioconda ucsc-genepredtobed


GTF=/datastore/NGSF001/analysis/references/iGenomes/Mouse/Mus_musculus/Ensembl/GRCm38/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis/rrna_intervals

mkdir -p {OUTDIR}

#grep rRNA from gtf file
grep 'rRNA' ${GTF} > ${OUTDIR}/rRNA_transcripts.gtf

#convert the GTF file to genePred format
/globalhome/hxo752/HPC/anaconda3/envs/gtfToGenePred/bin/gtfToGenePred ${OUTDIR}/rRNA_transcripts.gtf ${OUTDIR}/rRNA_transcripts.genePred

#create interval bed file
/globalhome/hxo752/HPC/anaconda3/envs/genepredtobed/bin/genePredToBed ${OUTDIR}/rRNA_transcripts.genePred ${OUTDIR}/rRNA_intervals.bed

#removing overlapping intervals
bedtools merge -i ${OUTDIR}/rRNA_intervals.bed > ${OUTDIR}/rRNA_intervals_merged.bed



