%subsetting the data


data19=feat.data(19,:,[1:6,9:13]);
data19_=reshape(data19,22500,11);
data20=feat.data(20,:,[1:6,9:13]);
data20_=reshape(data20,22500,11);
data9=feat.data(9,:,[1:6,9:13]);

data9_=reshape(data9,22500,11);
data10=feat.data(10,:,[1:6,9:13]);
data10_=reshape(data10,22500,11);

data8=feat.data(8,:,[1:6,9:13]);
data8_=reshape(data8,22500,11);
data12=feat.data(12,:,[1:6,9:13]);
data12_=reshape(data12,22500,11);
data11=feat.data(11,:,[1:6,9:13]);
data11_=reshape(data11,22500,11);


%fill Na
f20 =fillmissing(data20_,'linear');
f10 =fillmissing(data10_,'linear');
f12 =fillmissing(data12_,'linear');
m11 =fillmissing(data11_,'linear');
m19 =fillmissing(data19_,'linear');
m9 =fillmissing(data9_,'linear');

%scaling
comb=vertcat(m9,m11,m19,f10,f12,f20);
colmin = min(comb(:,1:11));
colmax = max(comb(:,1:11));
combrescaled = rescale(comb,'InputMin',colmin,'InputMax',colmax);

%saving
save('clusterdata3pairs.mat','comb','combrescaled','colmin','colmax')
%TSNE
TSNE_unscaled=tsne(combrescaled);
TSNE=tsne(comb);
save('tsne3pairs.mat','TSNE','combrescaled')
%PCA
[PCAcoeff,PCAscores,~]=pca(combrescaled);
% hierarchical clustering
%hierarch_raw = clusterdata(combrescaled,'Linkage','ward','SaveMemory','on','MAXCLUST',10);

hierarch_pca = clusterdata(PCAscores,'Linkage','ward','SaveMemory','on','MAXCLUST',10);



%KMEANS
KMEANS_pca=kmeans(PCAscores,10);
KMEANS_raw=kmeans(combrescaled,10);


save('clustering3pairs.mat')