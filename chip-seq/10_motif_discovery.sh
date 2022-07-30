

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/

mkdir -p ${DIR}/motif_discovery

bed_peak=$1; shift
sample_name=1;

#bedtools getfasta -fo CTCF_top500_peak_seq.fa -fi hg38.masked.fa -bed ENCFF693MY_top500.bed

#dreme -p CTCF_top500_peak_seq.fa -oc dreme_out


#select peaks with the strongest signal for motif finding
#sort -k 7,7nr  ${DIR}/${bed_peak} | head -n 200 > ${DIR}/motif_discovery/${sample_name}_top.bed
