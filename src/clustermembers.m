function clustermembers(filename,outputname,wavelet,opt)
%%%Annika Rings 2021
%%%This function is for plotting genotypes each cluster
%%%The arguments are:
%%%
%%%FILENAME: name of the file with clustered  data
%%%OUTPUTNAME: name of the outputfile
%%%wavelet: whether wavelet data should be plotted (bool)
%%%opt: whether k-optimized kmeans should be used or fixed k value (bool)

%probably this is not yet quite what we want as it will depend on the
%number of flies for each genotype
load(filename);
if wavelet
    if opt
        KMEANSplot = KMEANS_opt_wavelet;
        K = K_wavelet;
        
    else
        
        KMEANSplot = KMEANS_wavelet;
        K = k;
    end
    
    
else
    if opt
        KMEANSplot = KMEANS_opt_pca;
        K = K_pca;
        
    else
        KMEANSplot = KMEANS_pca;
        K = k;
    end
    
    
end
colormap cool;
genotypes = unique(combrescaled_rem_cop(:,size(combrescaled_rem_cop,2)));
frac=zeros(K,length(genotypes));
frac_cluster = zeros(length(genotypes),1);
for clusternumber = 1:K
    clusterdata = ...
        combrescaled_rem_cop(KMEANSplot==clusternumber,size(combrescaled_rem_cop,2));
    total_in_cluster = size(clusterdata,1);
    
    for g = 1:length(genotypes)
    genotype = genotypes(g);
    genotype_in_cluster = ...
        size(clusterdata(clusterdata == genotype),1);
    frac_cluster(g) = genotype_in_cluster/total_in_cluster;
    frac(clusternumber,g) = frac_cluster(g);
    end
    %plotting
    fignew=figure('Name',strcat('cluster',num2str(clusternumber)));
    b=bar(frac_cluster,0.1,'FaceColor','flat');
    
    
    
    xlabel 'genotype'
    ylabel 'fraction'
    
    %save figure
    figname = strcat('members_cluster',num2str(clusternumber),outputname,'.eps');
    saveas(fignew,figname,'epsc');
    save(strrep(figname,'.eps','.mat'),'frac');
end

