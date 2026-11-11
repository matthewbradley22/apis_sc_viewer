
/*
 * Pipeline parameters
 */
params {
    working_dir: String = '/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/nextflow_af/'
    gtf_file: String = 'GCF_003254395.2_Amel_HAv3.1_genomic.gtf'
    fasta_file: String = 'GCF_003254395.2_Amel_HAv3.1_genomic.fna'
    fastq_dir: String = '/Volumes/T7/apis_sc_viewer'
    index_dir: String =  '/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/nextflow_af/index_materials/index'
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

    output:
    val "${working_dir}/index_materials", emit: idx_dir

    script:
    """
    # Get working dir as variable
    working_dir="/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/nextflow_af/"

    #Set environment
    # run configuration 
    # define env variable
    export ALEVIN_FRY_HOME="/Volumes/T7/apis_sc_viewer/af_home"
    # simpleaf configuration
    simpleaf set-paths

    #Only create index if it has not been created yet
    if [ ! -d "\$working_dir/index_materials/index"]; then
        # simpleaf index
        simpleaf index \
        --output "${working_dir}/index_materials" \
        --fasta "${working_dir}/ref_materials/${fasta_file}" \
        --gtf "${gtf_file}" \
        --threads 6 \
        --work-dir ./workdir.noindex
    fi
    """

}

/*
* quantify fastq files
*/
process run_quant {

    input:
    val FASTQ_DIR
    val IDX_DIR

    script:
    """

    # define env variable
    export ALEVIN_FRY_HOME="/Volumes/T7/apis_sc_viewer/af_home"
    # simpleaf configuration
    simpleaf set-paths

    # Obtain and sort filenames
    reads1="\$(find -L "${FASTQ_DIR}" -name "*R1_001*" -type f | sort | awk -v OFS=, '{\$1=\$1;print}' | paste -sd, -)"
    reads2="\$(find -L "${FASTQ_DIR}" -name "*R2_001*" -type f | sort | awk -v OFS=, '{\$1=\$1;print}' | paste -sd, -)"

    #Create new directory for every pair of fastq files
    #for ((i=0; i<\${#reads1[@]}; i++)); do
    for i in \${!reads1[@]}; do
        read1="\${reads1[\$i]}"
        read2="\${reads2[\$i]}"

        #name directory same as start of fastq names
        pair_output_dir="\${read1%_*}"
        mkdir -p "\${pair_output_dir}"

 
        # simpleaf quantfication
        simpleaf quant \
        --reads1 "\$reads1" \
        --reads2 "\$reads2" \
        --threads 8 \
        --index "${IDX_DIR}/index" \
        --chemistry 10xv3 --resolution cr-like \
        --unfiltered-pl --anndata-out \
        --output "\${pair_output_dir}"
    done

    """
    

}

workflow {
    main:
    //Remove odd backslash in gtf file
    clean_gtf(params.working_dir, params.gtf_file)
    // index reference
    index_ref(params.working_dir, clean_gtf.out, params.fasta_file)
    //Quantify fastq files
    run_quant(params.fastq_dir, index_ref.out.idx_dir)

    publish:
    gtf_to_use = clean_gtf.out
}

output {
    gtf_to_use {
        path 'ref_materials'
        mode 'copy'
    }

}

