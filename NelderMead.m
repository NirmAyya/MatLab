%F is the function
%X is the list of input coordinates
% e is tolerance
% M is maximum iterations
% alpha is alpha 
% bet is Beta
% gam is Gamma 

function result = NelderMead(F, X, e, M, alph, bet, gam)

sz = size(X, 1);
k = 0;

while (F(X{1}(1), X{1}(2)) - F(X{sz}(1), X{sz}(2)))/(max(abs(F(X{1}(1), X{1}(2))) + abs(F(X{sz}(1), X{sz}(2))), 1)) > e && k <= M
    
    % Reorder input vectors based on the output list
    list = cell(1, sz);
    for i = 1:sz
        list{i} = F(X{i});
    end
    
    % Sort the vectors based on the output list in descending order
    for i = 1:sz
        maxEl = i;
        for k = i+1:sz
            if list{maxEl} < list{k}
                maxEl = k;
            end
        end
        
        % Swap elements
        temp = list{i};
        TempVec = X{i};
        
        list{i} = list{maxEl};
        X{i} = X{maxEl};
        
        list{maxEl} = temp;
        X{maxEl} = TempVec;
    end
    
    % Calculate the centroid
    u = zeros(size(X{1}));
    for i = 2:sz
        u = u + X{i};
    end
    u = (1/sz) * u;
    
    % Calculate the reflection
    v = (1 + alph) * u - (alph * X{1});
    Fv = F(v);
    
    if Fv < F(X{sz}) % Case 1
        % Compute expansion
        w = (1 + gam) * v - (gam * u);
        Fw = F(w);
        if Fw < F(X{sz}) % Case 2
            X{1} = w;
        else
            X{1} = v;
        end
    else
        if Fv <= F(X{2}) % Case 3
            X{1} = v;
        else
            b = F(X{1});
            if Fv <= b % Case 4
                X{1} = v;
            end
            
            % Reduction
            w = bet * X{1} + (1 - bet) * u;
            Fw = F(w);
            
            if Fw <= b % Case 5
                X{1} = w;
            else
                for i = 2:sz-1 % Case 6
                    X{i} = (X{i} + X{sz}) / 2;
                end
            end
            
        end
    end
    
    k = k + 1;
end

result = X{sz};

end
