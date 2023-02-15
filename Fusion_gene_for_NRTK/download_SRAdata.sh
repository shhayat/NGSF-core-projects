#Normal Skin Tissue
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Fusion_gene_for_NRTK/Normal_Skin
mkdir $OUTPUT
for i in SRR8474298 SRR8474287 SRR8474236 SRR8474246 SRR8474266
do
  prefetch $i -O $;
  fasterq-dump $i;
done

#Fibrosarcoma 
OUTPUT=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/Fusion_gene_for_NRTK/Fibrosarcoma
mkdir $OUTPUT
for i in SRR20327014 SRR20327015 SRR20327016 SRR20327011 SRR20327012 SRR20327013 SRR20327035 SRR20327036 SRR20327037 SRR20327006	
do
  prefetch $i;
  fasterq-dump $i;
done
