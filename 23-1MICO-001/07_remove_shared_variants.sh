
D23000043=
D23000044=
bcftools isec -C \
              -c all \
              -O z \
              -w 1 \
              -o ${OUTDIR}/${CLONE_ID}_${SAMPLE_ID}_I.vcf.gz \
              ${INDUCED_SAMPLE_DIR}/${SAMPLE_ID}/${SAMPLE_ID}.vcf.gz \
              ${UNINDUCED_SAMPLE_DIR}/${CLONE_ID}_U_concat.vcf.gz

bcftools index -t ${OUTDIR}/${CLONE_ID}_${SAMPLE_ID}_I.vcf.gz
