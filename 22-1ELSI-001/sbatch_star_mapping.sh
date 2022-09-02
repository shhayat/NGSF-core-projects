DATA=/datastore/NGSF001/projects/22-1ELSI-001/analysis/fastq/fastq
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1ELSI-001

fq1=${DATA}/R22000153_S15_R1_001.fastq.gz;
fq2=${DATA}/R22000153_S15_R2_001.fastq.gz;

sbatch ${SCRIPT_DIR}/01_star_mapping.sh "R22000153" "${fq1}" "${fq2}"

