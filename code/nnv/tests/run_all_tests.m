% execute all tests recursively on subdirectories from this directory
function run_all_tests()
    dirNames = strtrim(strrep(string(ls),'"',''));
    for i_d = 1 : length(dirNames)
        d = dirNames(i_d);
        if isdir(d) && ~(strcmp(d,'.') || strcmp(d,'..'))
            run_all_tests_inDir(d);
            cd(d);
            run_all_tests; % recursive call
            cd('..');
        end
    end

end