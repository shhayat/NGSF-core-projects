set -eux

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1ELSI-001
module load r/4.1.2

R CMD BATCH ${SCRIPT_DIR}/feature_count.R
