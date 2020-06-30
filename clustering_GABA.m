%Encircling JAABA classifier
%______________________________

%Hierarchical clustering with encircling and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and encircling from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
encirclingtrue = TSNE(combinedCircScores==1,1);
encircling=arrayfun (@(x) 'encircling',encirclingtrue,'UniformOutput',false);
gscatter(TSNE(combinedCircScores==1,1),TSNE(combinedCircScores==1,2),encircling,'k','x',4)
placeholder=zeros(67500,1);
male=arrayfun (@(x) 'male data',placeholder,'UniformOutput',false);
gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_encircling.eps','epsc');
%---------------------

%Kmeans clustering with encircling and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and encircling from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedCircScores==1,1),TSNE(combinedCircScores==1,2),encircling,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_encircling.eps','epsc');
%----------------------------------------------

%Facing JAABA classifier
%______________________________

%Hierarchical clustering with facing and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and facing from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
facingtrue = TSNE(combinedFacingScores==1,1);
facing=arrayfun (@(x) 'facing',facingtrue,'UniformOutput',false);
gscatter(TSNE(combinedFacingScores==1,1),TSNE(combinedFacingScores==1,2),facing,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_facing.eps','epsc');
%---------------------

%Kmeans clustering with facing and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and facing from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedFacingScores==1,1),TSNE(combinedFacingScores==1,2),facing,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_facing.eps','epsc');
%----------------------------------------------

%Wing gesture JAABA classifier
%______________________________

%Hierarchical clustering with wing extension and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and wing extension from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
WEtrue = TSNE(combinedWEScores==1,1);
WE=arrayfun (@(x) 'wing extension',WEtrue,'UniformOutput',false);
gscatter(TSNE(combinedWEScores==1,1),TSNE(combinedWEScores==1,2),WE,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_WE.eps','epsc');
%---------------------

%Kmeans clustering with wing extension and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and wing extension from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedWEScores==1,1),TSNE(combinedWEScores==1,2),WE,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_WE.eps','epsc');
%----------------------------------------------

%Copulation JAABA classifier
%______________________________

%Hierarchical clustering with copulation and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and copulation from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
coptrue = TSNE(combinedCopScores==1,1);
cop=arrayfun (@(x) 'copulation',coptrue,'UniformOutput',false);
gscatter(TSNE(combinedCopScores==1,1),TSNE(combinedCopScores==1,2),cop,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_cop.eps','epsc');
%---------------------

%Kmeans clustering with copulation and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and cop from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedCopScores==1,1),TSNE(combinedCopScores==1,2),cop,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_cop.eps','epsc');
%----------------------------------------------

%Approaching JAABA classifier
%______________________________

%Hierarchical clustering with approaching and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and approaching from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
approachingtrue = TSNE(combinedApprScores==1,1);
approaching=arrayfun (@(x) 'approaching',approachingtrue,'UniformOutput',false);
gscatter(TSNE(combinedApprScores==1,1),TSNE(combinedApprScores==1,2),approaching,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_approaching.eps','epsc');
%---------------------

%Kmeans clustering with approaching and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and approaching from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedApprScores==1,1),TSNE(combinedApprScores==1,2),approaching,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_approaching.eps','epsc');


%----------------------------------------------


%Turning JAABA classifier
%______________________________

%Hierarchical clustering with turning and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and turning from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
turningtrue = TSNE(combinedTurnScores==1,1);
turning=arrayfun (@(x) 'approaching',turningtrue,'UniformOutput',false);
gscatter(TSNE(combinedTurnScores==1,1),TSNE(combinedTurnScores==1,2),turning,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_turning.eps','epsc');
%---------------------

%Kmeans clustering with turning and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and turning from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedTurnScores==1,1),TSNE(combinedTurnScores==1,2),turning,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_turning.eps','epsc');
%---------------------

%Contact JAABA classifier
%______________________________

%Hierarchical clustering with contact and male data 
%______________________________________________________
fignew=figure('Name','t-SNE with hierarchical clustering and contact from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),hierarch_pca,[],'O')
hold 'on'
contacttrue = TSNE(combinedCoScores==1,1);
contact=arrayfun (@(x) 'contact',contacttrue,'UniformOutput',false);
gscatter(TSNE(combinedCoScores==1,1),TSNE(combinedCoScores==1,2),contact,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_hierarchical_ward10_pca_w_conta t.eps','epsc');
%---------------------

%Kmeans clustering with contact and male data 
%______________________________________________
fignew=figure('Name','t-SNE with Kmeans clustering and contact from JAABA');
gscatter(TSNE(:,1),TSNE(:,2),KMEANS_pca,[],'O')
hold 'on'

gscatter(TSNE(combinedCoScores==1,1),TSNE(combinedCoScores==1,2),contact,'k','x',4)

gscatter(TSNE(1:67500,1),TSNE(1:67500,2),male,'y','.',3)
xlabel 't-SNE 1'
ylabel 't-SNE 2'
%save figure
saveas(fignew,'tSNE_3_pairs_Kmeans10_pca_w_contact.eps','epsc');
