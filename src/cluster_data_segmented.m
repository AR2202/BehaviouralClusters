function cluster_data_segmented(filelist, outfilename, varargin)
%%%Annika Rings, 2022
%%%
%%%this function uses k-means clustering and t-SNE on behavioural tracking
%%%features
%%%

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


comb = [];
for f = 1:numel(filelist)
    filename = filelist{f};


    arguments = varargin;
    options = struct('both', true, 'female', true, 'k', 10, 'kmin', 1, ...
        'kmax', 50, 'maxiter', 1000, 'framerate', 25, ...
        'framesperfly', 22500, ...
        'numfeatures', 11, 'numpcs', 28, 'replicates', 3, ...
        'perplexity', 50, 'theta', 0.5, ...
        'exaggeration', 5, ...
        'maxchangepts', 300, 'avg_pts',5, 'downsample_intv',5);
%call the options_resolver function to check optional key-value pair
    %arguments
    [options, ~] = options_resolver(options, arguments, 'cluster_data_segmented');

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
    maxchangepts = options.maxchangepts;
    avg_pts = options.avg_pts;
    downsample_intv = options.downsample_intv;
    numpcs = options.numpcs;


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

%isFemale
isFemale = zeros(length(comb), 1);
if both || female
    isFemale(1:length(allFemaleData)) = 1;
end
%TSNE options
opts.early_exag_coeff = exaggeration;
opts.perplexity = perplexity;
opts.theta = theta;
%segment data
[segmented, isFemale_segmented] = segment_cluster_data(comb, isFemale, framesPerFly, ...
    numfeatures, maxchangepts, avg_pts,downsample_intv);
%cluster data
[PCAscores, explained, KMEANS_pca, TSNE] = cluster_segmented(segmented(:,1:end-4),...
    numpcs, k, opts);

%save data to file
 save(outfilename, 'TSNE',  'PCAscores', ...
        'KMEANS_pca',  'comb',  'jaabadata', 'isFemale', ...
         'k', 'segmented', 'isFemale_segmented', ...
         'explained')