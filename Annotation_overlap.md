# DMRs near annotations

```
#!/bin/bash
#SBATCH -p nbi-short # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=email # send-to address
#SBATCH --mem-per-cpu=32000
#SBATCH --cpus-per-task=1
#SBATCH --job-name=Overlap


source python-3.5.1

srun python ~/group-data/bin/scripts/inverse_overlap_finder.py -e 500 TAIR10_GFF3-gene_only.gff MinusDMR_IDmerge.gff 1 4 5 7 overlapgene-.txt

srun cat overlapgene-.txt | awk '{if (NF>10 && $1!="seqname") print $1"\t"$3"\tTapDMR-Gene\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"$9}' | uniq > overlapGenes-.gff
```

This script will produce a .gff of genes that are within 500bp of a DMR, as well as their overlaps and distance from the DMR.
This can be used on any annotation file you like: TEs, other DMRs, specific classes of genes. 

