tbl = readtable("WIEE-participation - Sheet1.csv");
demos = readtable("WIEE_Results - Demos.csv");


joined = join(tbl,demos);


figure;
t = tiledlayout("flow");            
for algoname = {""}%{'iFOD22', 'SDSTREAM','SIFT','Thresholding'}
    %for atlasname =%{'freesurfer','slant','hcpmmp1'}
    %disp(atlasname)
        mu_AD = zeros(1,6);
        sigma_AD = zeros(1,6);
        mu_CN = zeros(1,6);
        sigma_CN = zeros(1,6);
        i=0;
        %disp(algoname)
        for numstreams = [10000, 1000000, 2000000, 4000000, 5000000, 10000000]
            researchgroup=1;
            %subsetT = joined((joined.Tag == algoname) & (joined.Atlas == atlasname) & (joined.NumStreamlines == numstreams) & (joined.ResearchGroup == researchgroup), :);
            subsetT = joined((joined.NumStreamlines == numstreams) & (joined.ResearchGroup == researchgroup), :);
            bar1 = std(subsetT(:,6:89)) ./ mean(subsetT(:,6:89));
            researchgroup=0;
            %subsetT = joined((joined.Tag == algoname) & (joined.Atlas == atlasname) & (joined.NumStreamlines == numstreams) & (joined.ResearchGroup == researchgroup), :);
            subsetT = joined((joined.NumStreamlines == numstreams) & (joined.ResearchGroup == researchgroup), :);
            bar2 = std(subsetT(:,6:89)) ./ mean(subsetT(:,6:89));
            nexttile;
            bar(1:84,[table2array(bar2); table2array(bar1)],'stacked'); title(numstreams)

        end
end
