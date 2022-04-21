#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
===========================================================
 pipeline about economic model

 @authors
 Luca Cozzuto <lucacozzuto@gmail.com>
 Nicola Visonà <xxxx@gmail.com>
=========================================================== 
*/

/*
*/

params.help            = false
params.resume          = false


log.info """

╔═╗╔═╗╔═╗╔╗╔
║╣ ║  ║ ║║║║
╚═╝╚═╝╚═╝╝╚╝                                                                                       
====================================================
reads                       : ${params.reads}
output (output folder)      : ${params.output}
"""


if (params.help) {
    log.info 'This is the the econ pipeline'
    log.info '\n'
    exit 1
}
if (params.resume) exit 1, "Are you making the classical --resume typo? Be careful!!!! ;)"



// Setting the reference genome file and the annotation file (validation)
peakconfig = file(params.peakconfig)
if( !peakconfig.exists() ) exit 1, "Missing peak calling config: '$peakconfig'. Specify path with --peakconfig"



outputfolder    	= "${params.output}"



// Create channels for sequences data
Channel
    .fromFilePairs( params.reads, size: ( params.read_type == "SE") ? 1 : 2 )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
    .set { read_files}    

//read_files.view()

Channel
    .fromPath( params.reads )                                             
    .set { fastq_files}

// Create a channel for peak calling
Channel
    .from(peakconfig.readLines())
    .map { line ->
        list = line.split("\t")
            if (list.length <2) {
			  error "ERROR!!! Peak config file has to be tab separated\n" 
	        }        
	        if (list[0]!= "") {
	        	category = ""
	        	if (list.length == 3) {
					category = list[2]
				} 
				chip_sample_id = list[0]
				ctrl_sample_id = list[1]
			[ "${chip_sample_id}-${ctrl_sample_id}", chip_sample_id, ctrl_sample_id, category ]
        }  
    }
    .set{ peakcall_params}

// Create a channel for peak calling
def progPars = [:]
allLines  = pars_tools.readLines()
for( line : allLines ) {
    list = line.split("\t")
    if (list.length <2) {
		 error "ERROR!!! Config file has to be tab separated\n" 
	}
    if (!(list[0] =~ /#/ )) {
		progPars[list[0]] = ["chip": list[1].replace("\"", ""), "rip": list[2].replace("\"", "")]
    }  
}
 
include { convertEpicTo6Bed; convertTo6Bed as convertMACSTo6Bed; convertTo6Bed as convertMOAIMSTo6Bed; convertTo6Bed as convertExomeTo6Bed} from "${baseDir}/local_modules"









workflow {
	FASTQC(fastq_files)

}

workflow.onComplete {
    println "Pipeline completed!"
    println "Started at  $workflow.start" 
    println "Finished at $workflow.complete"
    println "Time elapsed: $workflow.duration"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
