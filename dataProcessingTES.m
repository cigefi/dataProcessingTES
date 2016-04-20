% Function dataProcessingTES
%
% Prototype: dataProcessingTES(dirName)
%
% dirName = Path of the directory that contents the files and path for the
% processed files
function [dCO2,dH2O,dHDO,dO3,mCO2,mH2O,mHDO,mO3] = dataProcessingTES(dirName,dCO2,dH2O,dHDO,dO3,mCO2,mH2O,mHDO,mO3)
    switch nargin
        case 1
            dCO2 = [];
            dH2O = [];
            dHDO = [];
            dO3 = [];
            mCO2 = [];
            mH2O = [];
            mHDO = [];
            mO3 = [];
    end
    
    dirData = dir(char(dirName(1)));  % Get the data for the current directory
    path = java.lang.String(dirName(1));
    if(path.charAt(path.length-1) ~= '/')
        path = path.concat('/');
    end
    if(length(dirName)>1)
        save_path = java.lang.String(dirName(2));
        if(length(dirName)>2)
            logPath = java.lang.String(dirName(3));
        else
            logPath = java.lang.String(dirName(2));
        end
	else
		save_path = java.lang.String(dirName(1));
		logPath = java.lang.String(dirName(1));
    end
    if(save_path.charAt(save_path.length-1) ~= '/')
        save_path = save_path.concat('/');
    end
    if(logPath.charAt(logPath.length-1) ~= '/')
        logPath = logPath.concat('/');
    end
    variables = {'CO2','H2O','HDO','O3'};
    for f = 3:length(dirData)
        fileT = path.concat(dirData(f).name);
        ext = fileT.substring(fileT.lastIndexOf('.')+1);
        if(ext.equalsIgnoreCase('he5'))
            try
                info = h5info(char(fileT));
                groups = info.Groups(1).Groups(2).Groups.Groups;
                names = extractfield(groups.Datasets,'Name');
                var2Read = NaN;
                for d = 1:4
                    p = findPos(char(variables(d)),names);
                    if ~isnan(p)
                        var2Read = char(names(p));
                    end
                end
                if isnan(var2Read)
                    continue;
                end
                varPath = char(strcat(groups.Name,'/',var2Read));
                o = double(readFile(char(fileT),varPath));
                if ~isempty(o)
                    switch(var2Read)
                        case 'CO2'
                            if isDaily(info)
                                dCO2 = cat(3,dCO2,o);
                            else
                                mCO2 = cat(3,mCO2,o);
                            end
                        case 'H2O'
                            if isDaily(info)
                                dH2O = cat(3,dH2O,o);
                            else
                                mH2O = cat(3,mH2O,o);
                            end
                        case 'HDO'
                            if isDaily(info)
                                dHDO = cat(3,dHDO,o);
                            else
                                mHDO = cat(3,mHDO,o);
                            end
                        case 'O3'
                            if isDaily(info)
                                dO3 = cat(3,dO3,o);
                            else
                                mO3 = cat(3,mO3,o);
                            end
                    end
                end
            catch exception
                if(exist(char(logPath),'dir'))
                    fid = fopen(strcat(char(logPath),'log.txt'), 'at+');
                    fprintf(fid, '[ERROR][%s] %s\n %s\n\n',char(datetime('now')),char(fileT),char(exception.message));
                    fclose(fid);
                end
                continue;
            end
        else
            if isequal(dirData(f).isdir,1)
                newPath = char(path.concat(dirData(f).name));
                [dCO2,dH2O,dHDO,dO3] = dataProcessingTES({newPath,char(save_path.concat(dirData(f).name)),char(logPath)},dCO2,dH2O,dHDO,dO3,mCO2,mH2O,mHDO,mO3);
            end
        end
    end
end

function [pos] = findPos(key,values)
    pos = NaN;
    c = 1;
    for i = values
        if strcmp(key,i)
            pos = c;
            break;
        end
        c = c + 1;
    end
end

function [out] = isDaily(info)
    out = 0;
    values = extractfield(info.Groups(1).Groups(2).Groups.Attributes,'Name');
    for i = values
        if strcmp('MonthlyL3Algorithm',i)
            out = 1;
            break;
        end
    end
end

function [out] = readFile(fileName,var2Read)
    out = [];
    missingValue = -999;
    try
        out = h5read(fileName,var2Read);
        out(out<=missingValue) = NaN;
    catch exception
        if(exist(char(logPath),'dir'))
            fid = fopen(strcat(char(logPath),'log.txt'), 'at+');
            fprintf(fid, '[ERROR][%s] %s\n %s\n\n',char(datetime('now')),char(fileT),char(exception.message));
            fclose(fid);
        end
    end
    disp(char(strcat('Data saved: ',{' '},fileName)));
end