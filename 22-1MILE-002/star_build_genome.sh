
star=/datastore/NGSF001/software/tools/STAR-2.7.4a/bin/Linux_x86_64



${star}/STAR --runMode genomeGenerate 
     --runThreadN 8 
     --genomeDir star-index 
     --genomeFastaFiles /datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.fa --sjdbGTFfile /datastore/NGSF001/analysis/references/rat/Rnor_6.0/ncbi-genomes-2020-10-30/GCF_000001895.5_Rnor_6.0/GCF_000001895.5_Rnor_6.0_genomic.gtf 
     --sjdbOverhang 99

