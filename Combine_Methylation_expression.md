# Combing FPKM and methylation data

```
cat WBAGenes_DMRmeth.txt | awk '{print "cat genesFPKMtracking.txt | grep "$7}' | sh | awk '{print $5"\t"$18}' > DMR_Gene_Tap_FPKM.txt
```
