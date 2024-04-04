
java -Xms512M -Xmx1G /globalhome/hxo752/HPC/tools/chipmunk_v8_src.jar -cp chipmunk.jar \
                                                                      ru.autosome.ChIPMunk \
                                                                      s:common_peaks_sequences_with_2000bp_upstream_and_downstream.fa \
                                                                      1>results.txt \
                                                                      2>log.txt
