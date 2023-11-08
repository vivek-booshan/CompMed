function k = calib(r, x, method)
% Calibration function

if isempty(x)
    k = nan;
    return
end

switch method
    case 1  % Optimal MMSE calibration
        k = r'*x/(x'*x);
        
    case 2  % Online Optimal
        k = zeros(length(x),1);
        for j=2:length(x)
            r_prev = r(1:j-1);
            x_prev = x(1:j-1);
            k(j)   = r_prev' * x_prev / (x_prev'*x_prev);
        end
        k(1) = k(2);
        
    case 3  % 1st pt calibration
        k = r(1)/x(1);
        
    case 4  % Previous pt calibration
        k = r./x;
        k = [k(1); k(1:end-1)];
        
    case 5  % not really calibrating, just normalize
        k = 1/x(1);
        
    otherwise
        k = 1;
end