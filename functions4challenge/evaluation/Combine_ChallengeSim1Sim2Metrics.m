function ReconMetrics_Final=Combine_ChallengeSim1Sim2Metrics(ReconMetrics_Sim1,ReconMetrics_Sim2)
% Function that Combines the metrics from the 2 simulation models used in
% the Challenge. 
% There are two metrics for which Sim1 does not provide meaningful results:
% 'CalcStreak','DeviationFromCalcMoment'
% therefore for the final metric does not take those into account

    ReconMetrics_Final=ReconMetrics_Sim1;
    fieldsavailable = fieldnames(ReconMetrics_Sim1);
    fieldlength=length(fieldsavailable);
    
    for k=1:fieldlength
        metric_1=getfield(ReconMetrics_Sim1,fieldsavailable{k});
        metric_2=getfield(ReconMetrics_Sim2,fieldsavailable{k});
        if or (strcmp(fieldsavailable{k},'CalcStreak'),strcmp(fieldsavailable{k},'DeviationFromCalcMoment'))
            metric=metric_2;
            
        else
            metric=(metric_1+metric_2)/2;
        end;
        ReconMetrics_Final=setfield(ReconMetrics_Final,fieldsavailable{k},metric);
    end;
    
    