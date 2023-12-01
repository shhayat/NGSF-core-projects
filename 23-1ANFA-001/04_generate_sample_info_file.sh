DIR=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ANLE-003/analysis/count_files

#generate sample info file per comparision
#for i in 15 17 16 18
#do
      echo "SC2300015,${DIR}/SC2300015/molecule_info.h5,loopC" >> ${DIR}/sample_info_1.csv
      echo "SC2300017,${DIR}/SC2300017/molecule_info.h5,loopC" >> ${DIR}/sample_info_1.csv
      echo "SC2300016,${DIR}/SC2300016/molecule_info.h5,loopM" >> ${DIR}/sample_info_1.csv
      echo "SC2300018,${DIR}/SC2300018/molecule_info.h5,loopM" >> ${DIR}/sample_info_1.csv
#done
#add header to csv file
sed -i 1i'sample_id,molecule_h5,experiment' ${DIR}/sample_info_1.csv


for i in 15 16
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_2.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_2.csv


for i in 17 18
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_3.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_3.csv

for i in 17 11
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_4.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_4.csv

for i in 15 13
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5" >> ${DIR}/sample_info_5.csv
done
#add header to csv file
sed -i 1i'sample_id,molecule_h5' ${DIR}/sample_info_5.csv

#for i in 15 17 09 11 13
#do
      echo "SC2300015,${DIR}/SC2300015/molecule_info.h5,loopC" >> ${DIR}/sample_info_6.csv
      echo "SC2300017,${DIR}/SC2300017/molecule_info.h5,loopC" >> ${DIR}/sample_info_6.csv
      echo "SC2300009,${DIR}/SC2300009/molecule_info.h5,DPP1" >> ${DIR}/sample_info_6.csv
      echo "SC2300011,${DIR}/SC2300011/molecule_info.h5,DPP1" >> ${DIR}/sample_info_6.csv
      echo "SC2300013,${DIR}/SC2300013/molecule_info.h5,DPP1" >> ${DIR}/sample_info_6.csv

#done
#add header to csv file
sed -i 1i'sample_id,molecule_h5,experiment' ${DIR}/sample_info_6.csv

for i in 09 11 13 10 12 14
do
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5,DPP1" >> ${DIR}/sample_info_7.csv
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5DPP1" >> ${DIR}/sample_info_7.csv
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5,DPP1" >> ${DIR}/sample_info_7.csv
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5,CPP1" >> ${DIR}/sample_info_7.csv
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5,CPP1" >> ${DIR}/sample_info_7.csv
      echo "SC23000${i},${DIR}/SC23000${i}/molecule_info.h5,CPP1" >> ${DIR}/sample_info_7.csv

done
#add header to csv file
sed -i 1i'sample_id,molecule_h5,experiment' ${DIR}/sample_info_7.csv


