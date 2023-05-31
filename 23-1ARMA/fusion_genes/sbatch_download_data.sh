
for i in {4369..4389}
do
  j="${i:2}"
  sbatch download_data.sh "0${j}" "SRR1762${i}"
done
