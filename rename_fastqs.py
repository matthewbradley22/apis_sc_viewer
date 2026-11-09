#Fastqs with read length 28 = R1, 150 = R2, 8 = index
import re

import pandas as pd

from glob import glob

import os

#Read in csv with sra acsension to fastq name pairs
#Create lists of sra ascensions and fastq names
name_data = pd.read_csv('/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/sra_to_fastq.csv')
name_data = name_data[["run_id", "fastq_name"]]
name_data = name_data.dropna()

#Loop through fastq files and 
#1. determine which type of fastq it is (I1, R1, R2)
#2. relabel it accordingly
all_files = (glob("/Volumes/T7/apis_sc_viewer/*fastq"))
for file_name in all_files:

    #Get run id of current file, if it has not been renamed yet
    cur_file_name = re.search('/Volumes/T7/apis_sc_viewer/(.+)(_.+)', file_name).group(1)
    if cur_file_name in name_data["run_id"].tolist():
    
        #Get length of fastq reads to name file
        with open(file_name) as f:
            first_line = f.readline()
            length = re.search('length=(.+)', first_line).group(1)

        match length:
            case "28":
                fastq_type = "R1"
            case "150":
                fastq_type = "R2"
            case "8":
                fastq_type = "I1"

        #Get fastq base name
        cur_fastq_base = name_data[name_data["run_id"] == cur_file_name]['fastq_name'][0]

        new_fastq_name = (cur_fastq_base + '_' + fastq_type + '_001.fastq')
        cur_path = "/Volumes/T7/apis_sc_viewer/"
        new_fastq_with_path = cur_path + new_fastq_name
        os.rename(file_name, new_fastq_with_path)