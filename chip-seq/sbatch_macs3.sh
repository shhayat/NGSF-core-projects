#treatBAM=${SRR19754288, SRR19754289}
#controlBAM=${SRR19754286, SRR19754287}

<<<<<<< HEAD

while read control treat sample_name; 
do
    sbatch "$control  $treat  $sample_name"
    sleep 0.3
done < 'samples.txt'



=======
filename='samples.txt'
#echo Start
#while read p; do 
for i in $filename
do
    echo "$i[1]"
    sleep 0.2
done
>>>>>>> 0fb66e3 (	modified:   sbatch_macs3.sh)
