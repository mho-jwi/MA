%Excelsheet einlesen, Format xlsx, Sheet Nr. 2
%nach Zahlen und Buchstaben sortieren

[num txt]=xlsread('20163006_V2.xlsx')

Zeit = txt(2:end,1);
txt = txt(:,2:end);


 for c = 1:size(num,2),
    num(:,~any(num))=[];            %alle leeren Zahlen-Spalten löschen
 end

varMat = txt(1,:);                  %Zeile mit Variablennamen auswählen
 e = cellfun('isempty',varMat);     %Leere Zellen finden
                 varMat(e) = [];    %Leere Zellen löschen

ind = find(strcmp(varMat, 'Datum'));%Zelle mit dem Inhalt Datum finden
                 varMat(ind) = [];  %Zelle mit Datum löschen
                 
varNames = char(varMat(1,:)); %Bestimmen der Spaltenüberschriften=Variablennamen 
%varNames = varNames(:,1:end-5);
%[remain, token] = strtok(varNames, );
%loesch = strmatch ( [°C],varNames);
%for varcount = 1 (
varNames(1,:) = regexprep (varNames(1,:), '[°C]','');


%Zahlenreihen den Variablennamen zuordnen und in Workspace schreiben
   for col=1:size(varNames,1),
          assignin ('base',deblank(varNames(col,:)),num(1:end,col));
   end;

% Zwischenwerte aus Workspace löschen
clear col Datum num txt varMat e ind c ans ind varNames

%clearvars -except T_ei T_eo T_fi T_fo phi_ei phi_eo phi_fo phi_fi m_strom_e m_strom_f varNames
