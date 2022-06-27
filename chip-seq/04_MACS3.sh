


cd /globalhome/hxo752/HPC/.local/bin/

BAMDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/peakcall
sample_name=$1; shift
treatBAM=$1; shift
controlBAM=$1

macs3 callpeak  --treatment ${BAMDIR}/${sample_name}/${treatBAM} \
                --control ${BAMDIR}/${sample_name}/${controlBAM} \
                --format BAM \
                --gsize hs \
                --name ${sample_name} -B \
                --qvalue 0.01 \
                --outdir ${OUTDIR}/${sample_name}
