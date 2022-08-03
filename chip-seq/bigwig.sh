#generate bigwig files to view in IGV
#normalize the ChIP against the input
bamCompare -b1 bowtie2/H1hesc_Pou5f1_Rep1_aln.bam \
            -b2 bowtie2/H1hesc_Input_Rep1_chr12_aln.bam \
            -o visualization/bigWig/H1hesc_Pou5f1_Rep1_bgNorm.bw \
            --binSize 20 \
            --normalizeUsing BPM \
            --smoothLength 60 \
            --extendReads 150 \
            --centerReads \
            -p ${NCPUS} 2> ../logs/Pou5f1_rep1_bamCompare.log
         

