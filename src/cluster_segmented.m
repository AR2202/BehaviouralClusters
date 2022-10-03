function [PCAscores, explained, KMEANS_pca, TSNE] = cluster_segmented(data,...
    numpcs, k, opts)
[~, PCAscores, ~, ~, explained] = pca(data);
numpcs = min(numpcs, size(PCAscores,2));

disp('number of principle components used:');
disp(numpcs);
KMEANS_pca = kmeans(PCAscores(:, 1:numpcs),k);
TSNE = fast_tsne(PCAscores(:, 1:numpcs), opts );


