%Annika Rings 1/2021
%depends on isOdd package and optionsResolver
function [maleData,femaleData]=prepare_cluster_data(filename,idlist,varargin)
%check for optional key-value-pair arguments
arguments=varargin;
options = struct('sex','f','includeotherfly',true);
%call the options_resolver function to check optional key-value pair
%arguments
[options,~]=options_resolver(options,arguments,'prepare_cluster_data');

%setting the values for optional arguments
sex = options.sex;
includeOtherFly = options.includeotherfly;


featfilename = strcat(filename,'-feat.mat');


load(featfilename);

%subsetting the data
data_other_fly=[];
data_selected=feat.data(idlist,:,[1:6,9:13]);
filledmissing = fillmissing(data_selected,'linear');
lengthdata = size(filledmissing,1) *(size(filledmissing,2));
data_reshaped = reshape(permute(filledmissing,[2 1 3]),lengthdata,11);
%find ids of partner fly
otherFlyIds = arrayfun(@(id) otherid(id), idlist);
if includeOtherFly
    data_other_fly = feat.data(otherFlyIds,:,[1:6,9:13]);
    filledmissingOtherFly = fillmissing(data_other_fly,'linear');
    lengthdataOther = size(filledmissingOtherFly,1) *(size(filledmissingOtherFly,2));
    reshaped_other = reshape(permute(filledmissingOtherFly,[2 1 3]),lengthdataOther,11);
else
    reshaped_other =[];
end

if sex == 'f'
    femaleData = data_reshaped;
    maleData = reshaped_other;
else
    maleData = data_reshaped;
    femaleData = reshaped_other;
end




