clear all;close all;clc

%% manually set directory, number of cores, range of fish (ID) to process

M_dir = {'E:\Janelia2014\Fish1_16states_30frames';
    'E:\Janelia2014\Fish2_20140714_2_4_16states_10frames';
    'E:\Janelia2014\Fish3_20140715_1_1_16_states_10frames';
    'E:\Janelia2014\Fish4_20140721_1_8_16states_20frames';
    'E:\Janelia2014\Fish5_20140722_1_2_16states_30frames';
    'E:\Janelia2014\Fish6_20140722_1_1_3states_30,40frames';
    'E:\Janelia2014\Fish7_20140722_2_3_3states_30,50frames';
    'E:\Janelia2014\Fish8_20141222_2_2_7d_PT_3OMR_shock_lowcut';
    'E:\Janelia2014\Fish9_20150120_2_1_photo_OMR_prey_blob_blue_cy74_6d_20150120_220356';
    'E:\Janelia2014\Fish10_20150120_2_2_photo_OMR_prey_blob_blue_cy74_6d_20150120_231917'};

poolobj=parpool(4);

range_fish = 10; %1:8

%%
for i_fish = range_fish,
    disp(['i_fish = ', num2str(i_fish)]);
    
    datadir = M_dir{i_fish};
    file = fullfile(datadir,['Fish' num2str(i_fish) '_direct_load.mat']);
    load(file,'CR_raw');
    %     varList = {'CR_raw','nCells','CInfo','anat_yx','anat_yz','anat_zx','ave_stack','fpsec','frame_turn','periods'};
    
    %% detrend
    CR_dtr = zeros(size(CR_raw));
    tmax=size(CR_raw,2);
    nCells=size(CR_raw,1);
    
    tic
    parfor i=1:nCells,
        cr = CR_raw(i,:);
        crd = 0*cr;
        for j=1:100:tmax,
            if j<=150,
                tlim1 = 1;
                tlim2 = 300;
            elseif j>tmax-150,
                tlim1 = tmax-300;
                tlim2 = tmax;
            else
                tlim1 = j-150;
                tlim2 = j+150;
            end
            crr = cr(tlim1:tlim2);
            crd(max(1,j-50):min(tmax,j+50)) = prctile(crr,15);
        end
        if mod(i,100)==0,
            disp(num2str(i));
        end
        CR_dtr(i,:) = zscore(cr-crd);
    end
    toc
    
    CR_dtr = single(CR_dtr);
    
    %% save into .mat
    save(file,'CR_dtr','-append');
end

%%
delete(poolobj);
