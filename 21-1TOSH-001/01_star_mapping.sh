DATA=/data/labs/bioinformatics_lab/raw_data/RNAseq/mazloum_nayef/UHRF1_knockout
GENOME=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001/indices
GTF=/data/share/references/igenome/Mouse/GRCm38.p6/gencode.vM18.annotation.gtf
OUTDATA=/data/labs/bioinformatics_lab/processed/RNASeq/mazloum_nayef/UHRF1_knockout/STAR_alignment
DIR=/data/labs/bioinformatics_lab/shared/RNASeq/mazloum_nayef/UHRF1_knockout
STAR=/data/home/shh2026/tools/STAR-2.6.0a/bin/Linux_x86_64_static/STAR
NCPUS=2

for i in $DATA/*R1_001.fastq.gz
do
        R1="${i%_R1*}";
        R2=${R1##*/};
        fq1=${R1}_R1_001.fastq.gz
	      fq2=${R1}_R2_001.fastq.gz
	      mkdir -p $OUTDATA/${R2}_star
        mkdir -p $OUTDATA/${R2}_star/tmp 

		echo "$STAR --genomeDir $GENOME --readFilesCommand zcat --readFilesIn $fq1 $fq2 --sjdbGTFfile $GTF --outSAMstrandField intronMotif --outFileNamePrefix $OUTDATA/${R2}_star/star_ --outSAMtype BAM SortedByCoordinate --outFilterIntronMotifs RemoveNoncanonical --runThreadN $NCPUS && samtools index $OUTDATA/${R2}_star/star_Aligned.sortedByCoord.out.bam" >> $DIR/run_star_mapping.sh 
done
