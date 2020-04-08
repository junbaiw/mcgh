function pOut = use_mcgh(add)
% USE_MCGH  get ready to use the M-CGH toolbox
% 
% To begin using the M-CGH, call USE_MCGH. If you use the M-CGH all
% the time, it would be a good idea to call USE_MCGH in your startup.m
% file.
% 
% USE_MCGH
% USE_MCGH(1)
%     Adds the M-CGH subdirectories to the MATLAB search path, and also
%     sets up the default global options.
% 
% USE_MCGH(0)
%     Removes the M-CGH subdirectories from the MATLAB search path.
% 
% P = USE_MCGH
%     Does not add or remove paths, but returns a cell array of path
%     strings that would be added. They can then be added or removed
%     manually with ADDPATH(P{:}) or RMPATH(P{:}). Global options are not
%     set up.
% This is a modified version of use_spider from SPIDER toolbox for matlab
% Modified by Junbai Wang , Nov. 2006
%
if nargin < 1, add = 1; end

if nargin<1
disp(' ');
disp('M-CGH : an Array-CGH analysis toolbox for Matlab(R).');
disp(' ');
disp('This program is free software; you can redistribute it and/or');
disp('modify it under the terms of the GNU General Public License');
disp('as published by the Free Software Foundation; either version 1');
disp('of the License, or (at your option) any later version.');
disp(' ');
disp('This program is distributed in the hope that it will be useful,');
disp('but WITHOUT ANY WARRANTY; without even the implied warranty of');
disp('MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the');
disp('GNU General Public License for more details:');
disp('http://www.gnu.org/copyleft/gpl.html');
disp(' ');
disp(' ');
end


if datenum(version('-date')) >= datenum('May 6 2004')
 % look at this lovely mutual incompatibility between R14+ and previous releases
 % well done MathWorks, you've made our lives needlessly difficult AGAIN!
 d = dbstack('-completenames');
 rootdir = fileparts(d(1).file);
else
 d = dbstack; 
 rootdir = fileparts(d(1).name);
end   

%%might be a relative path: convert to absolute
olddir = pawd; cd(rootdir), rootdir = pawd; cd(olddir)

subdirs = {
        '.'
};

for i = 1:length(subdirs)
        s = cellstr(subdirs{i});
        subdirs{i} = fullfile(rootdir, s{:});
end

if nargout, pOut = subdirs; return, end
if ~add
        if datenum(version('-date')) >= datenum('June 18 2002')
        ws = warning('off', 'MATLAB:rmpath:DirNotFound');
    end

    rmpath(subdirs{:});
        
    if datenum(version('-date')) >= datenum('June 18 2002')
            warning(ws)
    end
        return
end

% addpath(rootdir, subdirs{:})
addpath(subdirs{:})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = updir(d)
d = fileparts(d);
if d(end)==filesep, d(end) = []; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d = pawd(d)

if nargin < 1
        if isunix
                [d err] = syscmd('echo $PWD'); % better (non-)resolution of symlinks, /.amd_mnt etc
                if ~isempty(err), d = pwd; end
        else
                d = pwd;
        end 
end
if ~isunix, return, end
[dd err] = syscmd(['pawd ''' d '''']);
if isempty(err), d = dd; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [str, err] = syscmd(cmd)

err = '';
[failed str] = system(cmd);
str = deblank(str);
if failed
        err = sprintf('system call failed:\n%s\n%s', cmd, str);
        str = '';
        if nargout < 2, error(err), end
end

