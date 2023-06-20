singularity exec -e -B `pwd` -B /path/to/ctat_genome_lib_build_dir \
        star-fusion-v$version.simg \
        STAR-Fusion \
        --left_fq reads_1.fq.gz \
        --right_fq reads_2.fq.gz \
        --genome_lib_dir /path/to/ctat_genome_lib_build_dir \
        -O StarFusionOut \
        --FusionInspector validate \
        --examine_coding_effect \
