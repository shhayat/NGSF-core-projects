index=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/index/mm10_index
fq1=1;
fq2=2;
sample_name=
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm/tpm
NCPU=8

$salmon/salmon quant -i mm10_index \
             -l A \
             -1 ${fq1} \
             -2 ${fq2} \
             -p 8 \
             --validateMappings \
             -o $OUTDIR/${samp}_quant
