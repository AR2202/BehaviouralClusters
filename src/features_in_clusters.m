function [pvalues, times_average, significant_cluster_features] = features_in_clusters(PCAscores_subsampled_rep, KMEANS_clusternumbers, significantClusters, numfeatures)
features = PCAscores_subsampled_rep(:, end-numfeatures:end-1, :);
repeats = size(PCAscores_subsampled_rep, 3);
samples = size(PCAscores_subsampled_rep, 1);
numsigclusters = size(significantClusters, 2);
pvalues = zeros(numfeatures, numsigclusters);
times_average = zeros(numfeatures, numsigclusters);
for f = 1:numfeatures
    feature = reshape(features(:, f, :), samples, repeats);
    means_all_clusters = mean(feature);
    for c = 1:numsigclusters

        clusternumber = significantClusters(c);
        clusterdata = zeros(1, repeats);
        for r = 1:repeats
            feature_cluster_run = feature(KMEANS_clusternumbers(:, r) == clusternumber, r);
            clusterdata(r) = mean(feature_cluster_run);
        end
        pvalues(f, c) = ranksum(means_all_clusters, clusterdata);
        times_average(f, c) = mean(clusterdata) / mean(means_all_clusters);

    end
end
%Bonferroni correction for number of features and clusters
pvalues = pvalues * (numfeatures * numsigclusters);
significant_cluster_features = pvalues < 0.0001;
