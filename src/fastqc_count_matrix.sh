#!/bin/bash

time_elapsed = 0

# working directory 

cd /Users/nischal/Downloads/Alzheimer/Alzheimer_mouse

# Running QC for fastaq

fastqc ../SRR19042193.fastq -o ./results/

# running trimmomatic to trim the poor reads

java -jar /Users/nischal/Downloads/Bioinformatics/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 ./results/SRR19042193.fastq ./results/SRR19042193_trimmed.fastq TRAILING:10 -phred33
echo "Trimmed Sucessfully"

# run alignment

/Users/nischal/Downloads/Bioinformatics/hisat2/hisat2 -q --rna-strandness R -x ../grcm38/genome -U ./data/SRR19042193_trimmed.fastq | samtools sort -o ./results/dSRR19042193_trimmed.bam
echo "HISAT2 finished running!"


# STEP 3: Run featureCounts - Quantification

# get gtf
# wget https://ftp.ensembl.org/pub/release-111/gtf/mus_musculus/Mus_musculus.GRCm39.111.gtf.gz
./subread-2.0.5-macOS-x86_64/bin/featureCounts -S 2 -a ../Mus_musculus.GRCm39.111.gtf -o .results/SRR19042193_featurecounts.txt ./results/dSRR19042193_trimmed.bam
echo "featureCounts finished running!"

cat .results/SRR19042193_featurecounts.txt | cut -f1,7  > gene_exp.txt
duration=$SECONDS
echo "$(($time_elapsed / 60)) minutes and $(($time_elapsed % 60)) seconds elapsed."
