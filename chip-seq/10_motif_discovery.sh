

DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/chip-seq/analysis/

mkdir -p ${OUTDIR}/motif_discovery

bed_peak=$1; shift
sample_name=1;

#select peaks with the strongest signal for motif finding
sort -k 7,7nr  ${DIR}/${bed_peak}| head -n 200 > ${OUTDIR}/motif_discovery/ENCFF693MY_top.bed
