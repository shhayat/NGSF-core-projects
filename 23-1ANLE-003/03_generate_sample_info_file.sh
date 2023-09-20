DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis/count_files

#generate sample info file per comparision
for i in {05..06};
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_1.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_1.csv


for i in {06..07};
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_2.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_2.csv


for i in {06..08};
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_3.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_3.csv
