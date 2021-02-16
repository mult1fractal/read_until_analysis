#!/usr/bin/bash



# classified reads human and bacteria stats etc..
for i in *filtered.csv; do
    sample_name=$(echo "$i" | awk -F"_pavian_report_filtered.csv" '{print $1}')
    #Genus_count
    Genuscount=$(grep -w "G" $i | wc -l)
    overall_reads_classified=$(grep -w "root" $i | cut -f2)
    human_classified=$(grep -w "G" $i | grep "Homo" | cut -f1)
    human_classified_reads=$(grep -w "G" $i | grep "Homo" | cut -f2)
    bacteria_classified=$(grep -w "D" $i | grep -w "Bacteria" | cut -f1)
    bacteria_classified_reads=$(grep -w "D" $i | grep -w "Bacteria" | cut -f2)
    printf "$sample_name,$Genuscount" >> genus_count.csv
done
sed -i '1s/.*/Sample_name,number of genus\n&/' Genus_count.csv


## Readcount per *.fastq
for x in *.fastq;
    simplename=$(basename $i )
    all_lines=$(cat $i* |wc -l)
    echo $simplename,"$(( $all_lines / 4 ))" >> readcount_xx.csv
done


## N50 per sample
for y in *read_until_*/readquality/*.txt ; do 
    sample_name_read=$(basename $y )
    N50=$(grep -w "N50" $y |tr -d " "| cut -d ":" -f2 |tr -d "," )
    read_count=$(grep -w "Number of reads" $y |tr -d " "| cut -d ":" -f2 | tr -d ",")
    echo "$sample_name_read,$N50,$read_count" 
    done
sed -i '1s/.*/Sample_name,number of genus\n&/' Genus_count.csv
     


