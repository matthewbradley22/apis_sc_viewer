#Use pyranges package to parse gtf
import re
import pandas as pd

gene_ids = []
products = []

#Read each line of gtf and populate 
#lists with gene ids and products for any lines with both
with open("GCF_003254395.2_Amel_HAv3.1_genomic.gtf") as file:
    for line in file:
        if('CDS' in line):
            gene_id =  re.search('gene_id "(.*?)"; ', line)
            product = re.search('product "(.*?)";', line)
            if gene_id and product:
                gene_ids.append(gene_id.group(1))
                products.append(product.group(1))

#load list data into a DataFrame object:
gene_df = pd.DataFrame({'gene_id': gene_ids, 'product': products})

gene_df.to_csv('/Users/matthewbradley/Documents/BeeStuff/bee_sc_viewer/gene_id_to_product.csv',index=False)