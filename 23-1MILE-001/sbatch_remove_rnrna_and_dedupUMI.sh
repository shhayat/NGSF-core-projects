DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/analysis/fastq_trimmed
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001



for i in ${DATA}/R23*_L001_R1_001.fastq.gz
do
        path="${i%_L001*}";
        sample_name=${path##*/};
        bam='Aligned.sortedByCoord.out.bam'
        sbatch 06_remove_rnrna_and_dedupUMI.sh ${sample_name} ${bam}
done
