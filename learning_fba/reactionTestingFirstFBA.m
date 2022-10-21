fileName = 'Clostridium_difficile_CD196.mat';

model = readCbModel(fileName);

% printConstraints(model,-1000,1000)
% model = changeRxnBounds(model,'EX_glc(e)',-18.5,'l');
% model = changeRxnBounds(model,'EX_o2(e)',-1000,'l');


%Yili's code
EssentialRxnsInfo = importdata('EssentialRxns_BT-BU_DM38.txt');
EssentialRxnsNames = EssentialRxnsInfo.textdata(:,1);
EssentialRxnsVmax = EssentialRxnsInfo.data(:,1);


%put a for loop here
model = changeRxnBounds(model,EssentialRxnsNames,0,'l');

% Rxns = size(EssentialRxnsNames);

for ii = 1:size(EssentialRxnsNames)
    EssentialRxnsNames(ii)
    model = changeRxnBounds(model,EssentialRxnsNames(ii), -10,'l');
    
%     disp(EssentialRxnsNames(ii));
    FBAsol1 = optimizeCbModel(model,'max');
    FBAsol1.f1
    %ii
%     fluxData = FBAsol1.v;
%     nonZeroFlag = 1;
    %printFluxVector(model, fluxData, nonZeroFlag)
    %biomassPrecursorCheck(model)
%     printFluxBounds(model, EssentialRxnsNames(ii))
    %CD 95 is the strain they use
%     
%     if model.c'*FBAsol1.v < 1
%         disp(EssentialRxnsNames(ii))
%         FBAsol1.f
%     end
end







%TASK1: use a for loop to open up exchange reactions one at a time 
%to figure out the minimal growth media. DONE?

%do I itterate through each reaction, and measure the output, then take the
%highest growth rate...? Do I measure two reactions at a time?
%I might need to watch more videos on modeling and MatLAB to understand how
%to do this.

