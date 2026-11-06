#Relabel fastq files into index (I), read 1 (R1) and read 2 (R2)

#Get all fastq files from given ascension
file_num="SRR10693356"
first_file="/Volumes/T7/apis_sc_viewer/${file_num}_1.fastq"
second_file="/Volumes/T7/apis_sc_viewer/${file_num}_2.fastq"
third_file="/Volumes/T7/apis_sc_viewer/${file_num}_3.fastq"

#Get length of selected file
for i in $first_file $second_file $third_file
do  
    cur_length=$(head -n 1  ${i} | \
    awk '{print $3}')

    #Rename file based on length
    if [[ $cur_length == *"28"* ]]; then
        echo "R1"
    elif [[ $cur_length == *"8"* ]]; then
        echo "index"
    elif [[ $cur_length == *"150"* ]]; then
        echo "R2"
    fi
done