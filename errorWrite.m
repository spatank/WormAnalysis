function [] = errorWrite(message)
% errorWrite Writes error message to text file

    stat_file = 'C:\WormWatcher\analysis.txt';
    fid = fopen(stat_file,'at');
    fprintf(fid, '%s\n', message);
    fclose(fid);

end

