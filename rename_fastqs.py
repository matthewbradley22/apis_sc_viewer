#Fastqs with read length 28 = R1, 150 = R2, 8 = index
import re

import pandas as pd

from glob import glob

#Read in csv with sra acsension to fastq name pairs
#Create lists of sra ascensions and fastq names
name_data = pd.read_csv('/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/sra_to_fastq.csv')

#Get ascension values
sra_asc = (name_data['Run ID'].unique().dropna())

#For each ascension value, get first fastq associated
cur_asc = name_data[name_data['Run ID'] == sra_asc[0]]
fastq_name = cur_asc.iloc[0]['FastQ names']

#Get beginning of each fastq, then can append correct finish (I1, R1, R2)
fastq_base_name = re.search('(.+?)_(I1|R1|R2)_001.fastq', fastq_name).group(1)
print(fastq_base_name)

#Loop through fastq files and 
#1. determine which type of fastq it is (I1, R1, R2)
#2. relabel it accordingly
all_files = (glob("/Volumes/T7/apis_sc_viewer/*fastq"))
print(all_files)
