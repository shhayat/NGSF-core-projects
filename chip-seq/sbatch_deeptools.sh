DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/alignment"


samples_id="492444 492445 507859 507860"

bam_files=""
for samples_id in ${samples_id[*]}
do
    bam_files+="${DIR}/SRR${samples_id}/SRR${samples_id}.aligned_dedup.bam " 
done

sbatch 05_QC_deeptools.sh ${bam_files}
