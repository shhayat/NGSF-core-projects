

sample_name=$1;

trim_galore=/$HOME/venvs/trim-glore/TrimGalore-0.6.10
${trim_galore}/trim_galore \
                           --paired ${sample_name}_R1_read_trimmed.fq.gz ${sample_name}_R2_read_trimmed.fq.gz \
                           --cores ${NCPU} \
                           --nextera
