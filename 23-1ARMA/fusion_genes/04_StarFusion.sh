

output_dir=
CanineStarFusionBuild=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/hystiocystic_sarcoma/analysis/ctat_genome_lib_build_dir

mkdir -p ${output_dir}
STAR-Fusion --left_fq ../Rawfastq/fname.R1 \
            --right_fq ../Rawfastq/fname.R2 \
            --genome_lib_dir CanineStarFusionBuild \
            --output_dir ${output_dir}/fname.code.fusion

