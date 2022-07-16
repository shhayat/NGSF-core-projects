#treatBAM=${SRR19754288, SRR19754289}
#controlBAM=${SRR19754286, SRR19754287}
while read control treat sample_name; 
do
    sbatch "$control  $treat  $sample_name"
    sleep 0.3
done < 'samples.txt'
