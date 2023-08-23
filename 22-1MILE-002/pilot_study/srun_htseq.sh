SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-002/pilot_study
DATA=/datastore/NGSF001/projects/2022/22-1MILE-002/deduplication
for i in ${DATA}/R2*.no-rRNA.primary-aln.dedup.bam
do
     path="${i%/deduplication/}";
     sample_name=$(echo "$path" | grep -o 'R[0-9]\+')
     sbatch ${SCRIPT_DIR}/htseq.sh "${sample_name}", "${DATA}/${sample_name}.no-rRNA.primary-aln.dedup.bam"
     sleep 0.5
done 
