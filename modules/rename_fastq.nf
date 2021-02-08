process rename_fastq {
    publishDir "${params.output}/${name}/decision_files", mode: 'copy', pattern: "*_${name}_read_id.txt"
    label 'ubuntu'
    input:
        tuple val(name), path(read_until)
        tuple val(name), path(dir)
    output:
        tuple val(name), path("*.fastq")
    script:
        """
        ## in basecalled folder fast5/fastq_results
        while IFS=, read sample_name barcode_name; do 
            mv  ${dir}/"\$barcode_name" ${dir}/"\$sample_name"
            cat ${dir}/"\$sample_name"/*.fastq > $sample_name.fastq
            ## mv all_$sample_name.fastq "$sample_name"_Peons/ ;
        done < ${rename_csv}
        """
}

//maybe remove barcode*.fastq??