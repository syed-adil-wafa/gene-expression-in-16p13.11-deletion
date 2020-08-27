## Exploring targeted whole transcriptome gene expression profiles in stem cell-derived neurons with 16p13.11 deletion


### Summary
Deletions at 16p13.11 are characterized by developmental delay, microcephaly, epilsepy, schizophrenia, childhood-onset psychosis, facial dysmorphism and behavioral problems. This experiment was conducted to compare the gene expression profiles of induced pluripotent stem cell (iPSC)-derived excitatory glutamatergic NGN2 cortical neurons and embryoid body GABAergic inhibitory neurons with and without 16p13.11 deletions. Gene expression was measured using ThermoFisher Scientific Ion AmpliSeq targeted whole transcriptome sequencing.

### Methods
All experiments were conducted after receiving institutional review board approval. iPSCs were generated from patient fibroblasts and cortical and GABAergic neuron differentiations were performed as described in [Zhang *et al.* (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23764284) and [Liu *et al.* (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23928500), respectively.
#### Filtering and pre-processing genes
Genes with absolute expression values in the 10<sup>th</sup> percentile across samples were filtered out from the dataset. Absolute expression values &le;1.0 rpm were replaced with 1.0 rpm and the entire dataset was then log<sub>2</sub> transformed. Genes with variablility in the 10<sup>th</sup> percentile across samples were then filtered out from the dataset. Finally, genes with &le;log<sub>2</sub>(4.0 rpm) across samples were filtered out from the dataset.
#### Data analysis
Downstream data analysis was conducted using in-house scripts written in MATLAB 2020a (The MathWorks, Inc.).

### Acknowledgements
Human Neuron Core: http://www.childrenshospital.org/research/labs/human-neuron-core
<br/> Early Psychosis Investigation Center: http://www.childrenshospital.org/research/centers-departmental-programs/epicenter
<br/> Laboratory of Mustafa Sahin: http://sahin-lab.org/
<br/> Harvard Stem Cell Institute: https://hsci.harvard.edu/

### References
Liu, Y., Liu, H., Sauvey, C., Yao, L., Zarnowska, E.D., & Zhang, S.C. (2013). Directed differentiation of forebrain GABA interneurons from human pluripotent stem cells. *Nature Protocols*, 8(9), 1670-9. DOI: [10.1038/nprot.2013.106](https://www.ncbi.nlm.nih.gov/pubmed/23928500)
<br/>
<br/> Zhang, Y., Pak, C., Han, Y., Ahlenius, H., Zhang, Z., Chanda, S., Marro, S., Patzke, C., Acuna, C., Covy, J., Xu, W., Yang, N., Danko, T., Chen, L., Wenig, M., & Sudhof, T.C. (2013). Rapid Single-Step Induction of Functional Neurons from Human Pluripotent Stem Cells. *Neuron*, 78(5), 785-798. DOI: [10.1016/j.neuron.2013.05.029](https://www.ncbi.nlm.nih.gov/pubmed/23764284)
