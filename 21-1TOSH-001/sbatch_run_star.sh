DATA=/datastore/NGSF001/projects/21-1TOSH-001/new_analysis/Trimming
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/21-1TOSH-001

#for i in $(seq -w 42 52);
for i in 42
do
        fq1="${DATA}/R23000${i}/R23000${i}_R1_trimmed.fastq.gz";  
	fq2="${DATA}/R23000${i}/R23000${i}_R2_trimmed.fastq.gz";  
  
      sbatch ${SCRIPT_DIR}/01_star_mapping.sh R23000${i} ${fq1} ${fq2}
 sleep 0.5
done
