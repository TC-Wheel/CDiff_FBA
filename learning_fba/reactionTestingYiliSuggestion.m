load Clostridium_difficile_CD196.mat
%initCobraToolbox(false)

%import essential reactions data and parse
EssentialRxnsInfo = importdata('EssentialRxns_BT-BU_DM38.txt');
EssentialRxnsNames = EssentialRxnsInfo.textdata(:,1);
EssentialRxnsVmax = EssentialRxnsInfo.data(:,1);

model = changeRxnBounds(model,EssentialRxnsNames,EssentialRxnsVmax,'l');

%1:20
sol = optimizeCbModel(model,'max');
