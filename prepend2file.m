function prepend2file(string,filename)
% https://www.mathworks.com/matlabcentral/answers/
% 98758-how-can-i-prepend-text-to-a-file-using-matlab

      tempFile = tempname;
      fw = fopen(tempFile,'wt');
      fwrite(fw,sprintf('%s\n',string));
      fclose(fw);
      appendFiles(filename,tempFile);
      copyfile(tempFile,filename);
      delete(tempFile);
end

