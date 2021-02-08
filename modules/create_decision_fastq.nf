process get_decision {
    publishDir "${params.output}/${name}/fastqs_separated", mode: 'copy', pattern: "*_${name}_read_id.txt"
    label 'ubuntu'
    input:
        tuple val(name), path(dir)
        tuple val(name), path(decision_read_id)
    output:
        tuple val(name), file("*_.txt")
    script:
        """

        cat file.fastq | \ 
        for i in *.txt ; do
            ## decision=\$(echo "$i" | awk -v easyname="${name}" -F"_read_until.txt" '{print $1}')
            python fastq_extract_parser.py \$i > file_with_selected_ids.fastq

        """
}
// https://bioinformatics.cvr.ac.uk/essential-awk-commands-for-next-generation-sequence-analysis/


awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$3=d; print}' tmp1_"$i" > genus_only_"$i"