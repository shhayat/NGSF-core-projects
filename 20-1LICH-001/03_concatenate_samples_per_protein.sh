OUTDIR='/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/20-1LICH-001/analysis/concatenated_uninduced_samples'

mkdir -p ${OUTDIR}

CLONE_ID=$1;
UNINDUCED_1=$2;
UNINDUCED_2=$3

echo "${INPUT_DIR}/${UNINDUCED_1}/${UNINDUCED_1}.vcf.gz" >> ${OUTDIR}/${CLONE_ID}_uniduced_vcf.txt
echo "${INPUT_DIR}/${UNINDUCED_2}/${UNINDUCED_2}.vcf.gz" >> ${OUTDIR}/${CLONE_ID}_uniduced_vcf.txt

bcftools concat -a \
                -d all \
                -O z \
                -f ${OUTDIR}/${CLONE_ID}_uniduced_vcf.txt \
                -o ${OUTDIR}/${CLONE_ID}_uninduced_concat.vcf.gz 
                
bcftools index -t ${OUTDIR}/${CLONE_ID}_uninduced_concat.vcf.gz 
