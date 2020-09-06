%% Exploring targeted whole transcriptome gene expression profiles in human iPSC-derived neurons with 16p13.11 deletions

close all % close all figures
clear % clear workspace
clc % clear command window
rng(1); % seed random number generator for reproducibility

%% Ion AmpliSeq configurations

% Define the # of samples in each Ion AmpliSeq preparation
ampliseq_config.number_of_samples = 9;

% Define the gene expression start and end rows in data files
ampliseq_config.start_row = 2;
ampliseq_config.end_row = 20813;

% Define the gene name, NCBI name, and sample start and end columns
ampliseq_config.gene_name_col = 1; % gene name column
ampliseq_config.ncbi_name_col = 13; % NCBI name column

ampliseq_config.sample_start_col = 3;
ampliseq_config.sample_end_col = ...
    ampliseq_config.sample_start_col + ampliseq_config.number_of_samples - 1;

% Define the # of experimental conditions (eg. neuronal subtypes) to loop over
ampliseq_config.number_of_conditions = 2;

% Define the # of cell lines in each experimental condition
ampliseq_config.number_of_lines = 2;

%% Sample label information

% Define labels for each experimental condition
ampliseq_config.labels_condition = {...
    'excitatory NGN2 cortical', 'GABAergic inhibitory'};

% Define column identifiers for each cell line for each condition
ampliseq_config.condition_1_line_1 = [4, 6, 8];
ampliseq_config.condition_1_line_2 = [5, 7, 9];
ampliseq_config.condition_2_line_1 = [2, 4, 6, 8];
ampliseq_config.condition_2_line_2 = [3, 5, 7, 9];

%% Data extraction

cd data % change directory to extract data

% Retrieve all .xlsx files in the data folder
extraction.files = dir('*.xlsx');

% Extract data from each file
for file = 1:size(extraction.files, 1)
    
    % Get the name of each individual file and store them in a vector
    extraction.current_file = extraction.files(file).name;
    extraction.filenames(:, file) = cellstr(extraction.current_file);
    
    % Read data from each file
    [~, ~, extraction.file_data] = xlsread([pwd, ['/', extraction.current_file]]);
    extraction.raw_data(:, :, file) = cell2mat(extraction.file_data(...
        ampliseq_config.start_row:size(extraction.file_data, 1),...
        ampliseq_config.sample_start_col:ampliseq_config.sample_end_col));
    
    % Get gene and NCBI names of all 20,812 genes
    if file == size(extraction.files, 1)
        % Get gene names
        extraction.gene_names = extraction.file_data(...
            ampliseq_config.start_row:size(extraction.file_data, 1),...
            ampliseq_config.gene_name_col);
        % Get NCBI names
        extraction.ncbi_names = extraction.file_data(...
            ampliseq_config.start_row:size(extraction.file_data, 1),...
            ampliseq_config.ncbi_name_col);
    end
    
    % Get the column names for each file
    extraction.col_names(file, :) = extraction.file_data(...
        1, ampliseq_config.sample_start_col:ampliseq_config.sample_end_col);
    
end

%% Data pre-processing, analysis, and visualization

% Suppress warnings associated with data analysis
w = warning('on', 'all');
id = w.identifier;
warning('off', id);

% Set the 95% alpha-significance level
cutoff = 0.05; % (1 - cutoff) * 100

% For each condition, stratify the data for downstream processing
for condition = 1:ampliseq_config.number_of_conditions
    
    cd ../helper-functions % change directory to enable helper functions
    
    % Pre-process gene name strings
    extraction.gene_names = gene_name_preprocess(...
        extraction.gene_names, extraction.ncbi_names);
    
    % Create a DataMatrix object of the extracted data
    processing.dm = bioma.data.DataMatrix(...
        extraction.raw_data(:, :, condition),...
        'RowNames', extraction.gene_names,...
        'ColNames', extraction.col_names(condition, :));
    
    % Define columns for each cell line for each experimental condition
    if contains(extraction.filenames(:, condition), 'cortical') == 1
        processing.dm = processing.dm(:,...
            [ampliseq_config.condition_1_line_1,...
            ampliseq_config.condition_1_line_2]);
    else
        processing.dm = processing.dm(:,...
            [ampliseq_config.condition_2_line_1,...
            ampliseq_config.condition_2_line_2]);
    end
    
    % Filter out genes with absolute expression levels below 10th percentile
    [~, processing.dm] = genelowvalfilter(processing.dm);
    
    % Convert values <=1.0 to 1.0 for downstream log2 transformation
    for rows = 1:size(processing.dm, 1)
        for columns = 1:size(processing.dm, 2)
            if processing.dm.(rows)(columns) <= 1
                processing.dm.(rows)(columns) = 1;
            end
        end
    end
    
    % Transform the data using log2 transformation
    processing.dm = log2(processing.dm);
    
    % Filter out genes with variance below 10th percentile
    [~, processing.dm] = genevarfilter(processing.dm);
    
    % Filter out genes with <4rpm across samples
    filter = [];
    processing.dm_low_expression = processing.dm' < 2;
    for genes = 1:size(processing.dm_low_expression, 2)
        if sum(processing.dm_low_expression(:, genes)) == size(processing.dm, 2)
            filter = [filter; genes];
        end
    end
    processing.dm(filter, :) = [];
    
    % Construct clustered dendrograms of gene expression data
    plots.heatmap = dm_clustergram(processing.dm);
    
    % Update title of clustered dendrogram
    if contains(extraction.filenames(:, condition), 'cortical') == 1
        addTitle(plots.heatmap, (strcat('Gene expression of', {' '},...
            ampliseq_config.labels_condition(:, 1), ' neurons')));
    else
        addTitle(plots.heatmap, (strcat('Gene expression of', {' '},...
            ampliseq_config.labels_condition(:, 2), ' neurons')));
    end
    
    % Stratify data based on cell line
    analysis.control_columns = contains(processing.dm.ColNames, '-02');
    analysis.control_data = processing.dm(:, analysis.control_columns);
    
    analysis.patient_columns = contains(processing.dm.ColNames, '-01');
    analysis.patient_data = processing.dm(:, analysis.patient_columns);

    % Conduct a t-test for each gene to identify significant changes
    [analysis.pvalues, analysis.tscores] = mattest(...
        analysis.control_data, analysis.patient_data);
    
    % Compute the p-values of 10,000 permutations
    analysis.pvaluesCorr = mattest(...
        analysis.control_data, analysis.patient_data, 'Permute', 10000);
    
    % Estimate the false discovery rate (FDR) and q-values for each test
    [analysis.pFDR, analysis.qvalues] =  mafdr(analysis.pvaluesCorr);
    
    % Empirically estimate the FDR adjusted p-values using the
    % Benjamini-Hochberg procedure
    analysis.pvaluesBH = mafdr(analysis.pvaluesCorr, 'BHFDR', true);
    
    % Store calculated statistical metrics in a table
    analysis.testResults = table(...
        analysis.tscores.(':')(':'),...
        analysis.pvaluesCorr.(':')(':'),...
        analysis.pFDR.(':')(':'),...
        analysis.qvalues.(':')(':'),...
        analysis.pvaluesBH.(':')(':')...
        );

    % Update the row and column names of the table
    analysis.testResults.Properties.RowNames = rownames(analysis.tscores);
    analysis.testResults.Properties.VariableNames = {...
        't-scores',...
        'p-values',...
        'FDR-adjusted_p-values',...
        'q-values',...
        'BH_FDR-adjusted_p-values'...
        };
    
    % Update title of table
    if contains(extraction.filenames(:, condition), 'cortical') == 1
        analysis.testResults.Properties.Description = char(...
            strcat('Gene expression of', {' '},...
            ampliseq_config.labels_condition(:, 1), ' neurons'));
    else
        analysis.testResults.Properties.Description = char(...
            strcat('Gene expression of', {' '},...
            ampliseq_config.labels_condition(:, 2), ' neurons'));
    end
    
    % Sort the p-values in ascending order
    analysis.testResults = sortrows(analysis.testResults, 2, 'ascend');
    
    % Preview table of results
    head(analysis.testResults)
    
    cd .. % change directory for saving data
    
    % Write table of test results into a .csv(macOS) or .xlsx(Windows) file
    t = analysis.testResults.Properties.RowNames;
    t = [t, table2cell(analysis.testResults)];
    t = [{'Gene',...
        't-scores',...
        'p-values',...
        'FDR-adjusted p-values',...
        'q-values',...
        'BH FDR-adjusted p-values'...
        }; t];
    
    % Save table as a .csv file in macOS
    cell2csv([pwd, '/', analysis.testResults.Properties.Description, '.csv'], t(:, :));
    
    % Save table as a .xlsx file in Windows
    % xlswrite([pwd, '/', analysis.testResults.Properties.Description, '.xlsx'], t(:, :)); 

    cd helper-functions % change directory to enable helper functions
    
    % Construct volcano plots of gene expression
    expression.volcano = mavolcanoplot(...
        analysis.control_data, analysis.patient_data,...
        analysis.pvaluesCorr, 'LogTrans', false);
    
    % Calculate the # of differentially expressed genes
    expression.num_diff_express = expression.volcano.PValues.NRows;
    
    % Identify up- and down-regulated genes
    expression.up_gene_id = find(expression.volcano.FoldChanges > 0);
    expression.down_gene_id = find(expression.volcano.FoldChanges < 0);
    
    % Construct a summary table of gene expression information
    analysis.summary_table(condition, :) = [...
        sum(analysis.pvaluesCorr.(':')(':') < cutoff),... % # of statistically significant genes
        sum(analysis.qvalues.(':')(':') < cutoff),... % # of biologically significant genes
        expression.num_diff_express,... % # of differentially expressed genes
        size(expression.up_gene_id, 1),... % # of up-regulated genes
        size(expression.down_gene_id, 1)... % # of down-regulated genes
        ];
    
    % Convert the summary table into a DataMatrix object and preview summary
    if condition == ampliseq_config.number_of_conditions
        
        % Define column names
        analysis.summary_table = table(...
            analysis.summary_table(:, 1),...
            analysis.summary_table(:, 2),...
            analysis.summary_table(:, 3),...
            analysis.summary_table(:, 4),...
            analysis.summary_table(:, 5),...
            'VariableNames', {...
            'num_stat_sig_genes',...
            'num_bio_sig_genes',...
            'num_degs',...
            'num_up_genes',...
            'num_down_genes'});
        
        % Define row names and update title
        labels = strcat(ampliseq_config.labels_condition, ' neurons');
        if contains(extraction.filenames(:, condition), 'cortical') == 1
            analysis.summary_table.Properties.RowNames = flip(labels');
            analysis.summary_table.Properties.Description = char(...
                strcat('Gene expression of', {' '},...
                ampliseq_config.labels_condition(:, 2), ' neurons'));
        else
            analysis.summary_table.Properties.RowNames = labels';
            analysis.summary_table.Properties.Description = char(...
                strcat('Gene expression of', {' '},...
                ampliseq_config.labels_condition(:, 1), ' neurons'));
        end
        
        % Preview summary table
        head(analysis.summary_table)
        
        cd .. % change directory for saving data
        
        % Write summary table into a .csv(macOS) or .xlsx(Windows) file
        t = analysis.summary_table.Properties.RowNames;
        t = [t, table2cell(analysis.summary_table)];
        t = [{'Neuronal subtype',...
            '# of statistically significant genes',...
            '# of biologically significant genes',...
            '# of differentially expressed genes',...
            '# of up-regulated genes',...
            '# of down-regulated genes'}; t];
        
    % Save table as a .csv file in macOS
    cell2csv([pwd, '/', 'Summary Table', '.csv'], t(:, :));
    
    % Save table as a .xlsx file in Windows
    % xlswrite([pwd, '/', 'Summary Table', '.xlsx'], t(:, :)); 
    
    cd helper-functions % change directory to enable helper functions
    
    end
    
    % Annotate and visualize the ontology of up-regulated genes
    expression.bg.up_genes = fun_geneont(processing.dm.RowNames,...
        expression.volcano.FoldChanges, expression.up_gene_id);
    
    % Annotate and visualize the ontology of down-regulated genes
    expression.bg.down_genes = fun_geneont(processing.dm.RowNames,...
        expression.volcano.FoldChanges, expression.down_gene_id);
    
end

%% Remove unneeded variables from workspace
remove_variables = {'columns', 'condition', 'cutoff', 'file', 'filter',...
    'gene', 'genes', 'id', 'labels', 'low_val', 'rows', 't', 'w'};
clear(remove_variables{1, :})
clear 'remove_variables'
