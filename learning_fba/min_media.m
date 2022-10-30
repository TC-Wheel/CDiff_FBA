clc, clearvars
fileName = 'Clostridium_difficile_CD196.mat';

model = readCbModel(fileName);

%Yili's code that imports the essential exchange rxn data
EssentialRxnsInfo = importdata('EssentialRxns_BT-BU_DM38.txt');
EssentialRxnsNames = EssentialRxnsInfo.textdata(:,1);
EssentialRxnsVmax = EssentialRxnsInfo.data(:,1);
%model = changeRxnBounds(model,EssentialRxnsNames,0,'l'); %set all rxns to 0

superEssentialRxns = {'EX_h2o(e)';'EX_h(e)';
    'EX_fe3(e)';'EX_mn2(e)';'EX_cu2(e)';'EX_cobalt2(e)';'EX_zn2(e)';
    'EX_fe2(e)';'EX_ca2(e)';'EX_mg2(e)'; 'EX_cl(e)';
    'EX_ribflv(e)';'EX_trp_L(e)';'EX_pydx(e)';'EX_val_L(e)'};

% here are the one's I thought were essential but then it grew without them
%"'EX_co2(e)';'EX_h2(e)';'EX_k(e)';'EX_na1(e)';";

%this makes a list of essential Rxns that are actually in the model
c = 0;
for i = 1:size(EssentialRxnsNames)
    EssentialRxnsNames(i);
    %we only want the rxns that are in our essential list that our model
    %has (that's this part V) and aren't in our superEssentialRxns- here V
    if any(strcmp(model.rxns,EssentialRxnsNames(i))) & ~any(strcmp(superEssentialRxns,EssentialRxnsNames(i)))
        c = c + 1;
        inModelRxns(c) = EssentialRxnsNames(i);
    end
end
inModelRxns = inModelRxns'; %transpose it to make it work...







%turn on super essential rxns
model = changeRxnBounds(model,inModelRxns,0,'l'); %first turn off all ex_rxns
model = changeRxnBounds(model,superEssentialRxns,-10,'l'); %then turn on super needed ones


%make a make matrix of all possible combos for 3 reactions
totalRxnLen = size(inModelRxns);
allRxnCombos = nchoosek((1:1:totalRxnLen), 3);








%now we need to see what combos will enchance the growth rate the most
%so... I need to make a matrix that will collect the output

%MAIN LOOP
for i = 1 : size(allRxnCombos)
    
    %tie our tested Rxns to our nchoosek matrix
    firstRxnInd = allRxnCombos(i,1);
    secondRxnInd = allRxnCombos(i,2);
    thirdRxnInd = allRxnCombos(i,3);
    firstRxn = inModelRxns(firstRxnInd);
    secondRxn = inModelRxns(secondRxnInd);
    thirdRxn = inModelRxns(thirdRxnInd);
    
    %open our exchange rxns
    model = changeRxnBounds(model,firstRxn,-10,'l');
    model = changeRxnBounds(model,secondRxn,-10,'l');
    model = changeRxnBounds(model,thirdRxn,-10,'l');

    
    %solve to check for growth
    FBAsolution = optimizeCbModel(model, 'max');
    
    
    
%     
%     if FBAsolution.f1 > 0
%         "party"
%         firstRxn
%         secondRxn
%         thirdRxn
%         FBAsolution.f1
%     end
    
    %close our exchange rxns
    model = changeRxnBounds(model,firstRxn,0,'l');
    model = changeRxnBounds(model,secondRxn,0,'l');
    model = changeRxnBounds(model,thirdRxn,0,'l');
end


%IT NEEDS Trp_L, Pydx, and Val_L


% %what super essential rxns can be removed and still have growth?
%IT CAN GROW WITHOUT "'EX_co2(e)';'EX_h2(e)';'EX_k(e)';'EX_na1(e)';";
%EVEN IF THEY ARE ALL TAKEN OUT TOGETHER
% for i = 1 : size(superEssentialRxns)
%     %remove the rxn
%     model = changeRxnBounds(model,superEssentialRxns(i),0,'l');
%     %optimize for growth
%     FBAsolution = optimizeCbModel(model, 'max');
%     
%     %check if it grew
%     if FBAsolution.f1 > 0
%         "Doesn't need it"
%         superEssentialRxns(i)
%         FBAsolution.f1
%     end
%     
%     %reopen rxn
%     model = changeRxnBounds(model,superEssentialRxns(i),-10,'l');
%     
% end


%THIS IS THE TEST THAT SHOWS THAT THE MODELS ARE IDENTICAL AND THE ACTUAL
%ERROR IS A NUMERICAL ONE WITH THE OPTIMIZING FUNCTION... PROBABALY
% model1 = model;
% 
% firstRxn = inModelRxns(36);
% secondRxn = inModelRxns(9);
% thirdRxn = inModelRxns(14);
% 
% model = changeRxnBounds(model,inModelRxns,0,'l'); %first turn off all ex_rxns
% model = changeRxnBounds(model,superEssentialRxns,-10,'l'); %then turn on super needed ones
% model = changeRxnBounds(model,firstRxn,-10,'l');
% model = changeRxnBounds(model,secondRxn,-10,'l');
% model = changeRxnBounds(model,thirdRxn,-10,'l');
% 
% model1 = changeRxnBounds(model1,inModelRxns,0,'l'); %first turn off all ex_rxns
% model1 = changeRxnBounds(model1,superEssentialRxns,-10,'l'); %then turn on super needed ones
% model1 = changeRxnBounds(model1,thirdRxn,-10,'l');
% model1 = changeRxnBounds(model1,secondRxn,-10,'l');
% model1 = changeRxnBounds(model1,firstRxn,-10,'l');
% 
% FBAsolution = optimizeCbModel(model, 'max');
% FBAsolution1 = optimizeCbModel(model1, 'max');
% 
% 
% 
% if model1.lb == model.lb
%     "True"
% else
%     "False"
% end


% s = size(inModelRxns);
% numbRxns = s(1);
% solutionsMap = zeros(numbRxns, numbRxns);
%
% for i = 1:numbRxns
%     %this is an attempt to find the minimal media... 
%     %comparing rxn1 to rxn2 to see if any two reactions work
%     currentRxn1 = inModelRxns(i);
%     
%     
%     %second loop to compare rx1 and rx2 combos
% 
%     for ii = 1:numbRxns
%         currentRxn2 = inModelRxns(ii);
%         model = changeRxnBounds(model, currentRxn1, -10, 'l'); %add the next rxn
%         model = changeRxnBounds(model, currentRxn2, -10, 'l'); %add the next rxn
%         FBAsol2 = optimizeCbModel(model, 'max');
%         solutionsMap(i,ii) = FBAsol2.f1;
%         model = changeRxnBounds(model, currentRxn1, 0, 'l'); %turn off 
%         model = changeRxnBounds(model, currentRxn2, 0, 'l'); %turn off
%     end
%     
% end
% % 
% % 
% % 
% % 
% % heatmap(solutionsMap, "xlabel", "ylabel");
% % 
% % 
% % caxis(log10([0.00001,32]));
