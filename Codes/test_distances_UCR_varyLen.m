% Here we test some distances on the UCR dataset, their lengths are
% modified to make variable length datasets
% The following distances are tested : DTW, cDTW, wDTW, DDTW, LCSS, EDR,
% TWE, SBD, MSM, SWALE

% The datasets we process here are:
% Beef
% CBF
% FaceFour
% Lightning7
% Plane
% SwedishLeaf
% Symbols
% SyntheticControl
% Trace
% SmoothSubspace

close all
clear
clc

% Read file
dataset = importdata("../Datasets/UCR_varyLen/Beef_varyLen.txt");

% Get labels
labels = dataset{end};
dataset = dataset(1:end-1);


% Calculate distances
parameters = [1];
%parameters = 10;
J_all = ones(length(parameters), max(labels));
pp = 1;
for p = parameters
    % Calculer les distances entre toutes les time series
    distance = ones(length(dataset), length(dataset));
    for i = 1:length(dataset)
        for j = 1:length(dataset)
            % dtw
            %distance(i,j) = dtw(dataset{i}, dataset{j});
            % sbd
            %distance(i,j) = SBD_univariate(dataset{i}, dataset{j});
            % edr
            %distance(i,j) = edr(dataset{i}, dataset{j}, p);
            % lcss
            %distance(i,j) = lcss(dataset{i}, dataset{j}, p);
            % msm
            %distance(i,j) = msm(dataset{i}, dataset{j}, p);
            % twe
            %distance(i,j) = twed(dataset{i}, dataset{j}, 1, p);
            % cDTW
            %distance(i,j) = cDTW(dataset{i}, dataset{j}, p);
            % wDTW
            %distance(i,j) = wDTW(dataset{i}, dataset{j}, p);
            % DDTW
            %distance(i,j) = DDTW(dataset{i}, dataset{j});
            % swale
            distance(i,j) = swale(dataset{i}, dataset{j}, p, 10, 1);
        end
        [p,i]
    end

    % Vectorize results ------------------------------------------------
    
    % Distances of intra-classes
    A = tril(distance);
    classes_intra = [];
    
    k_labels = max(labels)-1;
    for k = 0:k_labels
        indices = find(labels == k+1);
        k_nb = length(find(labels == k+1));
        r = 1;
        for m = indices(1):indices(end)
            for n = indices(1):indices(end)
                if m ~= n
                    if distance(m,n) ~= Inf
                        classes_intra(k+1,r) = distance(m,n);
                        r = r + 1;
                    end
                end
            end
        end
    end
    
    % Distances of extra-classes
    classes_extraa = [];
    classes_extra = [];
    for k = 0:k_labels
        indices2 = [];
        indices2 = find(labels ~= k+1)';
        rr = 1;
        for m = indices2
            for n = indices2
                if m ~= n
                    if distance(m,n) ~= Inf
                        classes_extra(k+1,rr) = distance(m,n);
                        rr = rr + 1;
                    end
                end
            end
        end
    end


    
    % Calculate the coefficient of Youden (J) -----------------------
    
    maxDK = max(classes_intra');
    minDKbar = min(classes_extra');
    NDK = size(classes_intra, 2);
    NDKbar = size(classes_extra, 2);
     
    %Pk = sum((classes_intra(:,:) <= minDKbar(:))');
    %Qk = sum((classes_extra(:,:) >= maxDK(:))');
    TP = sum((classes_intra(:,:) < minDKbar(:))'); % TP : bon motifs bien classés dans k
    TN = sum((classes_extra(:,:) > maxDK(:))'); % TN : mauvais motifs bien classés hors k
    FP = NDK - TP; % FP : bon motifs mal classés hors k
    FN = NDKbar - TN; % FN : mauvais motifs mal classés dans k
    TPR = (TP)./(TP + FN);
    TNR = (TN)./(TN + FP);
    
    %Rk = (Pk + Qk) / (NDK + NDKbar)
    J = TPR + TNR - 1

    J_all(pp, 1:length(J)) = J;
    pp = pp + 1


    % Représentations des distances par leurs distributions -------------------
    
    % Matrice de confusion
    figure(pp)
    %sgtitle(['MSM, c = ', num2str(p)])
    %sgtitle(['TWE, lambda = 0.5, nu = ', num2str(p)])
    sgtitle(['SWALE, e = ', num2str(p), ', p = 5, r = 1'])
    %sgtitle('DDTW')
    imagesc(distance)
    colorbar
end

