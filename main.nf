
process writeSraIdents {

    input:
    path bash_script

    output:
    path "sra_ident.csv"

    script:
    """
    bash ${bash_script}
    """
}

process run_prefetch {

    input:
    val sra_ident

    output:
    path "${sra_ident}_prefetch"

    script:
    """
    prefetch ${sra_ident}
    """
}


workflow {

    main:

    //Create path object for bash script that creates ident csv
    write_sra_script = file('./write_sra_csv.sh')

    // write all sra identifiers from bash script
    writeSraIdents(write_sra_script)

    // create flattened array for inputs into prefetch
    sra_array = writeSraIdents.out
                    .splitCsv()
                    .flatten()

    // print sra values to check function
    run_prefetch(sra_array)
                    .view()

    publish:
    sra_csv = writeSraIdents.out
    prefetch_files = run_prefetch.out

}

output {
    sra_csv {
        path '.'
    }

    prefetch_files {
        path "prefetch_res"
    }
}
