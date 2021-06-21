function find_videos_clustering(genotypelist,genotype,varargin)
%FIND_VIDEOS_CLUSTERING prepares data from the genotypelist for clustering
%%%Annika Rings, 2021
%%%required arguments:
%%%GENOTYPELIST: a list of flies to be analysed
%%%gentoype: outputname
%%%
%%%optional arguments:
%%%sex: 'm' or 'f', which fly's id's are specified.
%%%includeOtherFly: whether the other fly in the chamber should be included
%%%(even if their id is not specified in genotypelist)
%%%includejaabadata: whether jaabadata should be extracted
%%%framesperfly: number of frames recorded per fly


%check for optional key-value-pair arguments
arguments = varargin;
options = struct('sex','f','includeotherfly',true,...
    'includejaabadata',true,...
    'framesperfly',22500);
%call the options_resolver function to check optional key-value pair
%arguments
[options,~] = options_resolver(options,arguments,'find_videos_clustering');

%setting the values for optional arguments
sex = options.sex;
includeOtherFly = options.includeotherfly;
includeJAABAData = options.includejaabadata;
framesPerFly = options.framesperfly;

includeThisJAABA = true;

outputtable = readtable(genotypelist,'readvariablenames',false);
disp(outputtable);
outputvar2 = arrayfun(@(input) input,outputtable.Var2);
Var4 = arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)),outputvar2);
cellVar4 = arrayfun(@(var2)var2-(~isOdd(var2))+(isOdd(var2)),...
    outputvar2,'uni',false);
outputtable.Var4 = Var4;
startdir = pwd;

dirs = dir();
allMaleData = [];
allFemaleData = [];


for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname,{'.','..'})
        continue;
    end
    
    disp(['Now looking in: ' dirname]);
    cd(dirname);
    videos = cellfun(@(list)dir(char(strcat('*',list))),...
        unique(outputtable.Var1),'UniformOutput',false);
    
    videonames = cellfun(@(struct)arrayfun(@(indiv) indiv.name(indiv.isdir==1,:),...
        struct,'UniformOutput',false),videos,'UniformOutput',false);
    
    videonames = videonames(~cellfun(@isempty,videonames));
    
    
    if size(videonames,2)>0
        for q = 1:size(videonames,1)
            if exist (string(videonames{q}{1}),'dir')
                disp(videonames{q}{1});
                cd(videonames{q}{1});
                cd(videonames{q}{1});
                variablename_video=regexprep(videonames{q}{1},...
                    '(\w+)-(\w+)_Courtship-','');
                disp(variablename_video);
                
                newtable2=outputtable(cellfun(@(x) contains(videonames{q}{1},x),...
                    outputtable.Var1),:);
                
                newtable3=newtable2;
                disp(newtable3);
                
                
                
                strtofind = videonames{q}{1};
                disp(strtofind);
                
                ids = transpose(newtable3.Var2);
                [maleData,femaleData]=prepare_cluster_data(strtofind,ids,...
                    'sex',sex,'includeotherfly',includeOtherFly);
                if mod(length(maleData)+length(femaleData),framesPerFly) ~=0
                    maleData = [];
                    femaleData = [];
                    includeThisJAABA = false;
                end
                allMaleData = vertcat(allMaleData,maleData);
                allFemaleData = vertcat(allFemaleData,femaleData);
                if (includeJAABAData && includeThisJAABA)
                    [jaabadata_male,jaabadata_female] =...
                        prepare_JAABA_data_clusters(strtofind,...
                        ids,'sex',sex,'includeotherfly',includeOtherFly,...
                        'framesperfly',framesPerFly);
                    
                    scorenames_m = fieldnames(jaabadata_male);
                    scorenames_f = fieldnames(jaabadata_female);
                    if exist ('allJAABADataMale','var')
                        scorenames_existing_data = fieldnames(allJAABADataMale);
                        for score = 1:length(scorenames_existing_data)
                            scorename = scorenames_existing_data(score);
                            if ~contains(scorenames_m, scorename)
                                
                                jaabadata_male.(scorename) = zeros(1,framesPerFly);
                            end
                        end
                        for score = 1:length(scorenames_m)
                            scorename = scorenames_m(score);
                            if ~contains(scorenames_existing_data, scorename)
                                
                                allJAABADataMale.(scorename) = ...
                                    zeros(1,...
                                    length(allJAABADataMale.(scorenames_existing_data(1))));
                            end
                        end
                        allJAABADataMale = cell2struct(cellfun(@vertcat,...
                            struct2cell(allJAABADataMale),...
                            struct2cell(jaabadata_male),'uni',0),...
                            fieldnames(jaabadata_male),1);
                    else
                        allJAABADataMale = jaabadata_male;
                        
                        
                    end
                    if exist ('allJAABADataFemale','var')
                        scorenames_existing_data = ...
                            fieldnames(allJAABADataFemale);
                        for score = 1:length(scorenames_existing_data)
                            scorename = scorenames_existing_data(score);
                            if ~contains(scorenames_f, scorename)
                                
                                jaabadata_female.(scorename) = ...
                                    zeros(1,framesPerFly);
                            end
                        end
                        for score = 1:length(scorenames_f)
                            scorename = scorenames_f(score);
                            if ~contains(scorenames_existing_data, scorename)
                                
                                allJAABADataFemale.(scorename) = ...
                                    zeros(1,...
                                    length(allJAABADataFemale.(scorenames_existing_data(1))));
                            end
                        end
                        allJAABADataFemale = cell2struct(cellfun(@vertcat,...
                            struct2cell(allJAABADataFemale),...
                            struct2cell(jaabadata_female),'uni',0),...
                            fieldnames(jaabadata_female),1);
                    else
                        allJAABADataFemale = jaabadata_female;
                        
                        
                    end
                end
            end
        end
        
    end
    cd(startdir);
end


fullfigname = strcat(genotype,'_clusterdata');
datafilename = strcat(fullfigname,'.mat');
if includeJAABAData
    save(datafilename,'allMaleData','allFemaleData',...
        'allJAABADataMale','allJAABADataFemale');
else
    save(datafilename,'allMaleData','allFemaleData');
end
