for i in $(seq -w 86 89);
do
  sbatch 03_picard.sh SRR197542${i}
  sleep 0.3
done
