
module load r/4.1.2
OUTDIR=
cd /globalhome/hxo752/HPC/tools/phantompeakqualtools

Rscript run_spp.R -c -i -savp -odir -out=xcor_metrics_hela.txt
