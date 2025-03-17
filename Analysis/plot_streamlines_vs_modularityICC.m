tbl = readtable("Global_Prob_freesurfer.csv");


% for global measure, plot a line with x as streamline count and y as ICC
% have a different line for each algorithm

algoname = 'iFOD2'
atlasname = 'freesurfer'
numstreams = 2000000
researchgroup = 'AD'

figure;
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880;0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880];
c_ = [0.4940 0.1840 0.5560]; % [0.4940 0.1840 0.5560]
c_index = 0; % blue red gree, determ is dashed
linestyle = {"-","--",":"};
for atlasname = {'hcpmmp1','freesurfer','slant'}
    tbl = readtable("Global_SIFT2_"+atlasname+".csv");
    c_index = c_index+1
    disp(atlasname)
    %for algoname = {'SDSTREAM','iFOD22','SIFT','Thresholding'}
    temp = zeros(6,1);
    i=0;
    %disp(algoname)
    for numstreams = [10000, 1000000, 2000000, 4000000, 5000000, 10000000]
        i=i+1;
        %disp(numstreams)
        subsetT = tbl((tbl.NumStream == numstreams) & strcmp(tbl.DX ,researchgroup), :);
        % make 5x20 matrix (5 repeats, 20 patients)
        
        %a = zeros(5,19);
        a = zeros(5,20);
        for repeat=[1:5]                
            a(repeat,:) = subsetT.Modularity(subsetT.Iteration == repeat);
        end
        temp(i) = ICC(transpose(a),'1-1'); %wCV(a);

    end
    hold on; ylim([0 1]); xlim([1 6]);   ylabel('Modularity');
    xlabel('Streamline count');  xticks([1:6]); xticklabels({10000, 1000000, 2000000, 4000000, 5000000, 10000000});
    plot(temp, 'LineStyle',linestyle{c_index}, 'Color',c_); %,'Color',c(c_index,:))

    %end
end
    
%figure;
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880;0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880];
c_ = [0 0.4470 0.7410]; % [0.4940 0.1840 0.5560]
c_index = 0; % blue red gree, determ is dashed
linestyle = {"-","--",":"};
for atlasname = {'hcpmmp1','freesurfer','slant'}
    tbl = readtable("Global_Prob_"+atlasname+".csv");
    c_index = c_index+1
    disp(atlasname)
    %for algoname = {'SDSTREAM','iFOD22','SIFT','Thresholding'}
    temp = zeros(6,1);
    i=0;
    %disp(algoname)
    for numstreams = [10000, 1000000, 2000000, 4000000, 5000000, 10000000]
        i=i+1;
        %disp(numstreams)
        subsetT = tbl((tbl.NumStream == numstreams) & strcmp(tbl.DX ,researchgroup), :);
        % make 5x20 matrix (5 repeats, 20 patients)
        
        a = zeros(5,19);
        %a = zeros(5,20);
        for repeat=[1:5]                
            a(repeat,:) = subsetT.Modularity(subsetT.Iteration == repeat);
        end
        temp(i) = ICC(transpose(a),'1-1'); %wCV(a);

    end
    hold on; ylim([0 1]); xlim([1 6]);   ylabel('Modularity');
    xlabel('Streamline count');  xticks([1:6]); xticklabels({10000, 1000000, 2000000, 4000000, 5000000, 10000000});
    plot(temp, 'LineStyle',linestyle{c_index}, 'Color',c_); %,'Color',c(c_index,:))

    %end
end


c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880;0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880];
c_ = [0.8500 0.3250 0.0980]; % [0.4940 0.1840 0.5560]
c_index = 0; % blue red gree, determ is dashed
linestyle = {"-","--",":"};
for atlasname = {'hcpmmp1','freesurfer','slant'}
    tbl = readtable("Global_Determ_"+atlasname+".csv");
    c_index = c_index+1
    disp(atlasname)
    %for algoname = {'SDSTREAM','iFOD22','SIFT','Thresholding'}
    temp = zeros(6,1);
    i=0;
    %disp(algoname)
    for numstreams = [10000, 1000000, 2000000, 4000000, 5000000, 10000000]
        i=i+1;
        %disp(numstreams)
        subsetT = tbl((tbl.NumStream == numstreams) & strcmp(tbl.DX ,researchgroup), :);
        % make 5x20 matrix (5 repeats, 20 patients)
        
        %a = zeros(5,19);
        a = zeros(5,20);
        for repeat=[1:5]                
            a(repeat,:) = subsetT.Modularity(subsetT.Iteration == repeat);
        end
        temp(i) = ICC(transpose(a),'1-1'); %wCV(a);

    end
    hold on; ylim([0 1]); xlim([1 6]);   ylabel('Modularity');
    xlabel('Streamline count');  xticks([1:6]); xticklabels({10000, 1000000, 2000000, 4000000, 5000000, 10000000});
    plot(temp, 'LineStyle',linestyle{c_index}, 'Color',c_); %,'Color',c(c_index,:))

    %end
end


c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880;0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880];
c_ = [0.4660 0.6740 0.1880]; % [0.4940 0.1840 0.5560]
c_index = 0; % blue red gree, determ is dashed
linestyle = {"-","--",":"};
for atlasname = {'hcpmmp1','freesurfer','slant'}
    tbl = readtable("Global_ThreshProb_"+atlasname+".csv");
    c_index = c_index+1
    disp(atlasname)
    %for algoname = {'SDSTREAM','iFOD22','SIFT','Thresholding'}
    temp = zeros(6,1);
    i=0;
    %disp(algoname)
    for numstreams = [10000, 1000000, 2000000, 4000000, 5000000, 10000000]
        i=i+1;
        %disp(numstreams)
        subsetT = tbl((tbl.NumStream == numstreams) & strcmp(tbl.DX ,researchgroup), :);
        % make 5x20 matrix (5 repeats, 20 patients)
        
        a = zeros(5,19);
        %a = zeros(5,20);
        for repeat=[1:5]                
            a(repeat,:) = subsetT.Modularity(subsetT.Iteration == repeat);
        end
        temp(i) = ICC(transpose(a),'1-1'); %wCV(a);

    end
    hold on; ylim([0 1]); xlim([1 6]);   ylabel('Modularity');
    xlabel('Streamline count');  xticks([1:6]); xticklabels({10000, 1000000, 2000000, 4000000, 5000000, 10000000});
    plot(temp, 'LineStyle',linestyle{c_index}, 'Color',c_); %,'Color',c(c_index,:))

    %end
end


