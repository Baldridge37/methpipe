# methpipe


In this fictional example I create .meth files for seedling CG methylation from w1.gff files then compare two groups in the DMR section
```
#!/bin/bash -e
#SBATCH -p nbi-long # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=billy.aldridge@jic.ac.uk # send-to address
#SBATCH --mem-per-cpu=32000
#SBATCH --cpus-per-task=1
#SBATCH --job-name=DMR

source methpipe-3.4.3



srun cat Seedling.sorted.CG.w1.gff | awk '{split($9,a,";"); split(a[1],b,"="); split(a[2],c,"="); print $1"\t"$4"\t"$7"\tCG\t"$6"\t"b[2]+c[2]}' > Seedling_CG.meth

#srun cat Seedling.CHG.w1.gff | awk '{split($9,a,";"); split(a[1],b,"="); split(a[2],c,"="); print $1"\t"$4"\t"$7"\tCG\t"$6"\t"b[2]+c[2]}' > Seedling_CHG.meth

#srun cat Seedling.CHH.w1.gff | awk '{split($9,a,";"); split(a[1],b,"="); split(a[2],c,"="); print $1"\t"$4"\t"$7"\tCG\t"$6"\t"b[2]+c[2]}' > Seedling_CHH.meth


srun merge-methcounts -t Seedling_CG.meth file.meth file.meth  file.meth  file.meth file.meth  file.meth  -o A_vs_B.proportion.txt


printf "base case
Seedling_CG 1 0
file_CG 1 0
file_CG 1 0
file_CG 1 0
file_CG 1 1
file_CG 1 1
file_CG 1 1" > A_vs_B_design.txt

srun radmeth regression -factor case A_vs_B_design.txt A_vs_B_CG.proportion.txt > A_vs_B_CG.cpgs.bed

srun radmeth adjust -bins 1:200:1 A_vs_B_CG.cpgs.bed > A_vs_B_CG.adjusted.bed

srun radmeth merge -p 0.01 A_vs_B_CG.adjusted.bed > A_vs_B_CG.dmrs.bed
```
