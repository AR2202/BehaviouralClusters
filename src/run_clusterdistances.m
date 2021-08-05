function clusternumbers = run_clusterdistances(filename)
load(filename)
clusternumbers = clusterdistances(centroids_pca_rep,k);