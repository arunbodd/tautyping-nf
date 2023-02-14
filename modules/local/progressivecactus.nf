process PROGRESSIVECACTUS {
    label 'process_high'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'quay.io/comparative-genomics-toolkit/cactus:v2.4.1' }"

    input:
    val file_in

    output:
	path("*.hal")               , emit: hal
	
    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: '' 
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    cactus $args ${file_in} \\
    ${prefix}.hal \\
    --batchSystem grid_engine --consCores 32
    
    """
}
