# Single cell viewer for apis mellifera

Taking all published single cell works in honey bees and compiling into one large dataset that can
be interactively explored

## Why not all in a single nextflow script?

The prefetch calls leads to many terabytes of data, more feasible for most users 
to gradually prefetch and process data with cellranger in chunks. Not super
well suited to nextflow as far as I can tell, so this defeats the purpose a bit as
it may make it more annoying to reproduce

Even using nf-core fetchlings seemed to be more trouble than it was worth,
as many of these have 3 fastq files anyways and require an sra download.
Plus, prefetching and dumping fastQs should not be where reproducibility breaks down