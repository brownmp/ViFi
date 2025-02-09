version 1.0






#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Run ViFi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
task RunViFi {
    input {
        File fastq1
        File? fastq2

        File Human_Reference
        File Virus_Reference

        Int cpus
        Int preemptible
        String docker
        String sample_id
    }

    command <<<
        set -e


        export REFERENCE_REPO=`pwd`/Virus_DB
        export AA_DATA_REPO=`pwd`/Human_DB
        export VIFI_DIR="/usr/local/src/ViFi/ViFi"

        #~~~~~~~~~~~~~~~~~~~~~~~~
        # Untar the references  
        #~~~~~~~~~~~~~~~~~~~~~~~~
        tar -xvf ~{Human_Reference}
        tar -xvf ~{Virus_Reference}

        # special case for tar of fastq files
        if [[ "~{fastq1}" == *.tar.gz ]]
        then
            mkdir fastq
            tar -xvf ~{fastq1} -C fastq
            rm ~{fastq1}
            #fastqs=$(find fastq -type f)
            fastqs=($(pwd)/fastq/*)
            fastq1="${fastqs[0]}"
            fastq2="${fastqs[1]}"

            #~~~~~~~~~~~~~~~~~~~~~~~
            # run ViFi
            #~~~~~~~~~~~~~~~~~~~~~~~
            python /usr/local/src/ViFi/ViFi/scripts/run_vifi.py \
                -f $fastq1 \
                -r $fastq2 \
                --virus hpv \
                -c ~{cpus} \
                --threshold 0.020000 \
                -o `pwd`/OUTPUT \
                -p ~{sample_id}
        else 
        
            #~~~~~~~~~~~~~~~~~~~~~~~
            # Run ViFi
            #~~~~~~~~~~~~~~~~~~~~~~~
            python /usr/local/src/ViFi/ViFi/scripts/run_vifi.py \
                -f ~{fastq1} \
                -r ~{fastq2} \
                --virus hpv \
                -c ~{cpus} \
                --threshold 0.020000 \
                -o `pwd`/OUTPUT \
                -p ~{sample_id}
        fi

        tar -czf OUTPUT.tar.gz OUTPUT

    >>>

    output {
        File output_file="OUTPUT.tar.gz"
        File output_clusters_txt_range="./OUTPUT/~{sample_id}.clusters.txt.range"
        File output_clusters_txt = "./OUTPUT/~{sample_id}.clusters.txt"
    }

    runtime {
        preemptible: preemptible
        disks: "local-disk " + ceil(size(Virus_Reference, "GB") + size(Human_Reference, "GB") + size(fastq1, "GB")*6 + 100) + " HDD"
        docker: docker
        cpu: cpus
        memory: "100GB"
    }
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Workflow
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

workflow ViFi {
    input {

        #~~~~~~~~~~~~
        # Sample ID
        #~~~~~~~~~~~~
        String sample_id
      
        #~~~~~~~~~~~~
        # FASTQ Files
        #~~~~~~~~~~~~
        File left
        File? right

        #~~~~~~~~~~~~
        # CPU count 
        #~~~~~~~~~~~~
        Int cpus = 10

        #~~~~~~~~~~~~
        # Directories 
        #~~~~~~~~~~~~
        File Virus_Reference
        File Human_Reference

        #~~~~~~~~~~~~
        # general runtime settings
        #~~~~~~~~~~~~
        Int preemptible = 2
        String docker = "brownmp/vifi:devel"

        

    }

    parameter_meta {
        left:{help:"One of the two paired RNAseq samples"}
        right:{help:"One of the two paired RNAseq samples"}
        cpus:{help:"CPU count"}
        docker:{help:"Docker image"}
    }


    #########################
    # run using given references 
    #########################
    call RunViFi{
        input:
            fastq1 = left,
            fastq2 = right,

            Human_Reference = Human_Reference,
            Virus_Reference = Virus_Reference,
            
            cpus            = cpus,
            preemptible     = preemptible,
            docker          = docker,
            sample_id       = sample_id
    }
}
