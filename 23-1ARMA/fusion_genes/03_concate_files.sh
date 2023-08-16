#dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/lymphoma
dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/Fusion_events/hystiocystic_sarcoma
outdir=
tumor_type="squamous_cell_carcinomas"

for i in ${dir}/*/FusionInspector-validate/finspector.FusionInspector.fusions.tsv
do
  tail -n +2 ${i} > ${dir}/fusion_genes_tmp.txt
  (cat ${dir}/fusion_genes_tmp.txt; echo '') >> ${dir}/${tumor_type}_fusion_genes.txt
  rm ${dir}/fusion_genes_tmp.txt
done
echo -e "FusionName\tJunctionReadCount\tSpanningFragCount\test_J\test_S\tLeftGene\tLeftLocalBreakpoint\tLeftBreakpoint\tRightGene\tRightLocalBreakpoint\tRightBreakpoint\tSpliceType\tLargeAnchorSupport\tJunctionReads\tSpanningFrags\tNumCounterFusionLeft\tCounterFusionLeftReads\tNumCounterFusionRight\tCounterFusionRightReads FAR_left\tFAR_right\tLeftBreakDinuc\tLeftBreakEntropy\tRightBreakDinuc RightBreakEntropy\tFFPM\tmicroh_brkpt_dist\tnum_microh_near_brkpt"  > ${dir}/file2 && cat ${dir}/file2 ${dir}/${tumor_type}_fusion_genes.txt >> ${dir}/${tumor_type}_fusion_genes_v2.txt
#echo -e "FusionName\tJunctionReadCount\tSpanningFragCount\test_J\test_S\tSpliceType\tLeftGene\tLeftBreakpoint\tRightGene\tRightBreakpointJunctionReads\tSpanningFrags\tLargeAnchorSupport\tFFPM\tLeftBreakDinuc\tLeftBreakEntropy\tRightBreakDinuc\tRightBreakEntropy\tannots" > ${dir}/file2 && cat ${dir}/file2 ${dir}/${tumor_type}_fusion_genes.txt >> ${dir}/${tumor_type}_fusion_genes_v1.txt
mv ${dir}/${tumor_type}_fusion_genes_v2.txt ${dir}/${tumor_type}_fusion_genes_validated.txt
rm ${dir}/file2
