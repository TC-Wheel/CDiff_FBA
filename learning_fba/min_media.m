fileName = 'Clostridium_difficile_CD196.mat';

model = readCbModel(fileName);

%Yili's code
EssentialRxnsInfo = importdata('EssentialRxns_BT-BU_DM38.txt');
EssentialRxnsNames = EssentialRxnsInfo.textdata(:,1);
EssentialRxnsVmax = EssentialRxnsInfo.data(:,1);
model = changeRxnBounds(model,EssentialRxnsNames,0,'l'); %set all rxns to 0

solutions = []

for i = 1:size(EssentialRxnsNames)
    %this is an attempt to find the minimal media... 
    %comparing rxn1 to rxn2 to see if any two reactions work
    currentRxn1 = EssentialRxnsNames(i);
    model = changeRxnBounds(model,EssentialRxnsNames,0,'l'); %turn off all rxns
    model = changeRxnBounds(model, currentRxn1, -10, 'l'); %add the next rxn
    FBAsol1 = optimizeCbModel(model, 'max');
    FBAsol1.f1;
    
    %second loop to compare rx1 and rx2 combos
    for ii = 1:size(EssentialRxnsNames)
        currentRxn2 = EssentialRxnsNames(ii);
        model = changeRxnBounds(model, currentRxn2, -10, 'l'); %add the next rxn
        FBAsol2 = optimizeCbModel(model, 'max');
        if FBAsol2.f1 > 0
            currentRxn1
            currentRxn2
            FBAsol2.f1
        end
    end
    
end
