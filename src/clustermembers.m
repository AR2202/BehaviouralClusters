function clustermembers(filename,outputname,wavelet,opt)
%%%Annika Rings 2021
%%%This function is for plotting genotypes each cluster
%%%The arguments are:
%%%
%%%FILENAME: name of the file with clustered  data
%%%OUTPUTNAME: name of the outputfile
%%%wavelet: whether wavelet data should be plotted (bool)
%%%opt: whether k-optimized kmeans should be used or fixed k value (bool)

%note that frac depend on the
%number of flies for each genotype
%frac_genotype is normalized to the number of flies in that genotype
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
frac = zeros(K,length(genotypes));
absolute = zeros(K,length(genotypes));

frac_genotype = zeros(K,length(genotypes));
for g = 1:length(genotypes)
    genotype = genotypes(g);
    frames_in_genotype = ...
        length(combrescaled_rem_cop(combrescaled_rem_cop(:,size(combrescaled_rem_cop,2)) == genotype,size(combrescaled_rem_cop,2)));
    
    for clusternumber = 1:K
        clusterdata = ...
            combrescaled_rem_cop(KMEANSplot==clusternumber,size(combrescaled_rem_cop,2));
        total_in_cluster = size(clusterdata,1);
        genotype_in_cluster = ...
            size(clusterdata(clusterdata == genotype),1);
      
        frac(clusternumber,g) = genotype_in_cluster/total_in_cluster;
        absolute(clusternumber,g) = genotype_in_cluster;
        frac_genotype(clusternumber,g) = genotype_in_cluster/frames_in_genotype;
        
        
    end
    
end
%plotting
 for clusternumber = 1:K
    frac_cluster = frac(clusternumber,:);
    frac_genotype_cluster = frac_genotype(clusternumber,:);
    %plotting of fraction each genotype contributes to cluster
    fignew=figure('Name',strcat('cluster',num2str(clusternumber)));
    b=bar(frac_cluster,0.1,'FaceColor','flat');
    
    
    
    xlabel 'genotype'
    ylabel 'fraction'
    
    %save figure
    figname = strcat('fraction_in_cluster',num2str(clusternumber),outputname,'.eps');
    saveas(fignew,figname,'epsc');
    
    %plotting of fraction of the genotype's total frames in this cluster
    fignew=figure('Name',strcat('fraction per genotype cluster',num2str(clusternumber)));
    b=bar(frac_genotype_cluster,0.1,'FaceColor','flat');
    
    
    
    xlabel 'genotype'
    ylabel 'fraction'
    %save figure
    figname = strcat('fraction_of_genotype_cluster',num2str(clusternumber),outputname,'.eps');
    saveas(fignew,figname,'epsc');
 end
 %save data to .mat file
save(strcat('clustermembers',outputname,'.mat'),'frac','frac_genotype','absolute');


