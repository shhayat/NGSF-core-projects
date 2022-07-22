DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/alignment"


samples_id="492444 492445 507859 507860"

sample=""
for samples_id in ${samples_id[*]}
do
    samples+="${DIR}/SRR${samples_id}/SRR${samples_id}.aligned_dedup.bam " 
done

sbatch 06_QC_deeptools.sh ${samples}

