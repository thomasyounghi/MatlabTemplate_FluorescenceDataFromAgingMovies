addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

longmanual = readtable('7_5_18_yTY149_manualroimeasurements.csv')
traplist = unique(longmanual(:,1:2));
traplist = table2array(traplist)

numtimes = 25;
YFPresult = NaN(size(traplist,1),numtimes);
RFPresult = NaN(size(traplist,1),numtimes);
longmanualarray = table2array(longmanual)


for j=1:size(traplist,1)
    values = longmanualarray((longmanualarray(:,1)==traplist(j,1)) & (longmanualarray(:,2)==traplist(j,2)),:)
    for i=1:size(values,1)
       YFPresult(j,values(i,3)) = values(i,4);
       RFPresult(j,values(i,3)) = values(i,5);
    end
end

YFPresult = array2table(YFPresult);
RFPresult = array2table(RFPresult);
traplist = array2table(traplist,'VariableNames',{'xy','trap'});

YFPresult = [traplist,YFPresult];
RFPresult = [traplist,RFPresult];

writetable(YFPresult,'7_5_18_circled_meanC2.csv');
writetable(RFPresult,'7_5_18_circled_meanC3.csv');
