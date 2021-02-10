function cluster_data(filename,outfilename,varargin)
arguments=varargin;
 options = struct('both',true,'female',true,'k',10);
%call the options_resolver function to check optional key-value pair
%arguments
[options,~]=options_resolver(options,arguments,'cluster_data');

%setting the values for optional arguments
both = options.both;
female = options.female;
k=options.k;
%loading data

load(filename);
%subsetting

if both
    comb = vertcat(allFemaleData,allMaleData);
    jaabadata=cell2struct(cellfun(@vertcat,struct2cell(allJAABADataFemale),struct2cell(allJAABADataMale),'uni',0),fieldnames(allJAABADataFemale),1);
elseif female
    comb = allFemaleData;
    jaabadata=allJAABADataFemale;
else
    comb = allMaleData;
    jaabadata=allJAABADataMale;  
end
%scaling

colmin = min(comb(:,1:11));
colmax = max(comb(:,1:11));
combrescaled = rescale(comb,'InputMin',colmin,'InputMax',colmax);

%saving

%TSNE
TSNE=fast_tsne(combrescaled);
TSNE_unscaled=fast_tsne(comb);

%PCA
[PCAcoeff,PCAscores,~]=pca(combrescaled);
% hierarchical clustering
%very slow - thereofre commented out
%hierarch_raw = clusterdata(combrescaled,'Linkage','ward','SaveMemory','on','MAXCLUST',10);

%hierarch_pca = clusterdata(PCAscores,'Linkage','ward','SaveMemory','on','MAXCLUST',10);



%KMEANS
KMEANS_pca=kmeans(PCAscores,k);
KMEANS_raw=kmeans(combrescaled,k);
isFemale=zeros(length(combrescaled),1);
if both || female
    isFemale(1:length(allFemaleData))=1;
end


save(outfilename,'TSNE','TSNE_unscaled','PCAcoeff','PCAscores','KMEANS_pca','KMEANS_raw','comb','combrescaled','jaabadata','isFemale','k')