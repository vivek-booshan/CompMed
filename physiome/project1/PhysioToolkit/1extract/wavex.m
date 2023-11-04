function [] = wavex(caseid,indir,outf)
% WAVEX Arterial blood pressure waveform extractor.
%   WAVEX(CASEID,INDIR,OUTF) extracts entire ABP waveform of CASEID in the 
%   directory INDIR, then store as MAT-file named OUTF.
%
%   In:   CASEID (integer)  e.g. caseid=3784;
%         INDIR  (string)   e.g. indir='170/';
%         OUTF   (string)   e.g. outf='/tmp/p170';
%
%   Out:  OUTF.mat  Within this MAT-file, there are variables:
%         abp* --- continuous abp waveform segments
%         t0   --- col 1: initial time of each ABP segment
%                      2: # of samples of each ABP segment
%         source_file --- cell array containing WFDB file name of ABP segs
%         
%   Usage:
%   - Make sure wfdb package is installed for linux
%   - wfdb_tools for MATLAB is required
%
%   Written by James Sun (xinsun@mit.edu) on Nov 19, 2005.
%   - v1.1 - 12/20/05 - 3rd input arg is now a filename
%   - v1.2 - 01/19/06 - code review update


%% input checks
if nargin~=3
    error('3 arguments required, try wavex(170,''170/'',''/tmp/'');');
end

if ~exist('WFDB_isigopen','file')
    error('WFDB_tools for MATLAB, a required component, is not in MATLAB search path');
end


% 1st arg (caseid) checks
if ~isequal(size(caseid),[1 1]) || ~isnumeric(caseid)
    error('caseid (1st arg) must be an integer, try wavex(170,''170/'',''/tmp/'');');
end

if caseid<100 || caseid>219
    error('caseid (1st arg) out of range');
end

if ~isequal(caseid,round(caseid))
    error('invalid caseid (1st arg)');
end


% 2nd arg checks
if ~ischar(indir)
    error('2nd arg must be a string, try wavex(170,''170/'',''/tmp/'');');
end

if ~isequal('/',indir(end))
    indir = [indir '/'];
end

caseidstr = num2str(caseid,'%05.0f');
fname     = sprintf('%s%s',indir,caseidstr);
[e,b] = system(['wfdbdesc ' fname]);
if e~=0
    error('The following failed to execute in your unix: \n ''wfdbdesc %s'' \n Either ''wfdbdesc'' is not installed, \n or the directory ''%s'' is invalid', fname,fname);
end


% 3rd arg checks
if ~ischar(outf)
    error('3rd arg must be a string, try wavex(170,''170/'',''/tmp/p170'');');
end

try
    save(outf);
    delete(outf);
catch
    error('Invalid save directory (3rd arg)');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN CODE

ind=0;
i=0;
% loops to find abp segments from each WFDB file
while 1
    i=i+1;
    
%%% open waveform segment file, if exists
    caseidstr = num2str(caseid,'%05.0f');
    segstr    = num2str(i-1,'%06.0f');
    fname     = sprintf('%s%s_%s',indir,caseidstr,segstr);

    [e,b] = system(['wfdbdesc ' fname]); % wfdbdesc tests existence
    if e~=0
        % terminate while loop if no more WFDB files exist
        break
    end

    % WFDB_isigopen is a MEX "wfdb_tools for matlab" function
    hea = WFDB_isigopen(fname);

%%% determine ABP availability
    chanABP = [];
    for k=1:length(hea)
        if isequal(hea(k).desc,'ABP')
            chanABP = k-1;
            break % terminate if channel is found
        end
    end

%%% if ABP channel is available and has >=1 min of data, grab all using rdsamp
    if chanABP
        n = hea(chanABP+1).nsamp;
        if n >= 7500  % 7500 samples = 1 min

            ind = ind+1;

            % t0 stores initial time, and # of samples
            t0(ind,1) = datenum(WFDB_timstr(0), '[HH:MM:SS dd/mm/yyyy]');
            t0(ind,2) = n;

            % abpK is the K-th segment of ABP extracted
            % rdsamp is a Linux wfdb command
            str = sprintf('!rdsamp -r %s -p -s %d > /tmp/data.txt',fname,chanABP); eval(str);
            load /tmp/data.txt
            str = sprintf('abp%d = single(data(:,2));',ind); eval(str);
            clear data
            !rm /tmp/data.txt

            % source_file is the original file name
            source_file{ind,1} = fname;
        end
    end

    WFDB_wfdbquit;
end

save(outf,'abp*','t0','source_file');
disp(sprintf('ABP waveform successfully written to %s.mat',outf));
