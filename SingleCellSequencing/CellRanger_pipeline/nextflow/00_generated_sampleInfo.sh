DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/SingleCellSequencing/analysis/count_files

#generate one csv file for all samples 
for i in $(seq -w 1 2);
do
      echo "R230000${i},${DIR}/R230000${i}/outs/molecule_info.h5" >> ${DIR}/sample_info.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info.csv
