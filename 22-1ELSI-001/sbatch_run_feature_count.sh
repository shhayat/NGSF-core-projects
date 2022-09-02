set -eux

SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1LICH-001
module load r/4.1.2

R CMD BATCH ${SCRIPT_DIR}/04_feature_count.R
