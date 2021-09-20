function cluster_differences(filename, clusteringfilename, wavelet)
%load file
load(filename);
load(clusteringfilename);
%add up frames from different species per cluster
frames_per_cluster = horzcat(sum(absolute, 2), transpose([1:size(absolute, 1)]));
%sort by number uf frames
[~, idx] = sort(frames_per_cluster(:, 1), 'descend');
sorted_frames_per_cluster = frames_per_cluster(idx, :);
%biggest 6 clusters
biggest_clusters = sorted_frames_per_cluster(1:6, 2);
if wavelet
    grouping_var = KMEANS_opt_wavelet(ismember(KMEANS_opt_wavelet(:, 1), biggest_clusters), :);
    features_biggest = combrescaled_rem_cop(ismember(KMEANS_opt_wavelet(:, 1), biggest_clusters), :);
else
    grouping_var = KMEANS_opt_pca(ismember(KMEANS_opt_pca(:, 1), biggest_clusters), :);
    features_biggest = combrescaled_rem_cop(ismember(KMEANS_opt_pca(:, 1), biggest_clusters), :);
end
[p, tbl, stats] = kruskalwallis(features_biggest(:, 1), grouping_var(:, 1));
c = multcompare(stats, 'CType', 'bonferroni', 'alpha', 0.0001);