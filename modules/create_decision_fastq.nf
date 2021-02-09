process create_decision_fastq {
    publishDir "${params.output}/fastqs_separated", mode: 'copy', pattern: "*.fastq"
    label 'seqkit'
    input:
        tuple val(name), path(dir)
        tuple val(a), path(no_decision), path(stop_receiving), path(unblock)

    output:
        tuple val(name), file("*.fastq")
    script:
        """
        seqkit grep --pattern-file ${no_decision} ${dir}/*.fastq >> ${a}.fastq
        seqkit grep --pattern-file ${stop_receiving} ${dir}/*.fastq >> ${a}.fastq
        seqkit grep --pattern-file ${unblock} ${dir}/*.fastq >> ${a}.fastq
        ##cat ${dir}/*.fastq | python fastq_extract_parser.py ${decisionfile} > ${a}.fastq
        """
}
// https://bioinformatics.cvr.ac.uk/essential-awk-commands-for-next-generation-sequence-analysis/


// //awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$3=d; print}' tmp1_"$i" > genus_only_"$i"
//         for i in *.txt ; do
//             ## decision=\$(echo "$i" | awk -v easyname="${name}" -F"_read_until.txt" '{print $1}')