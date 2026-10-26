
/*
* Pipeline parameters
*/
params {
    //path to sra identifiers
    sra_input: Path = 'sra_csv.csv'
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
    // create channgel for inputs
    sra_ch = channel.fromPath(params.sra_input)
                    .splitCsv()
                    .flatten()
                    .view()

    // print sra values to check function
    printSra(sra_ch)

}