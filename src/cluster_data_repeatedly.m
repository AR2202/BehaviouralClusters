function cluster_data_repeatedly(filelist,outfilename,varargin)
%%%Annika Rings, 2021
%%%
%%%this function uses k-means clustering repeatedly
%%%features
%%%
%%%removes copulation frames based on the copulation JAABA classifier
%%%
%%required arguments:
%%%filelist: cell array of the names of inputdata file,
%%%each which is expected to contain
%%%allFemaleData, allMaleData, allJAABADataFemale, allJAABADataMale
%%%as prepared by find_videos_clustering
%%%
%%% optional arguments:
%%%both: whether male and female data should be used; default: true
%%%female: if both is false, whether female data should be used; default:
%%%false
%%%k: the k for the fixed-k k-means default: 10

%%%maxiter: maximum iterations for k-means
%%%framerate: video framerate; default: 25
%%%framesperfly: how many frames per fly the data represents (before
%%%removal of copulation frames); default: 22500
%%%numfeatures: number of features to be used from the dataset; default:
%%%11
%%%numpcs: number of principal components to be used for clustering;
%%%default: 7
%%% (empirical value explaining 99% of variance in the standard 11 feature vector)
%%%repeats: number of replicates for k-means clustering
%%%subsamplesize: number of frames to be used per clustering


comb = [];
for f = 1:numel(filelist)
    filename = filelist{f};
    
    
    arguments = varargin;
    options = struct('both',true,'female',true,'k',20,'maxiter',1000,...
        'framerate',25,'framesperfly',22500,...
        'numfeatures',11,'numpcs',7,'repeats',30,'subsamplesize',22500);
    
    %call the options_resolver function to check optional key-value pair
    %arguments
    [options,~] = options_resolver(options,arguments,'cluster_data');
    
    %setting the values for optional arguments
    both = options.both;
    female = options.female;
    k = options.k;
    maxiter = options.maxiter;
    framerate = options.framerate;
    framesPerFly = options.framesperfly;
    repeats = options.repeats;
    subsamplesize = options.subsamplesize;
    
    
    
    %loading data
    
    load(filename);
    
    %check if the file that was loaded contains JAABA data
    %if not, create an empty structure for
    %the JAABA copulation classifier
    
    
    if ~exist('allJAABADataFemale.Copulation','var')
        allJAABADataFemale.Copulation = [];
    end
    if ~exist('allJAABADataMale.Copulation','var')
        
        
        allJAABADataMale.Copulation = [];
        
    end
    
    
    %subsetting
    
    if both
        comb1 = vertcat(allFemaleData,allMaleData);
        jaabadata1 = cell2struct(cellfun(@vertcat,...
            struct2cell(allJAABADataFemale),...
            struct2cell(allJAABADataMale),'uni',0),...
            fieldnames(allJAABADataFemale),1);
    elseif female
        comb1 = allFemaleData;
        jaabadata1 = allJAABADataFemale;
    else
        comb1 = allMaleData;
        jaabadata1 = allJAABADataMale;
    end
    genotypeColumn = repelem(f, length(comb1));
    comb1 = [comb1 transpose(genotypeColumn)];
    comb = vertcat(comb,comb1);
    if exist ('jaabadata','var')
        jaabadata = cell2struct(cellfun(@vertcat,struct2cell(jaabadata),...
            struct2cell(jaabadata1),'uni',0),fieldnames(jaabadata1),1);
    else
        jaabadata=jaabadata1;
    end
end
%set numfeatures to be the size of the feature vector, unless a smaller
%number is specified
%note: if a larger number than the total number of features is specified,
%it will take the number of features
numfeatures = min(options.numfeatures,size(comb,2));
disp('number of features used:');
disp(numfeatures);
numpcs = min(options.numpcs,size(comb,2));
disp('number of principle components used:');
disp(numpcs);
%scaling

colmin = min(comb(:,1:numfeatures));
colmax = max(comb(:,1:numfeatures));
combrescaled = rescale(comb(:,1:numfeatures),'InputMin',colmin,...
    'InputMax',colmax);

%isFemale
isFemale = zeros(length(combrescaled),1);
if both || female
    isFemale(1:length(allFemaleData))=1;
end


%PCA
[PCAcoeff,PCAscores,~,~,explained]=pca(combrescaled);


%Prepare PCAscores for Morlet wavelet transform
combrescaled = [combrescaled comb(:,size(comb,2))];
%PCAscores_reshaped = reshape(PCAscores,[],framesPerFly,numfeatures);

numflies = length(combrescaled)/framesPerFly;




%remove copulation frames

isCopulationframe = jaabadata.Copulation;
isCopulationframe = ...
    [isCopulationframe; zeros( length(combrescaled) - length(isCopulationframe),1)];
isCopulationframe_reshaped = ...
    transpose(reshape(isCopulationframe,framesPerFly,[]));
for i = 1:numflies
    tmp_data = isCopulationframe_reshaped(:,i);
    tmp_data = movmean(tmp_data,1250)>0.5;
    copstart = find(tmp_data, 1, 'first');
    tmp_data(copstart:end) = 1;
    tmp_data(1:copstart) = 0;
    isCopulationframe_reshaped(:,i)=tmp_data;
end
isCopulationframe = reshape(permute(isCopulationframe_reshaped, [2 1 3]),...
    (size(isCopulationframe_reshaped,1)*size(isCopulationframe_reshaped,2)),1);


PCAscores_rem_cop = PCAscores(~isCopulationframe,:);
combrescaled_rem_cop = combrescaled(~isCopulationframe,:);
isFemale_rem_cop = isFemale(~isCopulationframe);
jaabadata_rem_cop = jaabadata;
fields = fieldnames(jaabadata);
for i = 1:numel(fields)
    jaabadata_rem_cop.(fields{i}) = ...
        jaabadata.(fields{i})(~isCopulationframe(1:length(jaabadata.Copulation)));
end

%append row number to PCAscores to keep track of which row was randomly
%selected
PCAscores_rownumber_appended = [PCAscores_rem_cop transpose([1:length(PCAscores_rem_cop)])];
genotypes = unique(combrescaled_rem_cop(:,size(combrescaled_rem_cop,2)));
numgenotypes = length(genotypes);
KMEANS_pca_rep = zeros(subsamplesize*numgenotypes,repeats);
PCAscores_subsampled = zeros(subsamplesize*numgenotypes,size(PCAscores_rownumber_appended,2));
PCAscores_subsampled_rep = zeros(subsamplesize*numgenotypes,size(PCAscores_rownumber_appended,2),repeats);
%KMEANS with user-specified k  repeats
for i=1:repeats
    %random selection of data
    for g = 1:numgenotypes
    genotype = genotypes(g);
    PCAscores_genotype = ...
        PCAscores_rownumber_appended(combrescaled_rem_cop(:,size(combrescaled_rem_cop,2)) == genotype,:);
    PCAscores_subsampled((g-1)*subsamplesize+1:g*subsamplesize,:) = ...
        datasample(PCAscores_genotype,subsamplesize,1);
    end
options = statset('UseParallel',1);
KMEANS_pca = kmeans(PCAscores_subsampled(:,1:numpcs),...
    k,'Options',options,'MaxIter',maxiter);
KMEANS_pca_rep(:,i) = KMEANS_pca;
PCAscores_subsampled_rep(:,:,i)=PCAscores_subsampled;
end





%saving


    save(outfilename,'PCAcoeff','PCAscores', 'PCAscores_subsampled_rep',...
        'KMEANS_pca_rep','comb','combrescaled','jaabadata','isFemale',...
        'isFemale_rem_cop','k','explained',...
        'PCAscores_rem_cop','combrescaled_rem_cop','jaabadata_rem_cop')
