
#!/bin/bash

#SBATCH --account=hpc_p_anderson
#SBATCH --constraint=skylake
#SBATCH --job-name=QC-deeptools
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --mem=20G
#SBATCH  --output=/globalhome/hxo752/HPC/slurm_logs/%j.out

module load python/3.7.7
#deeptools
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/

NCPUS=2
OUTDIR=
bam_files=1;

mkdir ${OUTDIR}/deeptools
python plotFingerprint.py \
            --bamfiles ${bam_files} \
            --extendReads 110  \
            --binSize=1000 \
            --plotFile fingerprint.pdf \
            --labels HeLa_rep1 HeLa_rep1 input_rep1 input_rep2 \
            -p ${NCPUS} &> fingerprint.log
  
