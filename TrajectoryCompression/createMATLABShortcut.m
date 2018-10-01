function createMATLABShortcut(jvmpath)
%CREATEMATLABSHORTCUT
%   CREATEMATLABSHORTCUT(JVMPATH) creates a shortcut to start MATLAB on the
%   Desktop with a changed JVM path. If the input argument JVMPATH is
%   given, that path is used in the generated script. If JVMPATH is not
%   given a default path of:
%   /Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
%   will be used.
%   This path is the location where Oracle's Java 7 is installed by default.
%

outputFilename = ['~/Desktop/MATLAB_R' version('-release') '_JVMstarter.app'];

if exist(outputFilename, 'file')
    error('createMATLABShortcut:targetExists', ['Destination file already exists, please (re)move file: ' outputFilename]);
end

if nargin < 1
    jvmpath = '/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home';
end

% verify if jvmpath contains a 'bin' and a 'lib' directory
bindir = fullfile(jvmpath, 'bin');
libdir = fullfile(jvmpath, 'lib');

if ~exist(bindir, 'dir') || ~exist(libdir, 'dir')
    msg = ['Could not find a ''dir'' and ''lib'' directory in %s. Please verify that\n' ...
           'a Java JRE is installed.'];
    error('createMATLABShortcut:jvmpathInvalid', msg, jvmpath);
end

% create Applescript
shellcmd = ['/bin/bash -c ''export MATLAB_JAVA=\"' jvmpath '\"; open ' matlabroot ''''];
scriptContents = ['do shell script "' shellcmd '"'];
fid = fopen('startMATLAB.scpt', 'w');
if fid == -1
    error('createMATLABShortcut:fopenFailed', 'Could not open temporary file startMATLAB.scpt for writing.');
end
fwrite(fid, scriptContents);
fclose(fid);

% create .app to start MATLAB
system(['osacompile -o ' outputFilename ' -x startMATLAB.scpt']);

% delete temporary file
delete('startMATLAB.scpt');

% copy MATLAB icon from MATLAB to startup script and select it
copyfile(fullfile(matlabroot, 'Contents', 'Resources', 'MATLAB.icns'), fullfile(outputFilename, 'Contents', 'Resources', 'MATLAB.icns'))
system(['defaults write ' fullfile(outputFilename, 'Contents', 'Info') ' CFBundleIconFile MATLAB']);
% refresh icon for shortcut
system(['touch ' outputFilename]);