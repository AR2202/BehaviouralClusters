function cluster_data(filename,outfilename)
%loading data

load(filename);

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
%hierarch_raw = clusterdata(combrescaled,'Linkage','ward','SaveMemory','on','MAXCLUST',10);

%hierarch_pca = clusterdata(PCAscores,'Linkage','ward','SaveMemory','on','MAXCLUST',10);



%KMEANS
KMEANS_pca=kmeans(PCAscores,10);
KMEANS_raw=kmeans(combrescaled,10);


save(outfilename)