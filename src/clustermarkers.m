function clustermarkers(filename, outputname, wavelet, opt)
%%%Annika Rings 2021
%%%This function is for plotting the levels of each feature in each cluster
%%%The arguments are:
%%%
%%%FILENAME: name of the file with clustered  data
%%%OUTPUTNAME: name of the outputfile
%%%wavelet: whether wavelet data should be plotted (bool)
%%%opt: whether k-optimized kmeans should be used or fixed k value (bool)

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
feat_data_clusters = zeros(K, 2, size(combrescaled_rem_cop, 2)-1);
for clusternumber = 1:K
    featdata = combrescaled_rem_cop(KMEANSplot == clusternumber, 1:size(combrescaled_rem_cop, 2)-1);
    meandata = mean(featdata);
    SEMdata = std(featdata) / sqrt(length(featdata));
    feat_data_clusters(clusternumber, 1, :) = meandata;
    feat_data_clusters(clusternumber, 2, :) = SEMdata;
    %plotting
    fignew = figure('Name', strcat('cluster', num2str(clusternumber)));
    b = bar(transpose(meandata), 0.1, 'FaceColor', 'flat');

    hold on;
    errorbar([1:size(combrescaled_rem_cop, 2) - 1], meandata, SEMdata, SEMdata, '.');

    xlabel 'feature'
    ylabel ''

    %save figure
    figname = strcat('features_cluster', num2str(clusternumber), outputname, '.eps');
    saveas(fignew, figname, 'epsc');
    save(strrep(figname, '.eps', '.mat'), 'feat_data_clusters');
end
