process runModel {
    container biocorecrg/econ:0.1
    tag { id }

    input:
    tuple val(id), path(peak)

    output:
    tuple val("${id}_epic"), path("${id}_epic_6.bed")
    
	script:
    """
    grep -v "#" ${peak} | awk '{OFS="\t"; num++; score=int(\$5); if (score>1000) {score = 1000}; print \$1,\$2,\$3,"peak_"num, score, \$6}' > ${id}_epic_6.bed
    """
}

process makeGraph {
    container biocorecrg/econ_r:0.1

    tag { id }
    
    input:
    val(ext)
    tuple val(id), path(peak)

    output:
    tuple val("${id}_${ext}"), path("${id}_${ext}_6.bed")
    
	script:
    """
    awk -F"\t" '{OFS="\t"; print \$1,\$2,\$3,\$4,\$5,\$6}' ${peak} | awk '{OFS="\t"; score=int(\$5); if (score>1000) {score = 1000}; print \$1,\$2,\$3,\$4, score, \$6}' > ${id}_${ext}_6.bed
    """
}

