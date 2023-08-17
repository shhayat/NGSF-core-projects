#dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/lymphoma
dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/Fusion_events/hystiocystic_sarcoma
outdir=/globalhome/hxo752/HPC/ngsf_git_repos/NGSF-core-projects/23-1ARMA/fusion_genes/analysis
tumor_type="squamous_cell_carcinomas"

for i in ${dir}/*/FusionInspector-validate/finspector.FusionInspector.fusions.tsv
do
  tail -n +2 ${i} > ${outdir}/fusion_genes_tmp.txt
  (cat ${outdir}/fusion_genes_tmp.txt; echo '') >> ${outdir}/${tumor_type}_fusion_genes.txt
  rm ${outdir}/fusion_genes_tmp.txt
done
echo -e "FusionName\tJunctionReadCount\tSpanningFragCount\test_J\test_S\tLeftGene\tLeftLocalBreakpoint\tLeftBreakpoint\tRightGene\tRightLocalBreakpoint\tRightBreakpoint\tSpliceType\tLargeAnchorSupport\tJunctionReads\tSpanningFrags\tNumCounterFusionLeft\tCounterFusionLeftReads\tNumCounterFusionRight\tCounterFusionRightReads\tFAR_left\tFAR_right\tLeftBreakDinuc\tLeftBreakEntropy\tRightBreakDinuc\tRightBreakEntropy\tFFPM\tmicroh_brkpt_dist\tnum_microh_near_brkpt"  > ${outdir}/file2 && cat ${outdir}/file2 ${outdir}/${tumor_type}_fusion_genes.txt >> ${outdir}/${tumor_type}_fusion_genes_v2.txt
#echo -e "FusionName\tJunctionReadCount\tSpanningFragCount\test_J\test_S\tSpliceType\tLeftGene\tLeftBreakpoint\tRightGene\tRightBreakpointJunctionReads\tSpanningFrags\tLargeAnchorSupport\tFFPM\tLeftBreakDinuc\tLeftBreakEntropy\tRightBreakDinuc\tRightBreakEntropy\tannots" > ${dir}/file2 && cat ${dir}/file2 ${dir}/${tumor_type}_fusion_genes.txt >> ${dir}/${tumor_type}_fusion_genes_v1.txt
mv ${outdir}/${tumor_type}_fusion_genes_v2.txt ${outdir}/${tumor_type}_fusion_genes_validated.txt
rm ${outdir}/file2
rm ${outdir}/${tumor_type}_fusion_genes.txt
