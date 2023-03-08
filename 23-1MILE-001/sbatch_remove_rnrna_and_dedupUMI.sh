BAMDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001/star_alignment
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1MILE-001

for i in ${BAMDIR}/R23*
do
         path="${i%_L001*}";
        sample_name=${path##*/};
   bam=star_Aligned.sortedByCoord.out.bam
   sbatch 06_remove_rnrna_and_dedupUMI.sh "R2200${i}" ${bam}
done
