
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

process printSra {

    input:
    val sra_ident

    output:
    path "${sra_ident}-output.txt"

    script:
    """
    echo '${sra_ident}' > '${sra_ident}-output.txt'
    """
}


workflow {

    main:

    //Create path object for bash script that creates ident csv
    write_sra_script = file('./write_sra_csv.sh')

    // write all sra identifiers from bash script
    writeSraIdents(write_sra_script)

    // create channel for inputs
    sra_ch = writeSraIdents.out
                    .splitCsv()
                    .flatten()
                    .view()

    // print sra values to check function
    printSra(sra_ch)

    publish:
    sra_csv = writeSraIdents.out

}

output {
    sra_csv {
        path '.'
    }
}
