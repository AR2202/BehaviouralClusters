%Annika Rings 2021

%This is a script which runs the Clustering analysis on a specific dataset
%of simulans and secheillia data
%This is not a generic reusable script but can be used as a template

%paths to scripts
path_to_Clustering ='/home/goodwintracking/AnnikasClusteringScripts/';
path_to_fast_tsne = '/home/goodwintracking/FIt-SNE-master/';
path_to_tracking = '/home/goodwintracking/AnnikasTrackingScripts/';
addpath(genpath(path_to_Clustering));
addpath(genpath(path_to_fast_tsne));
addpath(genpath(path_to_tracking))

%paths and names to files
datapath = '/mnt/LocalData/Annika_Deniz_Tracking/';
filename_a2a2b_a2a2b = 'A2A2B_intraspecific_female.xlsx';
filename_sech13_sech13 = 'sech13females_intraspecific.xlsx';
filename_a2a2b_sech13 = 'a2a2b_female_interspecific.xlsx';
filename_sech13_a2a2b = 'sech13_female_interspecific.xlsx';
filename_nuvea_nuvea = 'nueva_female_intraspecific.xlsx';
filename_praslin_praslin = 'Praslin_female_intraspecific_del_missing.xlsx';
filename_praslin_nuvea = 'Praslin_female_x_nueva_male.xlsx';
filename_nuvea_praslin = 'Nueva_female_x_Praslin_male.xlsx';
filename_praslin_a2a2b = 'Praslin_female_x_a2a2b_male.xlsx';
filename_a2a2b_praslin = 'A2A2B_female_x_Praslin_male.xlsx';
filenames = {filename_a2a2b_a2a2b,filename_sech13_sech13,...
    filename_a2a2b_sech13,filename_sech13_a2a2b,filename_nuvea_nuvea,...
    filename_praslin_praslin,filename_praslin_nuvea,...
    filename_nuvea_praslin,filename_a2a2b_praslin,filename_praslin_a2a2b};
%separating data into different the sets that should be compared
filenames_a2a2b_sech = {filename_a2a2b_a2a2b,filename_sech13_sech13,...
    filename_a2a2b_sech13,filename_sech13_a2a2b};
filenames_nuvea_praslin = {filename_nuvea_nuvea,...
    filename_praslin_praslin,filename_praslin_nuvea,...
    filename_nuvea_praslin};
filenames_praslin_a2a2b = {filename_a2a2b_praslin,filename_praslin_a2a2b};

cd (datapath);
%run the pausing function
disp('Now running pausing...');

pausing_smaller_chamber();
%chasing
disp('Now running chasing...');
run_fraction('chasing',11,'cutoff',(5*pi/6),'below',true,...
    'wingextonly',false,'additional',12,...
    'additional_cutoff',(pi/6),'additional_below',true);
%shoving
disp('Now running shoving...');
run_fraction('shoving',11,'cutoff',(5*pi/6),'wingextonly',false,...
    'additional',12,'additional_cutoff',(pi/6),'additional_below',true);

%run data preparation script
clusterdatafiles = {};
clusterdatafiles_a2a2b_sech = {};
clusterdatafiles_nuvea_praslin = {};
clusterdatafiles_a2a2b_praslin ={};

disp('Now preparing clusterdata...');
for filenumber = 1:length(filenames)
    genotypelist = filenames{filenumber};
    genotype = strrep(genotypelist,'.xlsx','');
    outputname = strcat(genotype,'_clusterdata.mat');
    clusterdatafiles{end+1} = outputname;
    disp('Now preparing file:')
    disp(genotypelist);
    %pausing
    find_videos_pausing(genotypelist,genotype);
    %chasing
    find_videos_fraction(genotypelist,'fraction','chasing',genotype);
    %shoving
    find_videos_fraction(genotypelist,'fraction','shoving',genotype);
    %clustering
    
    %jaaba data not included because there are some missing data - can be
    %updated once the tracking has produced all jaaba data
    find_videos_clustering(genotypelist,genotype,...
        'includeotherfly',false);
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
%creating the tSNEplots 7PCs
disp('Now creating tSNEplots...');
tSNEplots('sim_sech_7pcs.mat','sim_sech_7pcs',false,true,false)
%creating the tSNEplots 7PCs from wavelet transformed data
tSNEplots('sim_sech_7pcs.mat','sim_sech_7pcs_wavelet',true,true,false)
%creating the tSNEplots 4PCs
tSNEplots('sim_sech_4pcs.mat','sim_sech_4pcs',false,true,false)
%creating the tSNEplots 4PCs from wavelet transformed data
tSNEplots('sim_sech_4pcs.mat','sim_sech_4pcs_wavelet',true,true,false)

%plotting the features for each cluster
disp('Now analysing clustermarkers...');
%7PCs
clustermarkers('sim_sech_7pcs.mat','sim_sech_7pcs',false,true)
%7PCs wavelet
clustermarkers('sim_sech_7pcs.mat','sim_sech_7pcs_wavelet',true,true)
%4PCs
clustermarkers('sim_sech_4pcs.mat','sim_sech_4pcs',false,true)
%4PCs wavelet
clustermarkers('sim_sech_4pcs.mat','sim_sech_4pcs_wavelet',true,true)
%clustermembers
disp('Now analysing clustermembers...');
%7PCs
clustermembers('sim_sech_7pcs.mat','sim_sech_7pcs',false,true);
%4PCs
clustermembers('sim_sech_4pcs.mat','sim_sech_4pcs',false,true);
%7PCs wavelet
clustermembers('sim_sech_7pcs.mat','sim_sech_7pcs_wavelet',true,true);
%4PCs wavelet
clustermembers('sim_sech_4pcs.mat','sim_sech_4pcs_wavelet',true,true);
close all;

%clustering dataset a2a2b sech13
disp('Now preparing clusterdata dataset a2a2b sech13...');
for filenumber = 1:length(filenames_a2a2b_sech)
    genotypelist = filenames_a2a2b_sech{filenumber};
    genotype = strrep(genotypelist,'.xlsx','');
    outputname = strcat(genotype,'_clusterdata.mat');
    clusterdatafiles_a2a2b_sech{end+1} = outputname;
    
end
%perform clustering with 7 principle components
disp('Now running clustering on dataset a2a2b sech13 with 7 PCs...');
cluster_data(clusterdatafiles_a2a2b_sech,'a2a2b_sech_7pcs.mat',...
    'kmin',1, 'kmax',30,'both',false);

%perform clustering with 4 principle components (all those that explain >10%
%of the variance, and together >90%)
disp('Now running clustering on dataset a2a2b sech13 with 4 PCs...');
cluster_data(clusterdatafiles_a2a2b_sech,'a2a2b_sech_4pcs.mat',...
    'kmin',1, 'kmax',30,'both',false,'numpcs',4);
%creating the tSNEplots 7PCs
disp('Now creating tSNEplots dataset a2a2b sech13...');
tSNEplots('a2a2b_sech_7pcs.mat','a2a2b_sech_7pcs',false,true,false);
%creating the tSNEplots 7PCs from wavelet transformed data
tSNEplots('a2a2b_sech_7pcs.mat','a2a2b_sech_7pcs_wavelet',true,true,false);
%creating the tSNEplots 4PCs
tSNEplots('a2a2b_sech_4pcs.mat','a2a2b_sech_4pcs',false,true,false);
%creating the tSNEplots 4PCs from wavelet transformed data
tSNEplots('a2a2b_sech_4pcs.mat','a2a2b_sech_4pcs_wavelet',true,true,false);

%plotting the features for each cluster
disp('Now analysing clustermarkers a2a2b sech...');
%7PCs
clustermarkers('a2a2b_sech_7pcs.mat','a2a2b_sech_7pcs',false,true);
%7PCs wavelet
clustermarkers('a2a2b_sech_7pcs.mat','a2a2b_sech_7pcs_wavelet',true,true);
%4PCs
clustermarkers('a2a2b_sech_4pcs.mat','a2a2b_sech_4pcs',false,true);
%4PCs wavelet
clustermarkers('a2a2b_sech_4pcs.mat','a2a2b_sech_4pcs_wavelet',true,true);
%clustermembers
disp('Now analysing clustermembers...');
%7PCs
clustermembers('a2a2b_sech_7pcs.mat','a2a2b_sech_7pcs',false,true);
%4PCs
clustermembers('a2a2b_sech_4pcs.mat','sim_sech_4pcs',false,true);
%7PCs wavelet
clustermembers('a2a2b_sech_7pcs.mat','a2a2b_sech_7pcs_wavelet',true,true);
%4PCs wavelet
clustermembers('a2a2b_sech_4pcs.mat','a2a2b_sech_4pcs_wavelet',true,true);
close all;

%clustering dataset nuvea praslin
disp('Now preparing clusterdata dataset nuvea praslin...');
for filenumber = 1:length(filenames_nuvea_praslin)
    genotypelist = filenames_nuvea_praslin{filenumber};
    genotype = strrep(genotypelist,'.xlsx','');
    outputname = strcat(genotype,'_clusterdata.mat');
    clusterdatafiles_nuvea_praslin{end+1} = outputname;
    
end
%perform clustering with 7 principle components
disp('Now running clustering on dataset nuvea praslin with 7 PCs...');
cluster_data(clusterdatafiles_nuvea_praslin,'nuvea_praslin_7pcs.mat',...
    'kmin',1, 'kmax',30,'both',false);

%perform clustering with 4 principle components (all those that explain >10%
%of the variance, and together >90%)
disp('Now running clustering on dataset nuvea praslin with 4 PCs...');
cluster_data(clusterdatafiles_nuvea_praslin,'nuvea_praslin_4pcs.mat',...
    'kmin',1, 'kmax',30,'both',false,'numpcs',4);
%creating the tSNEplots 7PCs
disp('Now creating tSNEplots dataset nuvea praslin...');
tSNEplots('nuvea_praslin_7pcs.mat','nuvea_praslin_7pcs',false,true,false);
%creating the tSNEplots 7PCs from wavelet transformed data
tSNEplots('nuvea_praslin_7pcs.mat','nuvea_praslin_7pcs_wavelet',true,true,false);
%creating the tSNEplots 4PCs
tSNEplots('nuvea_praslin_4pcs.mat','nuvea_praslin_4pcs',false,true,false);
%creating the tSNEplots 4PCs from wavelet transformed data
tSNEplots('nuvea_praslin_4pcs.mat','nuvea_praslin_4pcs_wavelet',true,true,false);

%plotting the features for each cluster
disp('Now analysing clustermarkers nuvea praslin...');
%7PCs
clustermarkers('nuvea_praslin_7pcs.mat','nuvea_praslin_7pcs',false,true);
%7PCs wavelet
clustermarkers('nuvea_praslin_7pcs.mat','nuvea_praslin_7pcs_wavelet',true,true);
%4PCs
clustermarkers('nuvea_praslin_4pcs.mat','nuvea_praslin_4pcs',false,true);
%4PCs wavelet
clustermarkers('nuvea_praslin_4pcs.mat','nuvea_praslin_4pcs_wavelet',true,true);
%clustermembers
disp('Now analysing clustermembers...');
%7PCs
clustermembers('nuvea_praslin_7pcs.mat','nuvea_praslin_7pcs',false,true);
%4PCs
clustermembers('nuvea_praslin_4pcs.mat','nuvea_praslin_4pcs',false,true);
%7PCs wavelet
clustermembers('nuvea_praslin_7pcs.mat','nuvea_praslin_7pcs_wavelet',true,true);
%4PCs wavelet
clustermembers('nuvea_praslin_4pcs.mat','nuvea_praslin_4pcs_wavelet',true,true);
close all;

%clustering dataset a2a2b praslin
disp('Now preparing clusterdata dataset a2a2b prasling...');
for filenumber = 1:length(filenames_praslin_a2a2b)
    genotypelist = filenames_praslin_a2a2b{filenumber};
    genotype = strrep(genotypelist,'.xlsx','');
    outputname = strcat(genotype,'_clusterdata.mat');
    clusterdatafiles_a2a2b_praslin{end+1} = outputname;
    
end
%perform clustering with 7 principle components
disp('Now running clustering on dataset a2a2b praslin with 7 PCs...');
cluster_data(clusterdatafiles_a2a2b_praslin,'a2a2b_praslin_7pcs.mat',...
    'kmin',1, 'kmax',30,'both',false);

%perform clustering with 4 principle components (all those that explain >10%
%of the variance, and together >90%)
disp('Now running clustering on dataset a2a2b praslin with 4 PCs...');
cluster_data(clusterdatafiles_a2a2b_praslin,'a2a2b_praslin_4pcs.mat',...
    'kmin',1, 'kmax',30,'both',false,'numpcs',4);
%creating the tSNEplots 7PCs
disp('Now creating tSNEplots dataset a2a2b praslin...');
tSNEplots('a2a2b_praslin_7pcs.mat','a2a2b_praslin_7pcs',false,true,false);
%creating the tSNEplots 7PCs from wavelet transformed data
tSNEplots('a2a2b_praslin_7pcs.mat','a2a2b_praslin_7pcs_wavelet',true,true,false);
%creating the tSNEplots 4PCs
tSNEplots('a2a2b_praslin_4pcs.mat','a2a2b_praslin_4pcs',false,true,false);
%creating the tSNEplots 4PCs from wavelet transformed data
tSNEplots('a2a2b_praslin_4pcs.mat','a2a2b_praslin_4pcs_wavelet',true,true,false);

%plotting the features for each cluster
disp('Now analysing clustermarkers a2a2b praslin...');
%7PCs
clustermarkers('a2a2b_praslin_7pcs.mat','a2a2b_praslin_7pcs',false,true);
%7PCs wavelet
clustermarkers('a2a2b_praslin_7pcs.mat','a2a2b_praslin_7pcs_wavelet',true,true);
%4PCs
clustermarkers('a2a2b_praslin_4pcs.mat','a2a2b_praslin_4pcs',false,true);
%4PCs wavelet
clustermarkers('a2a2b_praslin_4pcs.mat','a2a2b_praslin_4pcs_wavelet',true,true);
%clustermembers
disp('Now analysing clustermembers...');
%7PCs
clustermembers('a2a2b_praslin_7pcs.mat','a2a2b_praslin_7pcs',false,true);
%4PCs
clustermembers('a2a2b_praslin_4pcs.mat','a2a2b_praslin_4pcs',false,true);
%7PCs wavelet
clustermembers('a2a2b_praslin_7pcs.mat','a2a2b_praslin_7pcs_wavelet',true,true);
%4PCs wavelet
clustermembers('a2a2b_praslin_4pcs.mat','a2a2b_praslin_4pcs_wavelet',true,true);
close all;
