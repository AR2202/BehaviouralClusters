function tSNEplots(filename, outputname, wavelet, opt, withJAABA)
%%%This function is for plotting tSNE with different JAABA classifiers
%%%The arguments are:
%%%
%%%FILENAME: name of the file with clustered and tSNE data
%%%OUTPUTNAME: name of the outputfile
%%%wavelet: whether wavelet data should be plotted (bool)
%%%opt: whether k-optimized kmeans should be used or fixed k value (bool)
%%%withJAABA: whether plots of JAABA classifiers should be included in plot

load(filename);
if wavelet
    if opt
        KMEANSplot = KMEANS_opt_wavelet;

    else

        KMEANSplot = KMEANS_wavelet;
    end
    TSNEplot = TSNE_wavelet;

else
    if opt
        KMEANSplot = KMEANS_opt_pca;

    else
        KMEANSplot = KMEANS_pca;
    end
    TSNEplot = TSNE;

end
genotypes = unique(combrescaled_rem_cop(:, size(combrescaled_rem_cop, 2)));
% cmap = [
%     0.2 0.1 0.5
%     0.1 0.5 0.8
%     0.2 0.7 0.6
%     0.8 0.7 0.3
%     0.9 1 0
%     0.2 1 1
%     1 0 0
%     1 1 0
%     0 0 0
%     0.5 0.5 0.5
%     0.5 0 0
%     0 0.5 0
%     0 0 0.5
%     0.5 0.5 0
%     0.5 0 0.5
%     0.1 0 0.5
%     0.5 0 0.1
%     0.5 1 0.1
%     0.1 1 0.5
%     0.2 0.1 0
%     0.1 0.2 0
%     0.1 0.2 1
%     0.2 0.1 1
%     0.6 0.1 0.9
%     0.9 0.1 0.5
%     0.8 0.4 0.2
%     0.2 0.8 0.4
%     0.8 1 0.4
%     0.3 0.2 0.5
% ]
cmap = lines;
grayscale = flipud(gray);
%---------------------

%Kmeans clustering
%______________________________________________


fignew = figure('Name', 't-SNE with Kmeans clustering');
fig = scatter(TSNEplot(:, 1), TSNEplot(:, 2), 1, cmap(KMEANSplot, :))
hLeg = legend('fig');
set(hLeg, 'visible', 'off');
hold 'on'


xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_', outputname, '.eps');
saveas(fignew, figname, 'epsc');

%---------------------
%---------------------

%Kmeans clustering  with male data
%______________________________________________

fignew = figure('Name', 't-SNE with male data');
gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

hold 'on'

gscatter(TSNEplot(isFemale_rem_cop == 0, 1), TSNEplot(isFemale_rem_cop == 0, 2), KMEANSplot(isFemale_rem_cop == 0, 1), gray, '.', 1, 'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_male_', outputname, '.eps');
saveas(fignew, figname, 'epsc');

%---------------------

%Kmeans clustering  with female data
%______________________________________________

fignew = figure('Name', 't-SNE with female data');
gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

hold 'on'

gscatter(TSNEplot(isFemale_rem_cop == 1, 1), TSNEplot(isFemale_rem_cop == 1, 2), KMEANSplot(isFemale_rem_cop == 1, 1), gray, '.', 1, 'doleg', 'off')

xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_female_', outputname, '.eps');
saveas(fignew, figname, 'epsc');


%---------------------
% JAABA classifier plots
%----------------------------------------------
if withJAABA
    %Encircling JAABA classifier
    %______________________________

    %Kmeans clustering with encircling
    %______________________________________________

    fignew = figure('Name', 't-SNE with Kmeans clustering and encircling from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.Encircling == 1, 1), TSNEplot(jaabadata_rem_cop.Encircling == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.Encircling == 1, 1), :))
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');

    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    %save figure
    figname = strcat('tSNE_Kmeans_encircling', outputname, '.eps');
    saveas(fignew, figname, 'epsc');
    %----------------------------------------------

    %Facing JAABA classifier
    %______________________________

    %Hierarchical clustering with facing and male data

    %---------------------

    %Kmeans clustering with facing
    %______________________________________________
    fignew = figure('Name', 't-SNE with Kmeans clustering and facing from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.Facing == 1, 1), TSNEplot(jaabadata_rem_cop.Facing == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.Facing == 1, 1), :))
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    %save figure
    figname = strcat('tSNE_Kmeans_facing', outputname, '.eps');
    saveas(fignew, figname, 'epsc');
    %----------------------------------------------

    %Wing gesture JAABA classifier
    %______________________________


    %Kmeans clustering with wing extension and male data
    %______________________________________________
    fignew = figure('Name', 't-SNE with Kmeans clustering and wingextension from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.WingGesture == 1, 1), TSNEplot(jaabadata_rem_cop.WingGesture == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.WingGesture == 1, 1), :))
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    %save figure
    figname = strcat('tSNE_Kmeans_wingextension', outputname, '.eps');
    saveas(fignew, figname, 'epsc');
    %----------------------------------------------

    %Copulation JAABA classifier
    %______________________________


    %Kmeans clustering with copulation
    %______________________________________________
    fignew = figure('Name', 't-SNE with Kmeans clustering and copulation from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.Copulation == 1, 1), TSNEplot(jaabadata_rem_cop.Copulation == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.Copulation == 1, 1), :))
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    figname = strcat('tSNE_Kmeans_copulation', outputname, '.eps');
    saveas(fignew, figname, 'epsc');
    %----------------------------------------------

    %Approaching JAABA classifier
    %---------------------

    %Kmeans clustering with approaching
    %______________________________________________
    fignew = figure('Name', 't-SNE with Kmeans clustering and approaching from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.Approaching == 1, 1), TSNEplot(jaabadata_rem_cop.Approaching == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.Approaching == 1, 1), :), '.', 1, 'doleg', 'off')
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    figname = strcat('tSNE_Kmeans_approaching', outputname, '.eps');
    saveas(fignew, figname, 'epsc');

    %----------------------------------------------


    %Turning JAABA classifier

    %---------------------

    %Kmeans clustering with turning
    %______________________________________________
    fignew = figure('Name', 't-SNE with Kmeans clustering and turning from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.Turning == 1, 1), TSNEplot(jaabadata_rem_cop.Turning == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.Turning == 1, 1), :))
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    figname = strcat('tSNE_Kmeans_turning', outputname, '.eps');
    saveas(fignew, figname, 'epsc');

    %Contact JAABA classifier
    %______________________________


    %Kmeans clustering with contact
    %______________________________________________
    fignew = figure('Name', 't-SNE with Kmeans clustering and contact from JAABA');
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1, 'doleg', 'off')

    hold 'on'

    fig = scatter(TSNEplot(jaabadata_rem_cop.Contact == 1, 1), TSNEplot(jaabadata_rem_cop.Contact == 1, 2), 1, cmap(KMEANSplot(jaabadata_rem_cop.Contact == 1, 1), :))
    hLeg = legend('fig');
    set(hLeg, 'visible', 'off');
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    figname = strcat('tSNE_Kmeans_contact', outputname, '.eps');
    saveas(fignew, figname, 'epsc');
end
%------------------------------------
%Kmeans clustering with genotypes
%----------------------------------

for g = 1:size(genotypes)
    genotype = genotypes(g);
    disp(genotype)

    fignew = figure('Name', strcat('t-SNE with Kmeans clustering and genotype', num2str(genotype)));
    gscatter(TSNEplot(:, 1), TSNEplot(:, 2), KMEANSplot, grayscale, '.', 1)

    hold 'on'

    fig = scatter(TSNEplot(combrescaled_rem_cop(:, size(combrescaled_rem_cop, 2)) == genotype, 1), TSNEplot(combrescaled_rem_cop(:, size(combrescaled_rem_cop, 2)) == genotype, 2), 1, cmap(KMEANSplot(combrescaled_rem_cop(:, size(combrescaled_rem_cop, 2)) == genotype), :))
    hLeg = legend('fig')
    set(hLeg, 'visible', 'off')
    xlabel 't-SNE 1'
    ylabel 't-SNE 2'

    figname = strcat('tSNE_Kmeans_genotype_', num2str(genotype), outputname, '.eps');
    saveas(fignew, figname, 'epsc');
end