OUTDIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/22-1MILE-001/analysis/peakcall


#treatBAM=${SRR19754288, SRR19754289}
#controlBAM=${SRR19754286, SRR19754287}

filename='samples.txt'
echo Start
while read p; do 
    echo "$p[1]"
done < "$filename"



for i in ${treatBAM}
