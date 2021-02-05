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
println "WtP intended for Nextflow-version: 20.01.0"
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

// gets only full dir 
if (params.dir && params.read_until_file) { dir_input_ch = Channel
        .fromPath( params.dir, checkIfExists: true )
        .map 
        .view() }
else 
    :


/************* 
* MODULES
*************/

    include { name_of_modul } from './modules/modulname'




/************* 
* SUB WORKFLOWS
*************/

workflow fasta_validation_wf {
    take:   fasta
    main:   seqkit(input_suffix_check(fasta)) 
    emit:   seqkit.out
}

/************* 
* MAIN WORKFLOWS
*************/

workflow {

if (params.setup) { setup_wf() }


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
    ${c_yellow}Usage examples:${c_reset}
    nextflow run replikation/What_the_Phage --fasta '*/*.fasta' --cores 20 --max_cores 40 \\
        --output results -profile local,docker 

    nextflow run phage.nf --fasta '*/*.fasta' --cores 20 \\
        --output results -profile lsf,singularity \\
        --cachedir /images/singularity_images \\
        --databases /databases/WtP_databases/ 


    """.stripIndent()
}

