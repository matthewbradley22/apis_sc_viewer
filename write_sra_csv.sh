#!/usr/bin/env bash

#Remove file if it already exists so we don't just keep adding on 
rm ./sra_csv.csv

for i in `seq 871 920`; 
   do 
       printf "SRR15990${i}," >> ./sra_csv.csv; 
   done

