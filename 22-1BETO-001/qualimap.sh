qualimap=/datastore/NGSF001/software/tools/qualimap_v2.2.1
gtf=/datastore/NGSF001/analysis/references/iGenomes/Dog/Canis_familiaris/Ensembl/CanFam3.1/Annotation/Genes/genes.gtf
OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1BETO-001/analysis/qualimap

${qualimap}/qualimap rnaseq \
    -outdir $OUTDIR \
    -a proportional \
    -bam /datastore/NGSF001/projects/22-1BETO-001/analysis/star_alignment/R22000154/Aligned.sortedByCoord.out.bam \
    -p strand-specific-reverse \
    -gtf $gtf \
    --java-mem-size=8G
