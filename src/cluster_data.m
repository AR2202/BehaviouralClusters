function cluster_data(filelist, outfilename, varargin)
%%%Annika Rings, 2021
%%%
%%%this function uses k-means clustering and t-SNE on behavioural tracking
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
%%%kmin: minimum k to be used for k-optimized k-means using elbow method;
%%%default: 10
%%%kmax: maximum k to be used for k-optimized k-means using elbow method;
%%%default:50
%%%maxiter: maximum iterations for k-means
%%%framerate: video framerate; default: 25
%%%framesperfly: how many frames per fly the data represents (before
%%%removal of copulation frames); default: 22500
%%%numfeatures: number of features to be used from the dataset; default:
%%%11
%%%numpcs: number of principal components to be used for clustering;
%%%default: 7
%%% (empirical value explaining 99% of variance in the standard 11 feature vector)
%%%replicates: number of replicates for k-means clustering
%morlet_frequencies=[0.5,1,2,4,6,8,10,12]; %8 ~ evenly spaced frequencies,
%the largest being the Nyquist frequency
%dependencies:
%Berman et al 2014 MotionMapper
%https://github.com/gordonberman/MotionMapper

comb = [];
for f = 1:numel(filelist)
    filename = filelist{f};


    arguments = varargin;
    options = struct('both', true, 'female', true, 'k', 10, 'kmin', 1, ...
        'kmax', 50, 'maxiter', 1000, 'framerate', 25, 'framesperfly', 22500, ...
        'numfeatures', 11, 'numpcs', 7, 'replicates', 3, 'perplexity', 50, 'theta', ...
        0.5, 'exaggeration', 5, 'includewavelet', true, ...
        'morletfreq', [0.5, 1, 2, 4, 6, 8, 10, 12]);

    %call the options_resolver function to check optional key-value pair
    %arguments
    [options, ~] = options_resolver(options, arguments, 'cluster_data');

    %setting the values for optional arguments
    both = options.both;
    female = options.female;
    k = options.k;
    kmin = options.kmin;
    kmax = options.kmax;
    maxiter = options.maxiter;
    framerate = options.framerate;
    framesPerFly = options.framesperfly;
    replicates = options.replicates;
    perplexity = options.perplexity;
    theta = options.theta;
    exaggeration = options.exaggeration;
    includewavelet = options.includewavelet;
    morlet_frequencies = options.morletfreq;


    %loading data

    load(filename);

    %check if the file that was loaded contains JAABA data
    %if not, create an empty structure for
    %the JAABA copulation classifier


    if ~exist('allJAABADataFemale.Copulation', 'var')
        allJAABADataFemale.Copulation = [];
    end
    if ~exist('allJAABADataMale.Copulation', 'var')


        allJAABADataMale.Copulation = [];

    end


    %subsetting

    if both
        comb1 = vertcat(allFemaleData, allMaleData);
        jaabadata1 = cell2struct(cellfun(@vertcat, ...
            struct2cell(allJAABADataFemale), ...
            struct2cell(allJAABADataMale), 'uni', 0), ...
            fieldnames(allJAABADataFemale), 1);
    elseif female
        comb1 = allFemaleData;
        jaabadata1 = allJAABADataFemale;
    else
        comb1 = allMaleData;
        jaabadata1 = allJAABADataMale;
    end
    genotypeColumn = repelem(f, length(comb1));
    comb1 = [comb1, transpose(genotypeColumn)];
    comb = vertcat(comb, comb1);
    if exist('jaabadata', 'var')
        jaabadata = cell2struct(cellfun(@vertcat, struct2cell(jaabadata), ...
            struct2cell(jaabadata1), 'uni', 0), fieldnames(jaabadata1), 1);
    else
        jaabadata = jaabadata1;
    end
end
%set numfeatures to be the size of the feature vector, unless a smaller
%number is specified
%note: if a larger number than the total number of features is specified,
%it will take the number of features
numfeatures = min(options.numfeatures, size(comb, 2));
disp('number of features used:');
disp(numfeatures);
numpcs = min(options.numpcs, size(comb, 2));
disp('number of principle components used:');
disp(numpcs);
%scaling

colmin = min(comb(:, 1:numfeatures));
colmax = max(comb(:, 1:numfeatures));
combrescaled = rescale(comb(:, 1:numfeatures), 'InputMin', colmin, ...
    'InputMax', colmax);

%isFemale
isFemale = zeros(length(combrescaled), 1);
if both || female
    isFemale(1:length(allFemaleData)) = 1;
end


%PCA
[PCAcoeff, PCAscores, ~, ~, explained] = pca(combrescaled);

% hierarchical clustering
%very slow - therefore commented out
%hierarch_raw = clusterdata(combrescaled,'Linkage','ward','SaveMemory','on','MAXCLUST',10);

%hierarch_pca = clusterdata(PCAscores,'Linkage','ward','SaveMemory','on','MAXCLUST',10);


%the PCAscores with an explained variance of >1% were used, leading to 7PCs
%which together explain ~99% of the variance

%the PCAscores with an explained variance of >10% would lead to 4PCs
%which together explain ~90% of the variance
%Prepare PCAscores for Morlet wavelet transform
combrescaled = [combrescaled, comb(:, size(comb, 2))];
%PCAscores_reshaped = reshape(PCAscores,[],framesPerFly,numfeatures);

numflies = length(combrescaled) / framesPerFly;

%Morlet Wavelet transforms
%according to Berman et al. 2014
%https://royalsocietypublishing.org/doi/full/10.1098/rsif.2014.0672#d3e789
%requires their MotionMapper package
%https://github.com/gordonberman/MotionMapper


wavelets = zeros(numflies, framesPerFly, length(morlet_frequencies)*numpcs);
amp = zeros(length(morlet_frequencies)*numpcs, framesPerFly);
omega = 5;
samplingrate = 1 / framerate;

for fly = 1:numflies
    %data_old = reshape(PCAscores_reshaped(fly,:,:),size(PCAscores_reshaped,2),size(PCAscores_reshaped,3));
    data = reshape(PCAscores(1 + (fly - 1) * framesPerFly:fly * framesPerFly, :), ...
        framesPerFly, size(PCAscores, 2));
    for i = 1:numpcs
        [amp(length(morlet_frequencies) * (i - 1) + 1:length(morlet_frequencies) * i, :), ~] = ...
            fastWavelet_morlet_convolution_parallel(data(:, i), ...
            morlet_frequencies, omega, samplingrate);
    end
    wavelets(fly, :, :) = transpose(amp);
end
wavelets_reshaped = reshape(permute(wavelets, [2, 1, 3]), ...
    (size(wavelets, 1) * size(wavelets, 2)), size(wavelets, 3));

%remove copulation frames

isCopulationframe = jaabadata.Copulation;
isCopulationframe = ...
    [isCopulationframe; zeros(length(combrescaled) - length(isCopulationframe), 1)];
isCopulationframe_reshaped = ...
    transpose(reshape(isCopulationframe, framesPerFly, []));
for i = 1:numflies
    tmp_data = isCopulationframe_reshaped(:, i);
    tmp_data = movmean(tmp_data, 1250) > 0.5;
    copstart = find(tmp_data, 1, 'first');
    tmp_data(copstart:end) = 1;
    tmp_data(1:copstart) = 0;
    isCopulationframe_reshaped(:, i) = tmp_data;
end
isCopulationframe = reshape(permute(isCopulationframe_reshaped, [2, 1, 3]), ...
    (size(isCopulationframe_reshaped, 1) * size(isCopulationframe_reshaped, 2)), 1);
wavelets_rem_cop = wavelets_reshaped(~isCopulationframe, :);

PCAscores_rem_cop = PCAscores(~isCopulationframe, :);
combrescaled_rem_cop = combrescaled(~isCopulationframe, :);
isFemale_rem_cop = isFemale(~isCopulationframe);
jaabadata_rem_cop = jaabadata;
fields = fieldnames(jaabadata);
for i = 1:numel(fields)
    jaabadata_rem_cop.(fields{i}) = ...
        jaabadata.(fields{i})(~isCopulationframe(1:length(jaabadata.Copulation)));
end
%running KMEANS with different values for k,
%determining the optimum k by elbow method
%second argument is kmax

[KMEANS_opt_pca, ~, ~, K_pca] = ...
    kmeans_opt_AR(PCAscores_rem_cop(:, 1:numpcs), ...
    kmax, 0.95, replicates, maxiter, true, kmin);

[KMEANS_opt_raw, ~, ~, K_raw] = kmeans_opt_AR(combrescaled_rem_cop(:, 1:numfeatures), ...
    kmax, 0.95, replicates, maxiter, true, kmin);

if includewavelet
    [KMEANS_opt_wavelet, ~, ~, K_wavelet] = kmeans_opt_AR(wavelets_rem_cop, ...
        kmax, 0.95, replicates, maxiter, true, kmin);
end

%KMEANS with user-specified k
options = statset('UseParallel', 1);
KMEANS_pca = kmeans(PCAscores_rem_cop(:, 1:numpcs), ...
    k, 'Options', options, 'MaxIter', maxiter);
KMEANS_raw = kmeans(combrescaled_rem_cop(:, 1:numfeatures), ...
    k, 'Options', options, 'MaxIter', maxiter);

if includewavelet
    KMEANS_wavelet = kmeans(wavelets_rem_cop, ...
        k, 'Options', options, 'MaxIter', maxiter);
end


%TSNE
opts.early_exag_coeff = exaggeration;
opts.perplexity = perplexity;
opts.theta = theta;

TSNE = fast_tsne(PCAscores_rem_cop(:, 1:numpcs), opts);
if includewavelet
    TSNE_wavelet = fast_tsne(wavelets_rem_cop, opts);
end

%saving

if includewavelet
    save(outfilename, 'TSNE', 'PCAcoeff', 'PCAscores', ...
        'KMEANS_pca', 'KMEANS_raw', 'comb', 'combrescaled', 'jaabadata', 'isFemale', ...
        'isFemale_rem_cop', 'k', 'KMEANS_opt_pca', 'KMEANS_opt_raw', 'K_raw', ...
        'K_pca', 'explained', 'wavelets', 'wavelets_rem_cop', ...
        'PCAscores_rem_cop', 'combrescaled_rem_cop', 'jaabadata_rem_cop', ...
        'TSNE_wavelet', 'KMEANS_wavelet', 'KMEANS_opt_wavelet', 'K_wavelet')
else
    save(outfilename, 'TSNE', 'PCAcoeff', 'PCAscores', ...
        'KMEANS_pca', 'KMEANS_raw', 'comb', 'combrescaled', 'jaabadata', 'isFemale', ...
        'isFemale_rem_cop', 'k', 'KMEANS_opt_pca', 'KMEANS_opt_raw', 'K_raw', ...
        'K_pca', 'explained', 'wavelets', 'wavelets_rem_cop', ...
        'PCAscores_rem_cop', 'combrescaled_rem_cop', 'jaabadata_rem_cop')
end