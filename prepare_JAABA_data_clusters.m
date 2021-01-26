function prepare_JAABA_data_clusters(filename,idlist,outfilename,varargin)
%check for optional key-value-pair arguments
arguments=varargin;
 options = struct('sex','f','includeOtherFly',true);
%call the options_resolver function to check optional key-value pair
%arguments
[options,~]=options_resolver(options,arguments,'prepare_JAABA_data_clusters');

%setting the values for optional arguments
sex = options.sex;
includeOtherFly = options.includeOtherFly;

otherFlyIds = arrayfun(@(id) otherid(id), idlist);

startdir = pwd;
jaabafolder = strcat(filename,'_JAABA');

%loadJAABADATA
cd(jaabafolder);
scores = dir('*id_corrected.mat');
jaabadata_male = struct();
jaabadata_female = struct();

for i=1:numel(scores)
    scorefilename = scores(i).name;
    scorename = strrep(strrep(scorefilename,'_id_corrected.mat',''),'scores_','');
load(scorefilename);
data_subset=arrayfun(@(id) allScores.postprocessed{id},idlist,'UniformOutput',false);
data_mat=transpose(cell2mat(data_subset));
data_mat_other=[];

if includeOtherFly
   data_subset_other = arrayfun(@(id) allScores.postprocessed{id},otherFlyIds,'UniformOutput',false);
   data_mat_other = transpose(cell2mat(data_subset_other));
end
if sex == 'f'
    jaabadata_female.(scorename)=data_mat;
    jaabadata_male.(scorename)=data_mat_other;
else
    jaabadata_male.(scorename)=data_mat;
    jaabadata_female.(scorename)=data_mat_other;
end


end

cd (startdir);
save(outfilename,'jaabadata_male','jaabadata_female');