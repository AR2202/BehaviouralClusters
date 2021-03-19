function cluster_data(filename,outfilename,varargin)
%dependencies:
%Berman et al 2014 MotionMapper
%https://github.com/gordonberman/MotionMapper

arguments=varargin;
options = struct('both',true,'female',true,'k',10,'kmin',1,'kmax',50,'maxiter',1000,'framerate',25,'framesperfly',22500);
%call the options_resolver function to check optional key-value pair
%arguments
[options,~]=options_resolver(options,arguments,'cluster_data');

%setting the values for optional arguments
both = options.both;
female = options.female;
k=options.k;
kmin=options.kmin;

kmax=options.kmax;
maxiter=options.maxiter;
framerate = options.framerate;
framesPerFly = options.framesperfly;
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




%PCA
[PCAcoeff,PCAscores,~,~,explained]=pca(combrescaled);
% hierarchical clustering
%very slow - thereofre commented out
%hierarch_raw = clusterdata(combrescaled,'Linkage','ward','SaveMemory','on','MAXCLUST',10);

%hierarch_pca = clusterdata(PCAscores,'Linkage','ward','SaveMemory','on','MAXCLUST',10);


%the PCAscores with an explained variance of >1% were used, leading to 7PCs
%which together explain ~99% of the variance

%Prepare PCAscores for Morlet wavelet transform

PCAscores_reshaped = reshape(PCAscores,[],framesPerFly,11);
wavelets = zeros(size(PCAscores_reshaped,1),size(PCAscores_reshaped,2),42);
numflies = size(PCAscores_reshaped,1);

%Morlet Wavelet transforms
%according to Berman et al. 2014
%https://royalsocietypublishing.org/doi/full/10.1098/rsif.2014.0672#d3e789
%requires their MotionMapper package
%https://github.com/gordonberman/MotionMapper
morlet_frequencies=[2,4,6,8,10,12]; %6 evenly spaced frequencies,
%the largest being the Nyquis frequency
amp = zeros(42,length(PCAscores_reshaped));
omega = 5;
samplingrate = 1/framerate;

for fly = 1:numflies
    data = reshape(PCAscores_reshaped(fly,:,:),size(PCAscores_reshaped,2),size(PCAscores_reshaped,3));
    for i=1:7
        [amp(6*(i-1)+1:6*i,:),~] = fastWavelet_morlet_convolution_parallel(data(:,i),morlet_frequencies,omega,samplingrate);
    end
    wavelets(fly,:,:) = transpose(amp);
end
wavelets_reshaped = reshape(wavelets,(size(wavelets,1)*size(wavelets,2)),size(wavelets,3));
%running KMEANS with different values for k,
%determining the optimum k by elbow method
%second argument is kmax

[KMEANS_opt_pca,~,~,K_pca]=kmeans_opt_AR(PCAscores(:,1:7),kmax,0.95,3,maxiter,true,kmin);
[KMEANS_opt_raw,~,~,K_raw]=kmeans_opt_AR(combrescaled,kmax,0.95,3,maxiter,true,kmin);

%KMEANS with user-specified k
options = statset('UseParallel',1);
KMEANS_pca=kmeans(PCAscores(:,1:7),k,'Options',options,'MaxIter',maxiter);
KMEANS_raw=kmeans(combrescaled,k,'Options',options,'MaxIter',maxiter);
KMEANS_wavelet=kmeans(wavelets_reshaped,k,'Options',options,'MaxIter',maxiter);

isFemale=zeros(length(combrescaled),1);
if both || female
    isFemale(1:length(allFemaleData))=1;
end

%TSNE
TSNE=fast_tsne(combrescaled);
TSNE_wavelet=fast_tsne(wavelets_reshaped);

%saving


save(outfilename,'TSNE','TSNE_wavelet','PCAcoeff','PCAscores','KMEANS_pca','KMEANS_raw','comb','combrescaled','jaabadata','isFemale','k','KMEANS_opt_pca','KMEANS_opt_raw','K_raw','K_pca','explained','KMEANS_wavelet','wavelets')