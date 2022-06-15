#SBATCH --job-name=intron_clustering
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mem=40G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out


DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//analysis/bam_to_junct
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects//analysis/intron_clustering

mkdir -p ${OUTDIR}



python ../clustering/leafcutter_cluster_regtools.py -j ${OUTDIR}/juncfiles.txt -m 50 -o testYRIvsEU -l 500000
