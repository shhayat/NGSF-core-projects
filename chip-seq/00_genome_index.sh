#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=genome_index
#SBATCH --ntasks=1
#BATCH --cpus-per-task=4
#SBATCH --time=02:00:00
#SBATCH --mem=40G
#SBATCH --output=/globalhome/hxo752/HPC/slurm_logs/%j.out
set -eux

cd /globalhome/hxo752/HPC/tools/bowtie2-2.4.5-linux-x86_64


./bowtie2-build $BT2_HOME/example/reference/lambda_virus.fa lambda_virus
