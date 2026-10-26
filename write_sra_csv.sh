#!/usr/bin/env bash

#Remove file if it already exists so we don't just keep adding on 
rm ./sra_ident.csv

for i in `seq 871 920`; 
   do 
        if [[ "$i" == "920" ]]; then
            printf "SRR15990${i}" >> ./sra_ident.csv; 

        else
            printf "SRR15990${i}," >> ./sra_ident.csv; 
        fi
   done

