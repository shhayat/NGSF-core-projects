
module load python/3.7.7
#deeptools
cd /globalhome/hxo752/HPC/.local/lib/python3.7/site-packages/deeptools/

python plotFingerprint.py \
            --bamfiles ENCFF000PED.chr12.rmdup.filt.sort.bam  \
            ../../data/bam/hela/ENCFF000PEE.chr12.rmdup.sort.bam \
            ../../data/bam/hela/ENCFF000PET.chr12.rmdup.sort.bam \
             --extendReads 110  \
             --binSize=1000 \
             --plotFile HeLa.fingerprint.pdf \
             --labels HeLa_rep1 HeLa_rep2 HeLa_input -p 5 &> fingerprint.log
  
