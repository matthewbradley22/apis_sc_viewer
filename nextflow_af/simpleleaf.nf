
/*
 * Pipeline parameters
 */
params {
    working_dir: String = '/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/nextflow_af/'
    gtf_file: String = 'GCF_003254395.2_Amel_HAv3.1_genomic.gtf'
    fasta_file: String = 'GCF_003254395.2_Amel_HAv3.1_genomic.fna'
}

/*
* gtf has an odd back slash that messsed up indexing in one line. Remove
*/
process clean_gtf {

    input:
    val working_dir
    val gtf_file

    output:
    path "GCF_003254395.2_Amel_HAv3.1_genomic_clean.gtf"

    script:
    """
    tr -d '\\' < "${working_dir}/ref_materials/${gtf_file}" > GCF_003254395.2_Amel_HAv3.1_genomic_clean.gtf
    """

}

/*
* configure and index with simpleleaf
*/
process index_ref {

    input:
    val working_dir
    val gtf_file
    val fasta_file

    script:
    """
    # Get working dir as variable
    working_dir="/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/nextflow_af/"

    # run configuration 

    # define env variable
    export ALEVIN_FRY_HOME="/Volumes/T7/apis_sc_viewer/af_home"
    # simpleaf configuration
    simpleaf set-paths

    # simpleaf index
    simpleaf index \
    --output "${working_dir}/index_materials" \
    --fasta "${working_dir}/ref_materials/${fasta_file}" \
    --gtf "${gtf_file}" \
    --threads 6 \
    --work-dir ./workdir.noindex
    """

}


workflow {
    main:
    //Remove odd backslash in gtf file
    clean_gtf(params.working_dir, params.gtf_file)
    // index reference
    index_ref(params.working_dir, clean_gtf.out, params.fasta_file)

    publish:
    gtf_to_use = clean_gtf.out
}

output {
    gtf_to_use {
        path 'ref_materials'
        mode 'copy'
    }
}

