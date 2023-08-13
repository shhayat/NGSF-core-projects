#dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/lymphoma
#dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/Fusion_events/squamous_cell_carcinomas/analysis

tumor_type="squamous_cell_carcinomas"

for i in ${dir}/*/star-fusion.fusion_predictions.tsv
do
  tail -n +2 ${i} > ${dir}/fusion_genes_tmp.txt
  (cat ${dir}/fusion_genes_tmp.txt; echo '') >> ${dir}/${tumor_type}_fusion_genes.txt
  rm ${dir}/fusion_genes_tmp.txt
done
echo -e "FusionName\tJunctionReadCount\tSpanningFragCount\test_J\test_S\tSpliceType\tLeftGene\tLeftBreakpoint\tRightGene\tRightBreakpointJunctionReads\tSpanningFrags\tLargeAnchorSupport\tFFPM\tLeftBreakDinuc\tLeftBreakEntropy\tRightBreakDinuc\tRightBreakEntropy\tannots" > ${dir}/file2 && cat ${dir}/file2 ${dir}/${tumor_type}_fusion_genes.txt >> ${dir}/${tumor_type}_fusion_genes_v1.txt
mv ${dir}/${tumor_type}_fusion_genes_v1.txt ${dir}/${tumor_type}_fusion_genes.txt
rm ${dir}/file2
