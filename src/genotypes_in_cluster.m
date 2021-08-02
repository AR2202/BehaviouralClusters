function [frac,absolute,frac_genotype] = genotypes_in_cluster(data,K,KMEANS)
genotypes = unique(data(:,size(data,2)));
frac = zeros(K,length(genotypes));
absolute = zeros(K,length(genotypes));

frac_genotype = zeros(K,length(genotypes));
for g = 1:length(genotypes)
    genotype = genotypes(g);
    frames_in_genotype = ...
        length(data(data(:,size(data,2)) == genotype,size(data,2)));
    
    for clusternumber = 1:K
        clusterdata = ...
            data(KMEANS==clusternumber,size(data,2));
        total_in_cluster = size(clusterdata,1);
        genotype_in_cluster = ...
            size(clusterdata(clusterdata == genotype),1);
      
        frac(clusternumber,g) = genotype_in_cluster/total_in_cluster;
        absolute(clusternumber,g) = genotype_in_cluster;
        frac_genotype(clusternumber,g) = genotype_in_cluster/frames_in_genotype;
        
        
    end
    
end