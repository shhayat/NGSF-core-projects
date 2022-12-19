DATA=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/tpm
SCRIPT_DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2


for i in $DATA/*_quant/*.sf
do
	path="${i%/quant*}";
	sample_name="${path##*/}"
  
        sbatch ${SCRIPT_DIR}/04_psi_calculation.sh "${sample_name}"
 sleep 0.5
done
