#dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/
dir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/urothelial_carcinoma/analysis/
sample_name=$1;

mkdir -p ${dir}/NTRK_fusions

#grep "NTRK" ${dir}/starFusion/${sample_name}/FusionInspector-validate/finspector.FusionInspector.fusions.abridged.tsv > \
 #                                                                                                             ${dir}/NTRK_fusions/${sample_name}_NTRKfuisons.tsv
grep "NTRK" ${dir}/${sample_name}/FusionInspector-validate/finspector.FusionInspector.fusions.abridged.tsv > \
                                                                                                             ${dir}/NTRK_fusions/${sample_name}_NTRKfuisons.tsv
