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
filename_sim13_sim13 = 'sech13females_intraspecific.xlsx';
filename_a2a2b_sech13 = 'a2a2b_female_interspecific.xlsx';
filename_sech13_a2a2b = 'sech13_female_interspecific.xlsx';
filename_nuvea_nuvea = 'nueva_female_intraspecific.xlsx';
filename_praslin_praslin = 'Praslin_female_intraspecific.xlsx';
filename_praslin_nuvea = 'Praslin_female_x_nueva_male.xlsx';
filename_nuvea_praslin = 'Nueva_female_x_Praslin_male.xlsx';
filenames = {filename_a2a2b_a2a2b,filename_sim13_sim13,...
    filename_a2a2b_sech13,filename_sech13_a2a2b,filename_nuvea_nuvea,...
    filename_praslin_praslin,filename_praslin_nuvea,filename_nuvea_praslin};

cd (datapath);
%run the pausing function
pausing();
%chasing
run_fraction('chasing',11,'cutoff',(5*pi/6),'below',true,...
    'wingextonly',false,'additional',12,...
    'additional_cutoff',(pi/6),'additional_below',true);
%shoving
run_fraction('shoving',11,'cutoff',(5*pi/6),'wingextonly',false,...
    'additional',12,'additional_cutoff',(pi/6),'additional_below',true);

%run data preparation script
clusterdatafiles = {};
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
        'includeotherfly',false,'includejaabadata',false);
end

    cluster_data(clusterdatafiles,'sim_sech.mat',...
        'kmin',5, 'kmax',30,'both',false);
