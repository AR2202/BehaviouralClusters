function tSNEplots(filename,outputname,wavelet)

load(filename);
if wavelet
    KMEANSplot = KMEANS_wavelet;
    TSNEplot = TSNE_wavelet;
else
    KMEANSplot = KMEANS_pca;
    TSNEplot = TSNE;
end
cmap = prism;
grayscale = flipud(gray);
%---------------------

%Kmeans clustering  
%______________________________________________


fignew=figure('Name','t-SNE with Kmeans clustering');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,cmap,'.',3,'doleg', 'off')

hold 'on'


xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans',outputname,'.eps');
saveas(fignew,figname,'epsc');

%---------------------
%---------------------

%Kmeans clustering  with male data
%______________________________________________

fignew=figure('Name','t-SNE with male data');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(isFemale==0,1),TSNEplot(isFemale==0,2),KMEANSplot(isFemale==0,1),gray,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_male',outputname,'.eps');
saveas(fignew,figname,'epsc');

%---------------------

%Kmeans clustering  with female data
%______________________________________________

fignew=figure('Name','t-SNE with female data');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(isFemale==1,1),TSNEplot(isFemale==1,2),KMEANSplot(isFemale==1,1),gray,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_female',outputname,'.eps');
saveas(fignew,figname,'epsc');

%---------------------

%----------------------------------------------

%Encircling JAABA classifier
%______________________________

%Kmeans clustering with encircling 
%______________________________________________

fignew=figure('Name','t-SNE with Kmeans clustering and encircling from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.Encircling==1,1),TSNEplot(jaabadata.Encircling==1,2),KMEANSplot(jaabadata.Encircling==1,1),cmap,'.',3,'doleg', 'off')


xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_encircling',outputname,'.eps');
saveas(fignew,figname,'epsc');
%----------------------------------------------

%Facing JAABA classifier
%______________________________

%Hierarchical clustering with facing and male data 

%---------------------

%Kmeans clustering with facing 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and facing from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.Facing==1,1),TSNEplot(jaabadata.Facing==1,2),KMEANSplot(jaabadata.Facing==1,1),cmap,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_facing',outputname,'.eps');
saveas(fignew,figname,'epsc');
%----------------------------------------------

%Wing gesture JAABA classifier
%______________________________



%Kmeans clustering with wing extension and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and wingextension from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.WingGesture==1,1),TSNEplot(jaabadata.WingGesture==1,2),KMEANSplot(jaabadata.WingGesture==1,1),cmap,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

%save figure
figname = strcat('tSNE_Kmeans_wingextension',outputname,'.eps');
saveas(fignew,figname,'epsc');
%----------------------------------------------

%Copulation JAABA classifier
%______________________________



%Kmeans clustering with copulation
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and copulation from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.Copulation==1,1),TSNEplot(jaabadata.Copulation==1,2),KMEANSplot(jaabadata.Copulation==1,1),cmap,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

figname = strcat('tSNE_Kmeans_copulation',outputname,'.eps');
saveas(fignew,figname,'epsc');
%----------------------------------------------

%Approaching JAABA classifier
%---------------------

%Kmeans clustering with approaching 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and approaching from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.Approaching==1,1),TSNEplot(jaabadata.Approaching==1,2),KMEANSplot(jaabadata.Approaching==1,1),cmap,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

figname = strcat('tSNE_Kmeans_approaching',outputname,'.eps');
saveas(fignew,figname,'epsc');

%----------------------------------------------


%Turning JAABA classifier

%---------------------

%Kmeans clustering with turning 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and turning from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.Turning==1,1),TSNEplot(jaabadata.Turning==1,2),KMEANSplot(jaabadata.Turning==1,1),cmap,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

figname = strcat('tSNE_Kmeans_turning',outputname,'.eps');
saveas(fignew,figname,'epsc');

%Contact JAABA classifier
%______________________________



%Kmeans clustering with contact 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and contact from JAABA');
gscatter(TSNEplot(:,1),TSNEplot(:,2),KMEANSplot,grayscale,'.',3,'doleg', 'off')

hold 'on'

gscatter(TSNEplot(jaabadata.Contact==1,1),TSNEplot(jaabadata.Contact==1,2),KMEANSplot(jaabadata.Contact==1,1),cmap,'.',3,'doleg', 'off')
xlabel 't-SNE 1'
ylabel 't-SNE 2'

figname = strcat('tSNE_Kmeans_contact',outputname,'.eps');
saveas(fignew,figname,'epsc');