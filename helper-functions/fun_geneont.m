% Annotate differentially regulated genes using gene ontology
function [BG] = fun_geneont(dm_rownames, volcano_fc, geneidx)

% Extract current gene ontology annotations
cd ../data % change directory to extract ontology data

GO = geneont('live', true);

% Unzip and read the goa_human.gaf.gz file (downloaded from 
% http://current.geneontology.org/products/pages/downloads.html)
gunzip('goa_human.gaf.gz');
HGann = goannotread('goa_human.gaf',...
    'Aspect', 'F', 'Fields', {'DB_Object_Symbol', 'GOid'});

% Create a mapping between the gene symbols and the associated GO terms
HGmap = containers.Map();
for i = 1:numel(HGann)
    key = HGann(i).DB_Object_Symbol;
    if isKey(HGmap, key)
        HGmap(key) = [HGmap(key), HGann(i).GOid];
    else
        HGmap(key) = HGann(i).GOid;
    end
end

% Annotate differentially expressed genes
% Find the indices of differentially expressed genes
genes = rownames(volcano_fc, geneidx);
huGenes = dm_rownames;
for gene = 1:size(geneidx, 1)
    geneidx(gene) = find(strncmpi(huGenes, genes{gene}, length(genes{gene})), 1);
end

% For each gene, see if it is annotated by comparing its gene symbol to the
% list of gene symbols from GO and track the number of annotated genes and
% the number of differentially expressed genes associated with each GO
% term.
m = GO.Terms(end).id; % get the last term id
chipgenesCount = zeros(m, 1); % vector of GO term counts for entire chip
genesCount = zeros(m, 1); % vector of GO term counts for differentially expressed genes
for gene = 1:length(huGenes)
    if isKey(HGmap, huGenes{gene})
        goid = getrelatives(GO, HGmap(huGenes{gene}));
        chipgenesCount(goid) = chipgenesCount(goid) + 1;
        if (any(gene == geneidx))
            genesCount(goid) = genesCount(goid) + 1;
        end
    end
end

% Determine the statistically significant GO terms using the hypergeometric
% probability distribution. For each GO term, a p-value is calculated
% representing the probability that the number of annotated genes
% associated with it could have been found by chance.
gopvalues = hygepdf(genesCount, max(chipgenesCount), max(genesCount), chipgenesCount);
[~, idx] = sort(gopvalues);

% Select the GO terms related to specific molecule function and build a
% sub-ontology that includes ancestors of the terms
fcnAncestors = GO(getancestors(GO, idx(1:5)));
[cm, acc, ~] = getmatrix(fcnAncestors);
BG = biograph(cm, get(fcnAncestors.Terms, 'name'));

for i = 1:numel(acc)
    pval = gopvalues(acc(i));
    color = [(1-pval).^(1), pval.^(1/8), pval.^(1/8)];
    BG.Nodes(i).Color = color;
end
view(BG)

cd ../helper-functions % change directory to enable helper functions

end