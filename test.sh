usage() {
        declare -r script_name=$(basename "$0")
        echo """
Usage:
"${script_name}" [option] <name>

Option:
-h|--host <foo.com|bar.com|baz.com|...>
-a|--accountId <001123456789|002123456789|...>
"""
        exit 0
}



main() {

        # Initialize variables to track if -w, -c, and -l are provided
        W_FLAG_PROVIDED=false
        C_FLAG_PROVIDED=false
        L_FLAG_PROVIDED=false

        # [[ $# -eq 0 ]] && usage

        # :w:uislch

        optspec=":uislch-:"
        while getopts "$optspec" optchar; do
                case "${optchar}" in
                        -)
                        case "${OPTARG}" in
                                website=*)
                                        WEBSITE=${OPTARG#*=}
                                        W_FLAG_PROVIDED=true
                                        # echo "Specified website '--${OPTARG}': ${WEBSITE}" >&2;
                                        ;;
                                
                                unit-test) RUN_OSS_UNIT=true ;;
                                integ-test) RUN_OSS_INTEG=true ;;
                                style-test) RUN_OSS_STYLE=true ;;
                                cypress-integ-test) RUN_CYPRESS_INTEG=true; C_FLAG_PROVIDED=true ;;
                                local) RUN_LOCAL=true; L_FLAG_PROVIDED=true ;;
                                help) usage; exit 0 ;;
                        esac;;
                        u) RUN_OSS_UNIT=true ;;
                        i) RUN_OSS_INTEG=true ;;
                        s) RUN_OSS_STYLE=true ;;
                        c) RUN_CYPRESS_INTEG=true; C_FLAG_PROVIDED=true ;;
                        l) RUN_LOCAL=true; L_FLAG_PROVIDED=true ;;
                        h) usage; exit 0 ;;
                        *)
                        if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                                echo "Non-option argument: '-${OPTARG}'" >&2
                        fi
                        ;;
                esac
        done

        # while true
        # do
        #         case $1 in
        #                 -w|--website) WEBSITE=$2; W_FLAG_PROVIDED=true; shift 2;;
        #                 -u|--unit-test) RUN_OSS_UNIT=true ;;
        #                 -i|--integ-test) RUN_OSS_INTEG=true ;;
        #                 -s|--style-test) RUN_OSS_STYLE=true ;;
        #                 -c|--cypress-integ-test) RUN_CYPRESS_INTEG=true; C_FLAG_PROVIDED=true ;;
        #                 -l|--local) RUN_LOCAL=true; L_FLAG_PROVIDED=true ;;
        #                 -h|--help) usage; exit 0 ;;
        #                 # -a|--accountId) ACCOUNTID=$2; shift 2;;
        #                 # -h|--host) HOST=$2; shift 2;;
        #                 # --help) usage;;
        #                 # --) shift ; break ;;
        #         esac
        # done

        # Check if -w flag was provided
        if ! $W_FLAG_PROVIDED; then
        printf "Error: -w <WEBSITE-URL> is required.\n" >&2
        usage
        fi

        # Check if -l flag is provided without -c flag
        if $L_FLAG_PROVIDED && ! $C_FLAG_PROVIDED; then
        printf "Error: -l flag can only be used when -c flag is also present.\n" >&2
        usage
        fi

        # echo host: $HOST, accountId: $ACCOUNTID
        echo "Website: $WEBSITE"
        echo "Run OSS Unit Test: $RUN_OSS_UNIT"
        echo "Run OSS Integration Test: $RUN_OSS_INTEG"
        echo "Run OSS Style Test: $RUN_OSS_STYLE"
        echo "Run Cypress Integration Test: $RUN_CYPRESS_INTEG"
        echo "Run Local: $RUN_LOCAL"


}

main "$@"