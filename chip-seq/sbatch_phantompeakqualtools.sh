for i in 492444 492445 507859 507860
do
  sbatch 03_QC.sh SRR${i}
  sleep 0.3
done
