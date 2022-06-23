


cd /globalhome/hxo752/HPC/.local/bin/

BAMDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/alignment
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/peakcall
sample_name=$1; shift


mkdir ${OUTDIR}/${sample_name}

macs3 callpeak -t ${BAMDIR}/${sample_name}/ChIP.bam -c ${BAMDIR}/${sample_name}/Control.bam -f BAM -g hs -n ${sample_name} -B -q 0.01 --outdir ${OUTDIR}/${sample_name}
