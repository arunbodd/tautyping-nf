process GFFREAD {
    tag "$meta.id"
    tag "$gff"
    label 'process_low'
    
    conda (params.enable_conda ? "bioconda::gffread=0.12.1" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gffread:0.12.1--h8b12597_0' :
        'quay.io/biocontainers/gffread:0.12.1--h8b12597_0' }"

    input:
    tuple val(meta), path(fasta), path(gff)

    output:
    tuple val(meta), path("*.transcripts.fasta"), emit: transcripts
    path "versions.yml"                         , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args   ?: ''
    def prefix = task.ext.prefix ?: "${gff.baseName}"
    """
    gffread \\
        $gff \\
        $args \\
        -w ${prefix}.transcripts.fasta \\
        -g $fasta

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gffread: \$(gffread --version 2>&1)
    END_VERSIONS
    """
}
