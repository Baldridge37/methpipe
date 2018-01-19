# methpipe


In this fictional example I create .meth files for seedling CG methylation from w1.gff files then compare two groups in the DMR section
```
#!/bin/bash -e
#SBATCH -p nbi-long # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=EMAIL # send-to address
#SBATCH --mem-per-cpu=32000
#SBATCH --cpus-per-task=1
#SBATCH --job-name=DMR
#SBATCH --array=0-2

source methpipe-3.4.3

ARRAY=(CG CHG CHH)



srun cat A1.sorted.${ARRAY[$SLURM_ARRAY_TASK_ID]}.w1.gff | awk '{split($9,a,";"); split(a[1],b,"="); split(a[2],c,"="); print $1"\t"$4"\t"$7"\tCG\t"$6"\t"b[2]+c[2]}' >  A1_${ARRAY[$SLURM_ARRAY_TASK_ID]}.meth

#Do for all As and Bs

srun merge-methcounts -t A1_${ARRAY[$SLURM_ARRAY_TASK_ID]}.meth A2_${ARRAY[$SLURM_ARRAY_TASK_ID]}.meth A1_${ARRAY[$SLURM_ARRAY_TASK_ID]}.meth A2_${ARRAY[$SLURM_ARRAY_TASK_ID]}.meth  A3_${ARRAY[$SLURM_ARRAY_TASK_ID]}.meth  -o I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.proportion.txt

printf "base case
A1_${ARRAY[$SLURM_ARRAY_TASK_ID]} 1 1
A1_${ARRAY[$SLURM_ARRAY_TASK_ID]} 1 1
B1_${ARRAY[$SLURM_ARRAY_TASK_ID]} 1 0
B2_${ARRAY[$SLURM_ARRAY_TASK_ID]} 1 0
B3_${ARRAY[$SLURM_ARRAY_TASK_ID]} 1 0" > I_${ARRAY[$SLURM_ARRAY_TASK_ID]}_design.txt

srun radmeth regression -factor case I_${ARRAY[$SLURM_ARRAY_TASK_ID]}_design.txt I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.proportion.txt > I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.cpgs.bed

srun radmeth adjust -bins 1:200:1 I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.cpgs.bed > I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.adjusted.bed

srun radmeth merge -p 0.01 I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.adjusted.bed > I_${ARRAY[$SLURM_ARRAY_TASK_ID]}.dmrs.bed
```
