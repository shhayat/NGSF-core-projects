#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=variant_call
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --time=480:00:00
#SBATCH --mem=100G
#SBATCH --output=/project/anderson/%j.out


#source /globalhome/hxo752/HPC/.bashrc

#mtbseq=/globalhome/hxo752/HPC/miniconda/bin
DATA=/project/anderson/trimmed_fastq/BAM
cd ${DATA}

module load apptainer
#apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
#            ${mtbseq}/MTBseq --step TBfull \
#                 --threads ${NCPU}
apptainer exec -B $TMPDIR:/tmp /opt/software/singularity-images/MTBseq.sif \
           ${mtbseq}/MTBseq --step TBrefine \
                            --step TBpile \
                            --step TBlist \
                            --step TBvariants \
                            --step TBstats \
                            --step TBstrains \
                            --step TBjoin \
                            --step TBamend \
                            --step TBgroups \
                            --threads ${NCPU}
                  
#mv GATK_Bam/ ${OUTDIR}
#mv Mpileup/ ${OUTDIR}
#mv Position_Tables/ ${OUTDIR}
#mv Statistics/ ${OUTDIR}
#mv Joint/ ${OUTDIR}
#mv Amend/ ${OUTDIR}
#mv Classification/ ${OUTDIR}
#mv Groups/ ${OUTDIR}
#mv Bam/ ${OUTDIR}


