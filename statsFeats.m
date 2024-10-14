function vStats=statsFeats(mFeatures)

% Remove rows that contain NaNs
mFeatures(find(sum(isnan(mFeatures)')),:)=[];

% calcualte statistics

vStats=[mean(mFeatures); std(mFeatures)]; % vStats=[mean1, mean2, mean3,...; std1, std2, std3,...]

vStats=vStats(:)'; % vStats=[mean1, std1, mean2, std2, ...]



end