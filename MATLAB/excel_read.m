%Excelsheet einlesen, Format xlsx, Sheet Nr. 2
%nach Zahlen und Buchstaben sortieren

[num txt]=xlsread('Versuchsplan.xlsx',2)



 for c = 1:size(num,2),
    num(:,~any(num))=[];            %alle leeren Zahlen-Spalten löschen
 end

varMat = txt(3,:);                  %Zeile mit Variablennamen auswählen
 e = cellfun('isempty',varMat);     %Leere Zellen finden
                 varMat(e) = [];    %Leere Zellen löschen

ind = find(strcmp(varMat, 'Datum'));%Zelle mit dem Inhalt Datum finden
                 varMat(ind) = [];  %Zelle mit Datum löschen
                 
varNames = char(varMat(1,:));       %Bestimmen der Spaltenüberschriften=Variablennamen 

%Zahlenreihen den Variablennamen zuordnen und in Workspace schreiben
   for col=1:size(varNames,1),
          assignin ('base',deblank(varNames(col,:)),num(1:end,col));
   end;

% Zwischenwerte aus Workspace löschen
clear col Datum num txt varMat e ind c ans

clearvars -except T_ei T_eo T_fi T_fo phi_ei phi_eo phi_fo phi_fi m_strom_e m_strom_f varNames
