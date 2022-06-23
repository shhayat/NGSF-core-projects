


cd /globalhome/hxo752/HPC/.local/bin/

OUTDIR=
sample_name=

macs3 callpeak -t ChIP.bam -c Control.bam -f BAM -g hs -n ${sample_name} -B -q 0.01 --outdir OUTDIR
