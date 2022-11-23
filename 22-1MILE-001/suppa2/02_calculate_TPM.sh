stringtie=/datastore/NGSF001/software/tools/stringtie
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/suppa2/suppa2_analysis/tpm

sample_name=1; shift
bam_file=1;

${stringtie}/stringtie ${bam_file} \
-G ${GTF} \
-o $OUTDIR/${sample_name}.gtf
