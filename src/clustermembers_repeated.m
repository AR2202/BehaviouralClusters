function [pvalues_features,times_average,significant_cluster_features,genotype1_biased,genotype2_biased,pvalues,frac_rep,absolute_rep,frac_genotype_rep] = clustermembers_repeated(filename)
load(filename)
clusternumbers = clusterdistances(centroids_pca_rep,k);
KMEANS_clustersnumbers = zeros(size(KMEANS_pca_rep));
repeats = size(KMEANS_pca_rep,2);
numgenotypes = length(unique(PCAscores_subsampled_rep(:,size(PCAscores_subsampled_rep,2),1)));
frac_rep = zeros(k,numgenotypes,repeats);
frac_genotype_rep = zeros(k,numgenotypes,repeats);
absolute_rep = zeros(k,numgenotypes,repeats);
pvalues = zeros(1,k);
for r=1:repeats
    
    KMEANS_clustersnumbers(:,r) = arrayfun(@(d)clusternumbers(d,r),KMEANS_pca_rep(:,r));
    [frac_rep(:,:,r),absolute_rep(:,:,r),frac_genotype_rep(:,:,r)] = genotypes_in_cluster(PCAscores_subsampled_rep(:,:,r),k,KMEANS_clustersnumbers(:,r));
end
%----------------
%stats
%_______________
%only makes sense for 2 genotypes
%to be generalized at a later stage
for cluster=1:k
[p,h,stats] = ranksum(reshape(absolute_rep(cluster,1,:),1,repeats),reshape(absolute_rep(cluster,2,:),1,repeats));
pvalues(cluster) = p;
%Bonferroni method for multiple comparison correction - to be updated to
%other method

end
pvalues=pvalues*k;
significantClusters = find(pvalues<0.001);
numfeatures=11;
genotype1_biased = significantClusters((frac_genotype_rep(significantClusters,1,1)>frac_genotype_rep(significantClusters,2,1)));
genotype2_biased = significantClusters((frac_genotype_rep(significantClusters,2,1)>frac_genotype_rep(significantClusters,1,1)));
[pvalues_features, times_average, significant_cluster_features] = features_in_clusters(PCAscores_subsampled_rep,KMEANS_clustersnumbers,significantClusters,numfeatures);