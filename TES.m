function [] = TES(dirName)
    if nargin < 1
        error('TES: dirName is a required input')
    else
        dirName = strrep(dirName,'\','/'); % Clean dirName var
    end
    if(length(dirName)>1)
        save_path = java.lang.String(dirName(2));
	else
		save_path = java.lang.String(dirName(1));
    end
    if(save_path.charAt(save_path.length-1) ~= '/')
        save_path = save_path.concat('/');
    end
    [dCO2,dH2O,dHDO,dO3,mCO2,mH2O,mHDO,mO3] = dataProcessingTES(dirName);
    if ~isempty(dCO2)
        save(char(strcat(save_path,'CO2-daily.mat')),'dCO2');
        %dlmwrite(strcat(char(save_path),'CO2.dat'),dCO2);
    end
    if ~isempty(dH2O)
        save(char(strcat(save_path,'H2O-daily.mat')),'dH2O');
        %dlmwrite(strcat(char(save_path),'H2O.dat'),dH2O);
    end
    if ~isempty(dHDO)
        save(char(strcat(save_path,'HDO-daily.mat')),'dHDO');
        %dlmwrite(strcat(char(save_path),'HDO.dat'),dHDO);
    end
    if ~isempty(dO3)
        save(char(strcat(save_path,'O3-daily.mat')),'dO3');
        %dlmwrite(strcat(char(save_path),'O3.dat'),dO3);
    end
    if ~isempty(mCO2)
        save(char(strcat(save_path,'CO2-monthly.mat')),'mCO2');
        %dlmwrite(strcat(char(save_path),'CO2.dat'),mCO2);
    end
    if ~isempty(mH2O)
        save(char(strcat(save_path,'H2O-monthly.mat')),'mH2O');
        %dlmwrite(strcat(char(save_path),'H2O.dat'),mH2O);
    end
    if ~isempty(mHDO)
        save(char(strcat(save_path,'HDO-monthly.mat')),'mHDO');
        %dlmwrite(strcat(char(save_path),'HDO.dat'),mHDO);
    end
    if ~isempty(mO3)
        save(char(strcat(save_path,'O3-monthly.mat')),'mO3');
        %dlmwrite(strcat(char(save_path),'O3.dat'),mO3);
    end
end