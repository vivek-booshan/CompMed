function y = trendex(caseid,fname,trend)
% TRENDEX MIMIC II trend extractor
%   Y = TRENDEX(CASEID,FNAME,TREND) extracts TREND of CASEID from file FNAME.
%
%   In:   caseid (integer)  e.g. caseid=1234;
%         fname  (string)   e.g. fname='foo';
%         trend             e.g. trend='CO' or trend='HR' or trend='all';
%
%   Out:  <1x1> struct
%          Y.caseid --- caseid
%          Y.t0     --- absolute starting time of record (datenum format)
%          Y.CO     --- <kx2> matrix containing time offset (minutes) from 
%                       beginning of record and corresponding CO (L/min)
%          Y...     --- examine the struct for more possible trends
%
%   Usage:
%   - Make sure wfdb package is installed for linux
%   - wfdb_tools for MATLAB is required
%   - if 3rd argument is 'all', then all trends of CASEID are obtained
%
%   Written by James Sun (xinsun@mit.edu) on Nov 19, 2005.
%   - v2.0 - 01/03/06 - 3rd arg now takes input 'all'
%                     - output is now a struct
%   - v2.1 - 01/19/06 - code review update


%% input checks
if nargin~=3
    error('3 arguments required');
end

if ~exist('WFDB_isigopen','file')
    error('WFDB_tools for MATLAB, a required component, is not in MATLAB search path');
end


% 1st arg checks
if ~isequal(size(caseid),[1 1]) || ~isnumeric(caseid)
    error('1st arg must be an integer');
end

if ~isequal(caseid,round(caseid))
    error('invalid caseid (1st arg)');
end


% 2nd arg checks
if ~ischar(fname)
    error('2nd arg must be a string');');
end

if isequal('/',fname(end))
    fname(end)=[];
end

[e,b] = system(['wfdbdesc ' fname]);
if e~=0
    error('The following failed to execute in your unix: \n ''wfdbdesc %s'' \n Either ''wfdbdesc'' is not installed, \n or the directory ''%s'' is invalid', fname,fname);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN CODE

y=[];
% WFDB_isigopen is a MEX "wfdb_tools for matlab" function
hea = WFDB_isigopen(fname);

% Only extract if trend is found
if isequal('all',trend)
    mofo = WFDB_getvec(length(hea)); % "wfdb_tools for matlab" function
    
    y.caseid = single(caseid);
    y.t0     = datenum(WFDB_timstr(0), '[HH:MM:SS dd/mm/yyyy]');  % t0
    for i=1:length(hea)
        
        x = mofo(:,i);
        min_offset = find(x>0)-1;
        x = x(x>0)/hea(i).gain;  % find positive and convert to physiologic units
     
        y = setfield(y,hea(i).desc, single([min_offset x]));
    end
else
    for i=1:length(hea)
        if isequal(hea(i).desc,trend)
            x = WFDB_getvec(i);
            %pause(1);
            x = x(:,i);
            min_offset = find(x>0)-1;
            x = x(x>0)/hea(i).gain;  % find positive and convert to physiologic units

            y.caseid = single(caseid);                                    % caseid
            y.t0     = datenum(WFDB_timstr(0), '[HH:MM:SS dd/mm/yyyy]');  % t0
            y        = setfield(y,hea(i).desc, single([min_offset x]));   % offset and co
            break
        end
    end
end
WFDB_wfdbquit;
