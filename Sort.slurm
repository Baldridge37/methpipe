#sorting

#Make sure w1 files are sorted before continuing

```
#!/bin/bash -e
#SBATCH -p nbi-long # partition (queue)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=billy.aldridge@jic.ac.uk # send-to address
#SBATCH --mem-per-cpu=32000
#SBATCH --array=0-6
#SBATCH --cpus-per-task=1
#SBATCH --job-name=sort


ARRAY=()

srun sort ${ARRAY[$SLURM_ARRAY_TASK_ID]}.CG.w1.gff -k1,1 -k4,4n -o ${ARRAY[$SLURM_ARRAY_TASK_ID]}.sorted.CG.w1.gff
srun sort ${ARRAY[$SLURM_ARRAY_TASK_ID]}.CHG.w1.gff -k1,1 -k4,4n -o ${ARRAY[$SLURM_ARRAY_TASK_ID]}.sorted.CHG.w1.gff
srun sort ${ARRAY[$SLURM_ARRAY_TASK_ID]}.CHH.w1.gff -k1,1 -k4,4n -o ${ARRAY[$SLURM_ARRAY_TASK_ID]}.sorted.CHH.w1.gff
```
##Notes

use sed to make sure Chr labels in gff files are identical

```
cat file.gff | sed 's/CHR/Chr/g' > newfile.gff
```
I made sure all Chr labels had only one capital letter
