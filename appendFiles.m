function status = appendFiles(readFile, writtenFile)
% append readFile to writtenFile
% https://www.mathworks.com/matlabcentral/answers/
% 98758-how-can-i-prepend-text-to-a-file-using-matlab

      fr = fopen(readFile,'rt');
      fw = fopen(writtenFile,'at');
      while feof(fr) == 0
          tline = fgetl(fr);
          fwrite(fw,sprintf('%s\n',tline));
      end
      fclose(fr);
      fclose(fw);  
end

