#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=denovo_motif_analysis
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=80G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

set -eux
$NCPU=2

DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1DEAN-001/analysis

java -Xms512M -XX:ParallelGCThreads=$NCPU /globalhome/hxo752/HPC/tools/chipmunk_v8_src.jar \
                                                                      -cp chipmunk.jar \
                                                                      ru.autosome.ChIPMunk \
                                                                      s:$DATA/common_peaks_sequences_with_2000bp_upstream_and_downstream.fa \
                                                                      1> $DATA/results.txt \
                                                                      2> $DATA/log.txt
