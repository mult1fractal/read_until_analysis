process create_decision_fastq {
    publishDir "${params.output}/fastqs_separated", mode: 'copy', pattern: "*.fastq"
    label 'seqkit'
    input:
        tuple val(name), path(dir)
        tuple val(decision), path(decision_file)
    output:
        path("*.fastq")
    script:
        """
        for i in *read_id.txt ; do
            simple_name=\$(echo "\$i" | awk -F"_read_id.txt" '{print \$1}')
            seqkit grep --pattern-file \$i ${dir}/*.fastq >> \$simple_name.fastq
        done
        """
}
// https://bioinformatics.cvr.ac.uk/essential-awk-commands-for-next-generation-sequence-analysis/


// //awk -v d="$samplename" -F"," 'BEGIN { OFS = "," } {$3=d; print}' tmp1_"$i" > genus_only_"$i"
//         for i in *.txt ; do
//             ## decision=\$(echo "$i" | awk -v easyname="${name}" -F"_read_until.txt" '{print $1}')
//        tuple val(b), path(stop_receiving)
//        tuple val(c), path(unblock)
     //   seqkit grep --pattern-file ${no_decision} ${dir}/*.fastq >> ${a}.fastq
     //#   seqkit grep --pattern-file ${stop_receiving} ${dir}/*.fastq >> ${b}.fastq
     //#   seqkit grep --pattern-file ${unblock} ${dir}/*.fastq >> ${c}.fastq
     //#   ##cat ${dir}/*.fastq | python fastq_extract_parser.py ${decisionfile} > ${a}.fastq