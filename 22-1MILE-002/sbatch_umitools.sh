DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002/alignemnt

for i in 098 099 100 101 102 103
do
   bam=${DIR}/R2200${i}/star_Aligned.sortedByCoord.out.bam
   sbatch 02_umitools_UMIdedup.sh "R2200${i}" ${bam}
done
