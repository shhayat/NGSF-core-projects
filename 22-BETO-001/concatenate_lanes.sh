#!/bin/bash
	

#SBATCH --job-name=combine_fastq
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=8G
#SBATCH --account=hpc_p_anderson
	

# goal is to pull data from datastore, and compile into a file on the compute node
# then send that file back to the working directory
	
	set -eux
	
  mkdir -p /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/Fastq 
	# Move all fastq files from the run onto the node
	FILES=/datastore/NGSF001/NB551711/221025_NB551711_0059_AHK53LBGXL/Alignment_1/20220607_033312/Fastq
	rsync -rvzP ${FILES}/* ${SLURM_TMPDIR}
	

	for i in $(seq -w 154 165)
	do
	    echo Combining library R22000${i}
	    # Cat all the original seq (each lane) files into a new file on the node
	    # This will also remove that stupid sample number
	    cat ${SLURM_TMPDIR}/R2200${i}_*_R1_* > ${SLURM_TMPDIR}/R2200${i}_R1.fastq.gz
	    cat ${SLURM_TMPDIR}/R2200${i}_*_R2_* > ${SLURM_TMPDIR}/R2200${i}_R2.fastq.gz
	done
  
rsync -rvzP ${SLURM_TMPDIR}/*_R1.fastq.gz /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/Fastq
rsync -rvzP ${SLURM_TMPDIR}/*_R2.fastq.gz /globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-BETO-001/Fastq
