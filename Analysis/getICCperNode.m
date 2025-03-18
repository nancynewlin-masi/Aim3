% Create LUT of nodes and their intensities, intensity based on COV/ICC
c = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880;0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880];
c_ = [0.4660 0.6740 0.1880]; % [0.4940 0.1840 0.5560]
 % blue red purple egreen determ is dashed
researchgroup = 'AD';
c_index = 0;
linestyle = {"-","--",":"};
figure;
t = tiledlayout("flow");
l_index = 0;
ans = []
for atlasname = {'hcpmmp1','freesurfer','slant'}
    l_index = l_index+1;
    
    c_index = 0;%l_index = 0;
    nexttile;
    for algo = {"Prob","Determ","SIFT2","ThreshProb"}
        c_index = c_index+1;
        tbl = readtable("Deg_"+algo+"_"+atlasname+".csv");
        tbl = readtable("COV_"+algo+"_"+atlasname+".csv");
        
        disp(atlasname);
        %for algoname = {'SDSTREAM','iFOD22','SIFT','Thresholding'}
        temp = zeros(6,1);
        i=0;
        %disp(algoname)
        for numstreams = [10000, 1000000, 2000000, 4000000, 5000000, 10000000]
            i=i+1;
            %disp(numstreams)
            subsetT = tbl((tbl.NumStream == numstreams) & strcmp(tbl.DX ,researchgroup), :);
            % make 5x20 matrix (5 repeats, 20 patie\][ts)
            
            %a = zeros(5,19);
            %a = zeros(5,20);
            for node=6:width(subsetT)
                for repeat=[1:5]                
                    a(repeat,:) = table2array(subsetT(subsetT.Iteration == repeat,node));
                end
                temp(i,node-5) = ICC(transpose(a),'1-1'); %wCV(a);
                ans = [ans; [algo, atlasname, numstreams, node, ICC(transpose(a),'1-1')]];
            end
            clear a
        end
        hold on; ylim([0 1]); xlim([1 6]);   ylabel('Degree');
        xlabel('Streamline count');  xticks([1:6]); xticklabels({10000, 1000000, 2000000, 4000000, 5000000, 10000000});
        plot(temp, 'LineStyle',linestyle{l_index}, 'Color',c(c_index,:));alpha(.5);
        alpha(.5);
        %disp("Stop 1")
        %end
    end
end
