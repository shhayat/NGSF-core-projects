#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=variant_call
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --time=480:00:00
#SBATCH --mem=100G
#SBATCH --output=/project/anderson/%j.out


#source /globalhome/hxo752/HPC/.bashrc
#
#mtbseq=/globalhome/hxo752/HPC/miniconda/bin
DATA=/project/anderson/trimmed_fastq/
cd ${DATA}

module load apptainer

#apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
#           	     MTBseq --step TBrefine \
#                            --threads ${SLURM_CPUS_PER_TASK}
			    
#apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \  
#	   MTBseq --step TBfull \
#                 --threads ${SLURM_CPUS_PER_TASK}
#

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBpile \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBlist \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBvariants \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBstats \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBstrains \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBjoin \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBamend \
                           --threads ${SLURM_CPUS_PER_TASK}
wait

apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
                    MTBseq --step TBgroups \
                           --threads ${SLURM_CPUS_PER_TASK}

#mv GATK_Bam/ ${OUTDIR}
#mv Mpileup/ ${OUTDIR}
#mv Position_Tables/ ${OUTDIR}
#mv Statistics/ ${OUTDIR}
#mv Joint/ ${OUTDIR}
#mv Amend/ ${OUTDIR}
#mv Classification/ ${OUTDIR}
#mv Groups/ ${OUTDIR}
#mv Bam/ ${OUTDIR}


