DIR="/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/alignment"


#samples_id="492444 492445 507859 507860"

#bam_files=""
#for samples_id in ${samples_id[*]}
#do
#    bam_files+="${DIR}/SRR${samples_id}/SRR${samples_id}.aligned_dedup.bam " 
#done
#sbatch 05_QC_deeptools.sh "${bam_files}"

bam_files=""
for sample in $DIR/SRR*/*.aligned_dedup.bam
do  
    bam_files+="${sample}"
    bam_files=$(echo "$bam_files" | sed 's/.bam\//.bam \//g')
    #bam_files="${bam_files#"${bam_files%%[![:space:]]*}"}"
 done
 
 sbatch 05_QC_deeptools.sh "${bam_files} \"
