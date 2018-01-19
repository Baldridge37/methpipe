# Convert bed file to GFF

Convert the .bed file to a .gff with an awk script

```
cat A.bed | awk '{print $1"\tmethpipe\t"$4"\t"$2"\t"$3"\t"$6"\t"."\t"."\t"$5}' > A.gff
```

## Seperate the hypo and hyper DMRs into seperate gffs

```
cat A.gff | awk '{if ($9 >0) print $0}' > A+.gff
cat A.gff | awk '{if ($9 <0) print $0}' > A-.gff
```

## Combine DMRs
Now we can combine the DMRs of different sequence contexts by using the overlap python script.
This finds overlapping annotations between .gff files and reports a text 

```
#!/bin/bash
#SBATCH -p nbi-medium # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=email # send-to address
#SBATCH --mem-per-cpu=32000
#SBATCH --cpus-per-task=1
#SBATCH --job-name=Overlap



source python-3.5.1
source bedtools-2.27.0

CG=Tap_Soma_DMR_CG-.gff CHG=Tap_Soma_DMR_CHG-.gff CHH=Tap_Soma_DMR_CHH-.gff

srun python ~/group-data/bin/scripts/inverse_overlap_finder.py -e 0 CG-.gff CHG-.gff 1 4 5 7 overlapa.txt
srun cat  overlapa.txt | awk '{if (NF>10 && $1!="seqname") print $1 "\t" $2"\t" $3"\t" $4"\t" $5"\t" $6 "\t"$10"\t" $11"\t" $9 }' | uniq > CG-CHG-.gff

srun python ~/group-data/bin/scripts/inverse_overlap_finder.py -e 0 CG-.gff CHH-.gff 1 4 5 7 overlapb.txt
srun cat  overlapb.txt | awk '{if (NF>10 && $1!="seqname") print $1 "\t" $2"\t" $3"\t" $4"\t" $5"\t" $6 "\t"$10"\t" $11"\t" $9 }' | uniq > CG-CHH-.gff

srun python ~/group-data/scripts/inverse_overlap_finder.py -e 0 CHG-.gff CG-.gff 1 4 5 7 overlapc.txt
srun cat  overlapc.txt | awk '{if (NF>10 && $1!="seqname") print $1 "\t" $2"\t" $3"\t" $4"\t" $5"\t" $6 "\t"$10"\t" $11"\t" $9 }' | uniq > CHG-CG-.gff

srun python ~/group-data/bin/scripts/inverse_overlap_finder.py -e 0 DMR_CHG-.gff CHH-.gff 1 4 5 7 overlapd.txt
srun cat  overlapd.txt | awk '{if (NF>10 && $1!="seqname") print $1 "\t" $2"\t" $3"\t" $4"\t" $5"\t" $6 "\t"$10"\t" $11"\t" $9 }' | uniq > CHG-CHH-.gff

srun python ~/group-data/bin/scripts/inverse_overlap_finder.py -e 0 CHH-.gff CG-.gff 1 4 5 7 overlape.txt
srun cat  overlape.txt | awk '{if (NF>10 && $1!="seqname") print $1 "\t" $2"\t" $3"\t" $4"\t" $5"\t" $6 "\t"$10"\t" $11"\t" $9 }' | uniq > CHH-CG-.gff

srun python ~/group-data/bin/scripts/inverse_overlap_finder.py -e 0 CHH-.gff CHG-.gff 1 4 5 7 overlapf.txt
srun cat  overlapf.txt | awk '{if (NF>10 && $1!="seqname") print $1 "\t" $2"\t" $3"\t" $4"\t" $5"\t" $6 "\t"$10"\t" $11"\t" $9 }' | uniq > CHH-CHG-.gff

srun cat CG-CHG-.gff CG-CHH-.gff CHG-CG-.gff CHG-CHH-.gff CHH-CG-.gff CHH-CHG-.gff > MinusDMR.gff

srun sort -k1,1 -k4,4n MinusDMR.gff > MinusDMR_sorted.gff

srun bedtools merge -i MinusDMR_sorted.gff > MinusDMR_merge.gff

srun cat MinusDMR_merge.gff | awk '{print $1"\tmethpipe\tHypoDMR\t"$2"\t"$3"\t1\t"$7"\t"$8"\tID="NR"" }' > MinusDMR_IDmerge.gff
```

This Script will give overlap and distance in the final .gff but this won't be useful right now.
We'll use it again finding overlaps of other annotations.
