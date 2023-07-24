dir=/datastore/NGSF001/projects/ARMA_NTRK_Fusion/lymphoma
tumor_type="lymphoma"

mkdir -p ${dir}/NTRK_fusions

for i in ${dir}/*/star-fusion.fusion_predictions.tsv
do
  tail -n +2 ${i} > ${dir}/fusion_genes_tmp.txt
  cat ${dir}/fusion_genes_mod.txt >> ${dir}_fusion_genes.txt
  sed  -i '1i #FusionName	JunctionReadCount	SpanningFragCount	est_J	est_S	SpliceType	LeftGene	LeftBreakpoint	RightGene	RightBreakpointJunctionReads	SpanningFrags	LargeAnchorSupport	FFPM	LeftBreakDinuc	LeftBreakEntropy	RightBreakDinuc	RightBreakEntropy	annots' ${dir}_fusion_genes.txt
  rm ${dir}/fusion_genes_tmp.txt
done

