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
batches                     : ${params.batches}
values                      : ${params.values}
template                    : ${params.template}
output (output folder)      : ${params.output}
"""


if (params.help) {
    log.info 'This is the the econ pipeline'
    log.info '\n'
    exit 1
}
if (params.resume) exit 1, "Are you making the classical --resume typo? Be careful!!!! ;)"


nlogo = file("${projectDir}/Industrial-Revolution.nlogo")
nlogo = file("${projectDir}/Industrial-Revolution.nlogo")
xmlfile = file(params.template)

if( !nlogo.exists() ) exit 1, "Missing Industrial-Revolution.nlogo file!"
if( !xmlfile.exists() ) exit 1, "Missing template xml file!"

// Setting the reference genome file and the annotation file (validation)
values = file(params.values)
if( !values.exists() ) exit 1, "Missing values file: '${params.values}'. Specify the path with --values parameter"


outputfolder    	= "${params.output}"


// Create a channel for values 
Channel
    .from(values.readLines())
    .map { line ->
        list = line.split("\t")
            if (list.length <2) {
			  error "ERROR!!! Peak config file has to be tab separated\n" 
	        }        
	        if (list[0]!= "") {
	        	param_name = list[0]
				initial_val = list[1]
				final_val = list[2]
				step_val = list[3]
			[ param_name, initial_val, final_val, step_val ]
        }  
    }.set{ pipe_params}


include { runModel } from "${baseDir}/modules/model.nf"
include { xmlMod } from "${baseDir}/modules/xmlmod.nf"
include { joinFiles } from "${baseDir}/modules/joinfiles.nf"
include { makePlot } from "${baseDir}/modules/rplot.nf"

Experiments = Channel.of( "testing1" )

pipe_params.map {
	def int start = it[1].toInteger()
	def int fin = it[2].toInteger()
	def int step = it[3].toInteger()
	def ranges = []
	for (i = fin; i > start; i-=step) {
		ranges.push(i)
	}
	ranges.push(start)
	[it[0], ranges]
	
}.transpose().set{reshaped_pars}

n_batches = Channel.from( 1..params.batches )


workflow {
   xml_files = xmlMod (reshaped_pars, xmlfile)
   xml_files.combine(Experiments).combine(n_batches).map{
   		["${it[0]}__${it[5]}", it[1], it[2], it[3], it[4]]
   }.set{data_for_model}
   res_model = runModel(data_for_model, nlogo)
   res_model.map{
   		def ids = it[0].split("__")
   		[ids[0], it[1]]
   }.groupTuple().set{files_pieces}
   
   concat_res = joinFiles(files_pieces)
   makePlot(concat_res)
//   res_model.groupTuple().view()
}

workflow.onComplete {
    println "Pipeline completed!"
    println "Started at  $workflow.start" 
    println "Finished at $workflow.complete"
    println "Time elapsed: $workflow.duration"
    println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}
