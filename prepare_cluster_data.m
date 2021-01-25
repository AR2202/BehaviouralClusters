%Annika Rings 1/2021
%depends on isOdd package and optionsResolver
function prepare_cluster_data(filename,idlist,outfilename,varargin)
%check for optional key-value-pair arguments
arguments=varargin;
 options = struct('sex','f','includeOtherFly',true);
%call the options_resolver function to check optional key-value pair
%arguments
[options,~]=options_resolver(options,arguments,'prepare_cluster_data');

%setting the values for optional arguments
sex = options.sex;
includeOtherFly = options.includeOtherFly;


featfilename = strcat(filename,'-feat.mat');


load(featfilename);

%subsetting the data
data_other_fly=[];
data_selected=feat.data(idlist,:,[1:6,9:13]);
filledmissing = fillmissing(data_selected,'linear');
lengthdata = size(filledmissing,1) *(size(filledmissing,2));
data_reshaped = reshape(data_selected,lengthdata,11);
%find ids of partner fly
otherFlyIds = arrayfun(@(id) otherid(id), idlist);
if includeOtherFly
    data_other_fly = feat.data(otherFlyIds,:,[1:6,9:13]);
    filledmissingOtherFly = fillmissing(data_other_fly,'linear');
    lengthdataOther = size(filledmissingOtherFly,1) *(size(filledmissingOtherFly,2));
    reshaped_other = reshape(data_selected,lengthdataOther,11);
end

if sex == 'f'
    femaleData = data_reshaped;
    maleData = reshaped_other;
else
    maleData = data_reshaped;
    femaleData = reshaped_other;
end

save(outfilename,'maleData','femaleData');

function otherid = otherid(id)
if isOdd(id)
    otherid = id+1;
else
    otherid = id-1;
end
    
