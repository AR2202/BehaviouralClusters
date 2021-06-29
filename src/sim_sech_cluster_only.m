filename_a2a2b_a2a2b = 'A2A2B_intraspecific_female.xlsx';
filename_sim13_sim13 = 'sech13females_intraspecific.xlsx';
filename_a2a2b_sech13 = 'a2a2b_female_interspecific.xlsx';
filename_sech13_a2a2b = 'sech13_female_interspecific.xlsx';
filename_nuvea_nuvea = 'nueva_female_intraspecific.xlsx';
filename_praslin_praslin = 'Praslin_female_intraspecific_del_missing.xlsx';
filename_praslin_nuvea = 'Praslin_female_x_nueva_male.xlsx';
filename_nuvea_praslin = 'Nueva_female_x_Praslin_male.xlsx';
filenames = {filename_a2a2b_a2a2b,filename_sim13_sim13,...
    filename_a2a2b_sech13,filename_sech13_a2a2b,filename_nuvea_nuvea,...
    filename_praslin_praslin,filename_praslin_nuvea,filename_nuvea_praslin};

%run data preparation script
clusterdatafiles = {};
disp('Now preparing clusterdata...');
for filenumber = 1:length(filenames)
    genotypelist = filenames{filenumber};
    genotype = strrep(genotypelist,'.xlsx','');
    outputname = strcat(genotype,'_clusterdata.mat');
    clusterdatafiles{end+1} = outputname;
    disp('Now preparing file:')
    disp(genotypelist);
    
    %clustering
    
    %jaaba data not included because there are some missing data - can be
    %updated once the tracking has produced all jaaba data
    find_videos_clustering(genotypelist,genotype,...
        'includeotherfly',false,'includejaabadata',false);
end
%perform clustering with 7 principle components
disp('Now running clustering with 7 PCs...');
cluster_data(clusterdatafiles,'sim_sech_7pcs.mat',...
    'kmin',1, 'kmax',30,'both',false);

%perform clustering with 4 principle components (all those that explain >10%
%of the variance, and together >90%)
disp('Now running clustering with 4 PCs...');
cluster_data(clusterdatafiles,'sim_sech_4pcs.mat',...
    'kmin',1, 'kmax',30,'both',false,'numpcs',4);