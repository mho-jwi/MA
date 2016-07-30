%% Usereingaben

%Dateinamen angeben:
Dateiname = '20160706_V4.xlsx';
%Name der Zieldatei
NeuerDateiname = [Dateiname(1,1:end-5) '_gemittelt3' '.xlsx'];

%Zeitbereich angeben
Zeitstempel_Anf = '06.07.2016, 15:13:36,486';

Zeitstempel_End = '06.07.2016, 15:14:46,486';


%Format xlsx, Sheet Nr.1
%nach Zahlen und Buchstaben sortieren
[num, txt]=xlsread(Dateiname);

Zeit = txt(2:end,1);
txt = txt(:,2:end);


 %% %conversion into matlab time 
    time2start = datenum(Zeitstempel_Anf,'dd.mm.yyyy, HH:MM:SS,FFF');   %Startzeit -> Matlabtime
    time2stop = datenum(Zeitstempel_End,'dd.mm.yyyy, HH:MM:SS,FFF');    %Endzeit -> Matlabtime
    Datum = zeros(size(Zeit,1),1);  %konditioniert einen Vektor für Datum vor, damit die Schleife schneller läuft
%Datum -> Matlabtime
for i=1:size(Zeit,1)
    Datum(i,1) = datenum(Zeit{i,1},'dd.mm.yyyy, HH:MM:SS,FFF');
end


 %% Finden der Start und Stopzeit
        rmin = find(Datum(:,1)>time2start, 1 );
        if isempty(rmin)==1
             rmin = 1;
        end
       %get line to end for y-range
        rmax = find(Datum(:,1)>time2stop, 1 );
        if isempty(rmax)==1
             rmax = length(Datum(:,1));
        end
        

num = num(rmin:rmax,:);

VP_Zahl = size(num,1);

num = mean(num,1);


varNames = char('T_AUL','T_ABL','T_ZUL_Mitte','T_ZUL_L','T_ZUL_O','T_ZUL_U','T_ZUL_R','T_FOL_Mitte','T_FOL_L','T_FOL_O','T_FOL_U','T_FOL_R','T_ZUL_PHI','T_FOL_PHI','Spannung','PHI_AUL','PHI_ZUL','PHI_FOL','PHI_ABL');

%Zahlenreihen den Variablennamen zuordnen und in Workspace schreiben
   for col=1:size(varNames,1),
          assignin ('base',deblank(varNames(col,:)),num(:,col));
   end;

  Zeit = mat2cell(Zeitstempel_Anf,[1],[24]);
  
  
  
  %% schreiben der Exceldatei

%Tabel erzeugen
ExTab = table(Zeit,T_AUL,T_ABL,T_ZUL_Mitte,T_ZUL_L,T_ZUL_O,T_ZUL_U,T_ZUL_R,T_FOL_Mitte,T_FOL_O,T_FOL_U,T_FOL_L,T_FOL_R,T_ZUL_PHI,T_FOL_PHI,Spannung,PHI_AUL,PHI_ZUL,PHI_FOL,PHI_ABL,VP_Zahl);
%in Excelfile schreiben
writetable(ExTab,NeuerDateiname,'WriteRowNames',true);
