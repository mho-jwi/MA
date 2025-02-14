function MessungH4 = import_RAW_file2Strings(filename, startRow, endRow)
%Imports numeric data from a multitool text file as a matrix for SAG_Typtest.
%   MESSUNGH4 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   MESSUNGH4 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   MessungH4 = importfile('2014_01_29_Messung_H4.csv', 1, 715);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2014/01/29 07:00:15

%% Initialize variables.
delimiter = ';';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: text (%s)
%   column3: text (%s)
%	column4: text (%s)
%   column5: text (%s)
%	column6: text (%s)
%   column7: text (%s)
%	column8: text (%s)
%   column9: text (%s)
%	column10: text (%s)
%   column11: text (%s)
%	column12: text (%s)
%   column13: text (%s)
%	column14: text (%s)
%   column15: text (%s)
%	column16: text (%s)
%   column17: text (%s)
%	column18: text (%s)
%   column19: text (%s)
%	column20: text (%s)
%   column21: text (%s)
%	column22: text (%s)
%   column23: text (%s)
%	column24: text (%s)
%   column25: text (%s)
%	column26: text (%s)
%   column27: text (%s)
%	column28: text (%s)
%   column29: text (%s)
%	column30: text (%s)
%   column31: text (%s)
%	column32: text (%s)
%   column33: text (%s)
%	column34: text (%s)
%   column35: text (%s)
%	column36: text (%s)
%   column37: text (%s)
%	column38: text (%s)
%   column39: text (%s)
%	column40: text (%s)
%   column41: text (%s)
%	column42: text (%s)
%   column43: text (%s)
%	column44: text (%s)
%   column45: text (%s)
%	column46: text (%s)
%   column47: text (%s)
%	column48: text (%s)
%   column49: text (%s)
%	column50: text (%s)
%   column51: text (%s)
%	column52: text (%s)
%   column53: text (%s)
%	column54: text (%s)
%   column55: text (%s)
%	column56: text (%s)
%   column57: text (%s)
%	column58: text (%s)
%   column59: text (%s)
%	column60: text (%s)
%   column61: text (%s)
%	column62: text (%s)
%   column63: text (%s)
%	column64: text (%s)
%   column65: text (%s)
%	column66: text (%s)
%   column67: text (%s)
%	column68: text (%s)
%   column69: text (%s)
%	column70: text (%s)
%   column71: text (%s)
%	column72: text (%s)
%   column73: text (%s)
%	column74: text (%s)
%   column75: text (%s)
%	column76: text (%s)
%   column77: text (%s)
%	column78: text (%s)
%   column79: text (%s)
%	column80: text (%s)
%   column81: text (%s)
%	column82: text (%s)
%   column83: text (%s)
%	column84: text (%s)
%   column85: text (%s)
%	column86: text (%s)
%   column87: text (%s)
%	column88: text (%s)
%   column89: text (%s)
%	column90: text (%s)
%   column91: text (%s)
%	column92: text (%s)
%   column93: text (%s)
%	column94: text (%s)
%   column95: text (%s)
%	column96: text (%s)
%   column97: text (%s)
%	column98: text (%s)
%   column99: text (%s)
%	column100: text (%s)
%   column101: text (%s)
%	column102: text (%s)
%   column103: text (%s)
%	column104: text (%s)
%   column105: text (%s)
%	column106: text (%s)
%   column107: text (%s)
%	column108: text (%s)
%   column109: text (%s)
%	column110: text (%s)
%   column111: text (%s)
%	column112: text (%s)
%   column113: text (%s)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.
%% Convert the contents of column with dates to serial date numbers using date format string (datenum).

%% Create output variable
MessungH4 = dataset(dataArray{1:end-1}, 'VarNames', {'Zeitabs','MVFreshairtemperature1C','MVReturnairtemperature1C','mixedairtempbefev11C','mixedairtempbefev12C','mixedairtempbefev13C','mixedairtempbefev14C','mixedairtempbefev15C','mixedairtempbefev16C','mixedairtempbefev17C','mixedairtempbefev18C','mixedairtempbefev19C','mixedairtempbefev110C','MVmixedairtempbefev1C','behHeater11C','behHeater12C','behHeater13C','behHeater14C','behHeater15C','behHeater16C','MVbehHeater1C','tempmhousingsupairfan1C','Supairtempoutlet11C','Supairtempoutlet12C','Supairtempoutlet13C','Supairtempoutlet14C','Supairtempoutlet15C','Supairtempoutlet16C','MVSupairtempoutlet1C','Tempheatingrodsurface1C','Tempheatingrodsurface2C','Tempheatingrodsurface3C','tempheatbatteryframe1C','tempheatbatteryframe2C','tempHTP1clixxonC','tempCutOutthermoESTI1C','ReserveSlot1C','MVFreshairtemperature2C','MVReturnairtemperature2C','mixedairtempbefev21C','mixedairtempbefev22C','mixedairtempbefev23C','mixedairtempbefev24C','mixedairtempbefev25C','mixedairtempbefev26C','mixedairtempbefev27C','mixedairtempbefev28C','mixedairtempbefev29C','mixedairtempbefev210C','MVmixedairtempbefev2C','behHeater21C','behHeater22C','behHeater23C','behHeater24C','behHeater25C','behHeater26C','MVbehHeater2C','tempmhousingsupairfan2C','Supairtempoutlet21C','Supairtempoutlet22C','Supairtempoutlet23C','Supairtempoutlet24C','Supairtempoutlet25C','Supairtempoutlet26C','MVSupairtempoutlet2C','tempHTP2clixxonC','tempCutOutthermoESTI2C','ReserveSlot2C','ReserveSlot3C','Vin1V','Vin2V','Vin3V','Vin4V','Vin5V','Vin6V','Vin7V','Vin8V','Vin9V','Vin10V','Vin11V','Vin12V','Vin13V','Vin14V','Vin15V','Vin16V','Iin1mA','Iin2mA','Iin3mA','Iin4mA','Iin5mA','Iin6mA','Iin7mA','Iin8mA','TC01C','TC02C','TC03C','TC04C','TC05C','TC06C','TC07C','TC08C','Vin16V1','Vin17V','Vin18V','Vin19V','Vin20V','Vin21V','Vin22V','Vin23V','Vout1V','Vout2V','Vout3V','Vout4V'});
