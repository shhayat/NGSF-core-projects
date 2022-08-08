

module purge
module load nextflow/22.04.3
module load singularity/3.9.2

CONFIG=$1;
nextflow run nf-core/methylseq -profile data,singularity

#sbatch run_nextflow_methylseq.sh data.config
