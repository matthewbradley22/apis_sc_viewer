library(SingleCellExperiment)
library(Seurat)
library(fishpond)
library(readr)

# define count matrix format according to https://combine-lab.github.io/alevin-fry-tutorials/2023/simpleaf-piscem/
custom_format <- list("counts" = c("U", "S", "A"),
                      "spliced" = c("S"),
                      "unspliced" = c("U"),
                      "ambiguous" = c("A"))

#Fishpond package to easily load from simpleaf output
sce_testing <- fishpond::loadFry("/Volumes/T7/apis_sc_viewer/Foragers02_S6_L004_R1/af_quant",
                         outputFormat = custom_format)

#Import gene id to protein index
gene_id_to_product <- read_csv("~/Documents/BeeStuff/bee_sc_viewer/gene_id_to_product.csv")
gene_id_to_product <- distinct(gene_id_to_product)

# create seurat object
seurat_testing <- CreateSeuratObject(counts(sce_testing))
seurat_testing <- subset(seurat_testing, nFeature_RNA > 0)

seurat_testing <- subset(seurat_testing, subset = nFeature_RNA > 200 & nFeature_RNA < 2500)
seurat_testing <- NormalizeData(seurat_testing, normalization.method = "LogNormalize", scale.factor = 1e4)
seurat_testing <- FindVariableFeatures(seurat_testing, selection.method = 'vst', nfeatures = 2000)
seurat_testing <- ScaleData(seurat_testing)
seurat_testing <- RunPCA(seurat_testing, features = VariableFeatures(object = seurat_testing))
ElbowPlot(seurat_testing, ndims = 40)
seurat_testing <- FindNeighbors(seurat_testing, dims = 1:10)
seurat_testing <- FindClusters(seurat_testing, resolution = 0.5)
seurat_testing <- RunUMAP(seurat_testing, dims = 1:10)
DimPlot(seurat_testing, reduction = 'umap')

FeaturePlot(seurat_testing, features = 'Mblk-1')
