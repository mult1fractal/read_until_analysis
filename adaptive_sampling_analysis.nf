#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
* Nextflow -- 
* Author: kek
*/

/* 
Nextflow version check  
Format is this: XX.YY.ZZ  (e.g. 20.07.1)
change below
*/

XX = "20"
YY = "07"
ZZ = "1"

if ( nextflow.version.toString().tokenize('.')[0].toInteger() < XX.toInteger() ) {
println "\033[0;33mWtP requires at least Nextflow version " + XX + "." + YY + "." + ZZ + " -- You are using version $nextflow.version\u001B[0m"
exit 1
}
else if ( nextflow.version.toString().tokenize('.')[1].toInteger() < YY.toInteger() ) {
println "\033[0;33mWtP requires at least Nextflow version " + XX + "." + YY + "." + ZZ + " -- You are using version $nextflow.version\u001B[0m"
exit 1
}

if (params.help) { exit 0, helpMSG() }

println " "
println "\u001B[32mProfile: $workflow.profile\033[0m"
println " "
println "\033[2mCurrent User: $workflow.userName"
println "Nextflow-version: $nextflow.version"
println "This workflow intended for Nextflow-version: 20.01.0"
println "Starting time: $nextflow.timestamp"
println "Workdir location [--workdir]:"
println "  $workflow.workDir"
println "Output location [--output]:"
println "  $params.output"
println "\033[2mDatabase location [--databases]:"
println " "
println "\033[2mCPUs to use: $params.cores, maximal CPUs to use: $params.max_cores\033[0m"
println " "


/************* 
* INPUT HANDLING
*************/

//get basecalled dir
dir_input_ch = Channel
       .fromPath( params.dir, checkIfExists: true, type: 'dir')
       .map { file -> tuple(file.name, file) }

// get read_until.csv
read_until_ch = Channel
        .fromPath ( params.read_until, checkIfExists: true )
        .map { file -> tuple(file.baseName, file) }

/************* 
* MODULES
*************/

    include { get_decision } from './modules/get_decision'
    include { create_decision_fastq } from './modules/create_decision_fastq.nf'




/************* 
* SUB WORKFLOWS
*************/
// workflow rename_fastq_wf {
//     take:   fastq_dir
//             rename_csv
//     main:   rename_fastq(read_until) 
//     emit:   rename_fastq.out.view()
// }



workflow get_decision_wf {
    take:   read_until
    main:   get_decision(read_until)
    emit:   get_decision.out.flatten().map { file -> tuple(file.baseName, file) }.view()
}

workflow create_decision_fastq_wf {
    take:   fastq_dir
            decision_files
    main:   create_decision_fastq(fastq_dir, decision_files)
            //create_decision_fastq(fastq_dir, stop_receiving)
            //create_decision_fastq(fastq_dir, unblock) 
    emit:   create_decision_fastq.out.view()
}

workflow nanoplot_wf {
    take:   fastq
    main:   nanoplot(fastq)
    emit:   nanoplot.out
}

/************* 
* MAIN WORKFLOWS
*************/

workflow {

get_decision_wf(read_until_ch)
create_decision_fastq_wf(dir_input_ch, get_decision_wf.out )


//nanoplot_wf(get_decision_fastq.out)
}
/*************  
* --help
*************/
def helpMSG() {
    c_green = "\033[0;32m";
    c_reset = "\033[0m";
    c_yellow = "\033[0;33m";
    c_blue = "\033[0;34m";
    c_dim = "\033[2m";
    log.info """
    .


nextflow run adaptive_sampling_analysis.nf --dir /home/mike/bioinformatics/adaptive_sampling_checks/all_fast5_adaptive_sequencing_fast_basecalling/fastq_results/barcode01/ --read_until tests/read_until_aev350_4f8384f1.csv -profile local,docker -work-dir work


    """.stripIndent()
}

