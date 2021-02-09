process create_decision_fastq {
    publishDir "${params.output}/fastqs_separated", mode: 'copy', pattern: "*.fastq"
    label 'template'
    input:
        tuple val(name), path(dir)
        tuple val(name), path(no_decision), path(stop_receiving), path(unblock)
    output:
        tuple val(name), file("*.fastq")
    script:
        """
        cat ${dir}/*.fastq | python fastq_extract_parser.py ${no_decision} > decision.fastq
        cat ${dir}/*.fastq | python fastq_extract_parser.py ${stop_receiving} > stop_receiving.fastq
        cat ${dir}/*.fastq | python fastq_extract_parser.py ${unblock} > unblock.fastq
        """
}
// https://bioinformatics.cvr.ac.uk/essential-awk-commands-for-next-generation-sequence-analysis/


// //awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$3=d; print}' tmp1_"$i" > genus_only_"$i"
//         for i in *.txt ; do
//             ## decision=\$(echo "$i" | awk -v easyname="${name}" -F"_read_until.txt" '{print $1}')