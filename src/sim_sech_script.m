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

%run data preparation script
cd (datapath);
for filenumber = 1:length(filenames)
    genotypelist = filenames{filenumber};
    genotype = strrep(genotypelist,'.xlsx','');
    disp('Now preparing file:')
    disp(genotypelist);
    
    find_videos_clustering(genotypelist,genotype,'includeotherfly',false,'includejaabadata',false)
end

    

