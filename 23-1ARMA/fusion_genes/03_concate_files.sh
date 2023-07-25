dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/urothelial_carcinoma
tumor_type="urothelial_carcinoma"

for i in ${dir}/*/star-fusion.fusion_predictions.tsv
do
  tail -n +2 ${i} > ${dir}/fusion_genes_tmp.txt
  cat ${dir}/fusion_genes_tmp.txt >> ${dir}/${tumor_type}_fusion_genes.txt
  rm ${dir}/fusion_genes_tmp.txt
done
echo -e "FusionName\tJunctionReadCount\tSpanningFragCount\test_J\test_S\tSpliceType\tLeftGene\tLeftBreakpoint\tRightGene\tRightBreakpointJunctionReads\tSpanningFrags\tLargeAnchorSupport\tFFPM\tLeftBreakDinuc\tLeftBreakEntropy\tRightBreakDinuc\tRightBreakEntropy\tannots" > file2 && cat file2 ${dir}/${tumor_type}_fusion_genes.txt >> ${dir}/${tumor_type}_fusion_genes.txt
