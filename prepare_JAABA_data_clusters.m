function prepare_JAABA_data_clusters(filename,outfilename)
startdir = pwd;
jaabafolder = strcat(filename,'_JAABA');
%loadJAABADATA
cd(jaabafolder);
%Wing extension
load('scores_WingGesture_id_corrected.mat');
WEScores10=allScores.postprocessed{10};
WEScores12=allScores.postprocessed{12};
WEScores9=allScores.postprocessed{09};
WEScores11=allScores.postprocessed{11};
WEScores20=allScores.postprocessed{20};
WEScores19=allScores.postprocessed{19};
%Turning
load('scores_Turning_id_corrected.mat');
turnScores12=allScores.postprocessed{12};
turnScores11=allScores.postprocessed{11};
turnScores9=allScores.postprocessed{9};
turnScores19=allScores.postprocessed{19};
turnScores10=allScores.postprocessed{10};
turnScores20=allScores.postprocessed{20};
%Circling
load('scores_Encircling_id_corrected.mat');
circScores12=allScores.postprocessed{12};
circScores11=allScores.postprocessed{11};
circScores10=allScores.postprocessed{10};
circScores9=allScores.postprocessed{9};
circScores19=allScores.postprocessed{19};
circScores20=allScores.postprocessed{20};
%Copulation
load('scores_Copulation_id_corrected.mat');
copScores19=allScores.postprocessed{19};
copScores20=allScores.postprocessed{20};
copScores10=allScores.postprocessed{10};
copScores11=allScores.postprocessed{11};
copScores9=allScores.postprocessed{9};
%Contact
load('scores_Contact_id_corrected.mat');
coScores19=allScores.postprocessed{19};
coScores20=allScores.postprocessed{20};
coScores10=allScores.postprocessed{10};
coScores9=allScores.postprocessed{9};
coScores11=allScores.postprocessed{11};
coScores12=allScores.postprocessed{12};
copScores12=allScores.postprocessed{12};
%Approaching
load('scores_Approaching_id_corrected.mat');
apprScores12=allScores.postprocessed{12};
apprScores11=allScores.postprocessed{11};
apprScores10=allScores.postprocessed{10};
apprScores9=allScores.postprocessed{9};
apprScores20=allScores.postprocessed{20};
apprScores19=allScores.postprocessed{19};
%Facing
load('scores_Facing_id_corrected.mat');
facingScores19=allScores.postprocessed{19};
facingScores20=allScores.postprocessed{20};
facingScores10=allScores.postprocessed{10};
facingScores9=allScores.postprocessed{9};
facingScores11=allScores.postprocessed{11};
facingScores12=allScores.postprocessed{12};

%all Scores 
combinedWEScores=vertcat(transpose(WEScores9),transpose(WEScores11),transpose(WEScores19),transpose(WEScores10),transpose(WEScores12),transpose(WEScores20));
combinedCircScores=vertcat(transpose(circScores9),transpose(circScores11),transpose(circScores19),transpose(circScores10),transpose(circScores12),transpose(circScores20));
combinedApprScores=vertcat(transpose(apprScores9),transpose(apprScores11),transpose(apprScores19),transpose(apprScores10),transpose(apprScores12),transpose(apprScores20));
combinedCopScores=vertcat(transpose(copScores9),transpose(copScores11),transpose(copScores19),transpose(copScores10),transpose(copScores12),transpose(copScores20));
combinedFacingScores=vertcat(transpose(facingScores19),transpose(facingScores11),transpose(facingScores19),transpose(facingScores10),transpose(facingScores12),transpose(facingScores20));
combinedTurnScores=vertcat(transpose(turnScores9),transpose(turnScores11),transpose(turnScores19),transpose(turnScores10),transpose(facingScores12),transpose(turnScores20));
combinedCoScores=vertcat(transpose(coScores19),transpose(coScores11),transpose(coScores19),transpose(coScores10),transpose(coScores12),transpose(coScores20));
cd (startdir);
save(outfilename)