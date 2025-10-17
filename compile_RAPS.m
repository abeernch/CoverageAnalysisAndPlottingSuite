function compile_RAPS()
    % Main app file - specified directly in mcc command
    mainAppFile = 'D:\SC2\Projects\RAPS\devel_directory\workingDir\RAPS_GUI_gdop_250723.mlapp';
    
    % Output directory
    outputDir = 'D:\SC2\Projects\RAPS\Compiled\for_testing';
    
    % Create output directory if it doesn't exist
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end

    % Initialize cell array for all options
    allOptions = {};
    
    % Basic compilation options
    allOptions = [allOptions, {'-o', 'RAPS'}];
    allOptions = [allOptions, {'-W', 'WinMain:RAPS,version=10.3'}];
    allOptions = [allOptions, {'-T', 'link:exe'}];
    allOptions = [allOptions, {'-d', outputDir}];
    allOptions = [allOptions, {'-R', '-logfile,executionLog_CAPS'}];
    allOptions = [allOptions, {'-v'}];
    
    % Additional files to include
    additionalFiles = {
        'D:\SC2\Projects\RAPS\devel_directory\workingDir\map_services'
        'D:\SC2\Projects\RAPS\devel_directory\workingDir\report_support'
        'D:\SC2\Projects\RAPS\devel_directory\workingDir\report_support\rptgen_include.m'
        'D:\SC2\Projects\RAPS\devel_directory\workingDir\RAPS_resources\icon.ico'
    };
    
    % Add additional files with -a flag
    for i = 1:length(additionalFiles)
        allOptions = [allOptions, {'-a', additionalFiles{i}}];
    end
    
    % Required Report Generator components
    reportGenComponents = {
        'mlreportgen'
        'mlreportgen.rpt'
        'mlreportgen.report'
        'mlreportgen.dom'
        'mlreportgen.utils'
        fullfile(matlabroot, 'toolbox', 'shared', 'rptgen', 'resources', 'fontmap')
        fullfile(matlabroot, 'toolbox', 'shared', 'rptgen', 'resources', 'stylesheets')
    };
    
    % Add Report Generator components with -a flag
    for i = 1:length(reportGenComponents)
        allOptions = [allOptions, {'-a', reportGenComponents{i}}];
    end
    
    % Add main application file (no -a flag for this one)
    allOptions = [allOptions, {mainAppFile}];
    
    % Display the command that will be executed (for debugging)
    disp('Executing compilation command:');
    disp(['mcc ' strjoin(allOptions)]);
    
    % Execute the compilation
    mcc(allOptions{:});
end