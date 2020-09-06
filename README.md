## Exploring targeted whole transcriptome gene expression profiles in human iPSC-derived cortical and GABAergic neurons with 16p13.11 deletion


### Summary
Deletions at 16p13.11 are characterized by developmental delay, microcephaly, epilsepy, schizophrenia, childhood-onset psychosis, facial dysmorphism, and behavioral problems. The molecular mechanisms that underlie these clinical phenotypes remain largely unknown. This pilot experiment was conducted to compare the gene expression profiles of human induced pluripotent stem cell (iPSC)-derived excitatory glutamatergic NGN2 cortical neurons and GABAergic inhibitory neurons with 16p13.11 deletions and familial controls. We identified 154 and 31 differentially expressed genes (DEGs) in the cortical and GABAergic neurons with 16p13.11 deletions, respectively. *NNAT*, a gene that encodes a proteolipid involved in the regulation of ion channels during neural development, was identified to be a statistically and biologically significant up-regulated gene in cortical neurons with 16p13.11 deletions. In addition, several isoforms of protocadherins were observed to be differentially expression in these cortical neurons. No DEGs were found to be statistically and biologically significant in GABAergic neurons with 16p13.11 deletions. Annotating DEGs using gene ontology (GO) indicated up-regulation of integrin binding and structural molecule activity and down-regulation of signaling receptor and catalytic activity in cortical neurons with 16p13.11 deletions; transmembrane transporter activity was up-regulated and ion binding and catalytic activity was down-regulated in GABAergic neurons with 16p13.11 deletions. 

### Methods
All experiments were conducted after receiving institutional review board approval. iPSCs were generated from patient fibroblasts and excitatory glutamatergic NGN2 cortical and embryoid body GABAergic inhibitory neuron differentiations were performed as described in [Zhang *et al.* (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23764284) and [Liu *et al.* (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23928500), respectively. Neurons were re-plated on poly-D-lysine/laminin coated 12-well plates and allowed to mature for a week prior to RNA isolation. Gene expression was measured using ThermoFisher Scientific Ion AmpliSeq targeted whole transcriptome sequencing. 
#### Filtering and pre-processing genes
Genes with absolute expression values in the bottom 10<sup>th</sup> percentile across samples were filtered out from the dataset. Absolute expression values &le;1.0 rpm were replaced with 1.0 rpm and the entire dataset was then log<sub>2</sub> transformed. Genes with variablility in the bottom 10<sup>th</sup> percentile across samples were then filtered out from the dataset. Finally, genes with &le;log<sub>2</sub>(4.0 rpm) across samples were filtered out from the dataset.
#### Data and statistical analysis
Downstream data analysis was performed using in-house scripts written in MATLAB 2016a (The MathWorks, Inc.). Hierarchical clustering of gene expression data was performed using the `clustergram` function with `correlation` as the distance metric. Permutation *t*-tests were conducted for each gene to identify statistically significant changes in expression values at the 95% alpha-significance level. Biologically significant genes were identified by computing *q*-values and false discovery rates (FDRs) (using the Storey-Tibshirani procedure). DEGs were annotated using GO by mapping gene symbols and associated GO terms. Statistically significant GO terms were determined using the hypergeometric probability distribution. For each GO term, a *p*-value was calculated representing the probability that the number of annotated genes associated with it could have been found by chance.

#### Results and discussion
Hierarchical clustering of the data demonstrated batch-to-batch variation for both cortical and GABAergic neurons with similarity between different genotypes from the same batch of differentiation and variability between similar genotypes from different batches of differentiation.
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/GABAergic%20inhibitory%20neurons/clustergram.png) ![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/Excitatory%20NGN2%20cortical%20neurons/clustergram.jpg)
DEGs were then identified in cortical and GABAergic neurons with 16p13.11 deletions and their statistical and biological significance determined. There were no genes that were both statistically and biologically significant in the GABAergic inhibitory neurons. However, there were 2 genes that were both statistically and biologically significant in the excitatory NGN2 cortical neurons; these were *KDM5D*, which encodes a zinc finger domain containing protein and *NNAT*, which encodes a proteolipid that might be involved in the regulation of ion channels during brain development.
|                                      | GABAergic inhibitory neurons | excitatory NGN2 cortical neurons |
| ------------------------------------ |:----------------------------:|:--------------------------------:|
| # of statistically significant genes | 205                          | 554                              |
| # of biologically significant genes  | 0                            | 2                                |
| # of differentially expressed genes  | 31                           | 154                              |
| # of up-regulated genes              | 17                           | 131                              |
| # of down-regulated genes            | 14                           | 23                               |

The following two volcano plots highlight the top 3 most up-regulated and down-regulated genes in the cortical and GABAergic neurons with 16p13.11 deletions. We observed that *NNAT* had the highest absolute fold change value and the lowest *p*-value in the cortical neurons. Several isoforms of protocadherins were also identified to be differentially expressed in the cortical neurons potentially implicating dysfunction in cell adhesion and structural molecule activity.  
##### Volcano plot of GABAergic inhibitory neurons
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/GABAergic%20inhibitory%20neurons/volcano-plot.png)
##### Volcano plot of excitatory NGN2 cortical neurons
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/Excitatory%20NGN2%20cortical%20neurons/volcano-plot.png)
Finally, GO terms related to specific molecule functions were selected and sub-ontology including the ancestors of the terms were built. Graph nodes were colored according to their significance with red and blue nodes being the most and least significant GO terms, respectively. We observed up-regulation of transmembrane transporter activity and down-regulation of ion binding and catalytic activity in GABAergic neurons with 16p13.11 deletions. We also observed up-regulation of integrin binding and structural molecule activity and down-regulation of signaling receptor and catalytic activity in cortical neurons with 16p13.11 deletions.
##### Gene ontology of up-regulated genes in GABAergic inhibitory neurons
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/GABAergic%20inhibitory%20neurons/up-regulated-ontology.png)
##### Gene ontology of down-regulated genes in GABAergic inhibitory neurons
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/GABAergic%20inhibitory%20neurons/down-regulated-ontology.png)
##### Gene ontology of up-regulated genes in excitatory NGN2 cortical neurons
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/Excitatory%20NGN2%20cortical%20neurons/up-regulated-ontology.png)
##### Gene ontology of down-regulated genes in excitatory NGN2 cortical neurons
![alt text](https://github.com/syed-adil-wafa/gene-expression-in-16p13.11-deletion/blob/master/figures/Excitatory%20NGN2%20cortical%20neurons/down-regulated-ontology.png)
#### Limitations and future directions
Analyses need to be repeated after accounting for batch-to-batch variability and sex differences between genotypes. Performing more differentiations will increase the number of biological replicates for each genotype allowing for replicability and better precision.

### Acknowledgements
Human Neuron Core: http://www.childrenshospital.org/research/labs/human-neuron-core
<br/> Early Psychosis Investigation Center: http://www.childrenshospital.org/research/centers-departmental-programs/epicenter
<br/> Laboratory of Mustafa Sahin: http://sahin-lab.org/
<br/> Harvard Stem Cell Institute: https://hsci.harvard.edu/
<br/> Laboratory of Thomas S&uuml;dhof: https://med.stanford.edu/sudhoflab.html

### References
Buttermore, E.D., Chen, P.-F., Anderson, N.C., Wafa, S.M.A., Dwyer, S.A., Micozzi, J.M., Winden, K.D., Zhang, B., Han, M.-J., Kleiman, R.J., Brownstein, C.A., Sahin, M., & Gonzalez-Heydrich, J. (2020). *16p13.11 deletion variants associated with neuropsychiatric disorders cause morphological and synaptic changes in iPSC-derived neurons.* Manuscript submitted for publication.
<br/>
<br/>Liu, Y., Liu, H., Sauvey, C., Yao, L., Zarnowska, E.D., & Zhang, S.C. (2013). Directed differentiation of forebrain GABA interneurons from human pluripotent stem cells. *Nature Protocols*, *8*(9), 1670-9. DOI: [10.1038/nprot.2013.106](https://www.ncbi.nlm.nih.gov/pubmed/23928500)
<br/>
<br/> Zhang, Y., Pak, C., Han, Y., Ahlenius, H., Zhang, Z., Chanda, S., Marro, S., Patzke, C., Acuna, C., Covy, J., Xu, W., Yang, N., Danko, T., Chen, L., Wenig, M., & Sudhof, T.C. (2013). Rapid Single-Step Induction of Functional Neurons from Human Pluripotent Stem Cells. *Neuron*, *78*(5), 785-798. DOI: [10.1016/j.neuron.2013.05.029](https://www.ncbi.nlm.nih.gov/pubmed/23764284)
