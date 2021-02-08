process get_decision {
    label 'ubuntu'
    input:
        tuple val(name), file(read_until)
    output:
        tuple val(name), file("*_read_id.txt")
    script:
        """

        """
}