#treatBAM=${SRR19754288, SRR19754289}
#controlBAM=${SRR19754286, SRR19754287}

filename='samples.txt'
#echo Start
#while read p; do 
for i in $filename
do
    echo "$i[1]"
    sleep 0.2
done
