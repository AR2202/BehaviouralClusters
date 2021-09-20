function tSNEplots(filename, outputname)
load(filename);

cmap = prism;
grayscale = flipud(gray);
%---------------------

%Kmeans clustering
%______________________________________________


fignew = figure('Name', 't-SNE with Kmeans clustering');
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, cmap, '.', 3, 'doleg', 'off')

hold 'on'


xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans', outputname, '.eps');
saveas(fignew, figname, 'epsc');

%---------------------
%---------------------

%Kmeans clustering  with male data
%______________________________________________

fignew = figure('Name', 't-SNE with male data');
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(isFemale == 0, 1), TSNE(isFemale == 0, 2), KMEANS_pca(isFemale == 0, 1), gray, '.', 3, 'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_male', outputname, '.eps');
saveas(fignew, figname, 'epsc');

%---------------------

%Kmeans clustering  with female data
%______________________________________________

fignew = figure('Name', 't-SNE with female data');
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(isFemale == 1, 1), TSNE(isFemale == 1, 2), KMEANS_pca(isFemale == 1, 1), gray, '.', 3, 'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_female', outputname, '.eps');
saveas(fignew, figname, 'epsc');

%---------------------

%----------------------------------------------

%Encircling JAABA classifier
%______________________________

%Kmeans clustering with encircling
%______________________________________________

fignew = figure('Name', 't-SNE with Kmeans clustering and encircling from JAABA');
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.Encircling == 1, 1), TSNE(jaabadata.Encircling == 1, 2), KMEANS_pca(jaabadata.Encircling == 1, 1), cmap, '.', 3, 'doleg', 'off')


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
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.Facing == 1, 1), TSNE(jaabadata.Facing == 1, 2), KMEANS_pca(jaabadata.Facing == 1, 1), cmap, '.', 3, 'doleg', 'off')
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
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.WingGesture == 1, 1), TSNE(jaabadata.WingGesture == 1, 2), KMEANS_pca(jaabadata.WingGesture == 1, 1), cmap, '.', 3, 'doleg', 'off')
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
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.Copulation == 1, 1), TSNE(jaabadata.Copulation == 1, 2), KMEANS_pca(jaabadata.Copulation == 1, 1), cmap, '.', 3, 'doleg', 'off')
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
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.Approaching == 1, 1), TSNE(jaabadata.Approaching == 1, 2), KMEANS_pca(jaabadata.Approaching == 1, 1), cmap, '.', 3, 'doleg', 'off')
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
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.Turning == 1, 1), TSNE(jaabadata.Turning == 1, 2), KMEANS_pca(jaabadata.Turning == 1, 1), cmap, '.', 3, 'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

figname = strcat('tSNE_Kmeans_turning', outputname, '.eps');
saveas(fignew, figname, 'epsc');

%Contact JAABA classifier
%______________________________


%Kmeans clustering with contact
%______________________________________________
fignew = figure('Name', 't-SNE with Kmeans clustering and contact from JAABA');
gscatter(TSNE(:, 1), TSNE(:, 2), KMEANS_pca, grayscale, '.', 3, 'doleg', 'off')

hold 'on'

gscatter(TSNE(jaabadata.Contact == 1, 1), TSNE(jaabadata.Contact == 1, 2), KMEANS_pca(jaabadata.Contact == 1, 1), cmap, '.', 3, 'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

figname = strcat('tSNE_Kmeans_contact', outputname, '.eps');
saveas(fignew, figname, 'epsc');