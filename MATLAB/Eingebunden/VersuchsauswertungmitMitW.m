%Hauptdatei zur Versuchsauswertung, Bosch-Klimapr�fstand,
%Enthalpietauschermessungen
%Autor: Jan Wilmes, mho-jwi
%% Usereingaben

%Dateinamen angeben:
Dateiname = '20160701_V3.xlsx';
%Name der Zieldatei
NeuerDateiname = [Dateiname(1,1:end-5) '_AuswertungM1' '.xlsx'];

%absoluter Umgebungsdruck in Pa:
P_amb = 99500;

%spezifische Gaskonstante von Luft in J/(kg*K), Quelle:Thermodynamic f�r
%Igenieure und http://physics.nist.gov/cgi-bin/cuu/Value?r
R = 287.058;
m = 185;

%Zeitbereich angeben
Zeitstempel_Anf = '01.07.2016, 15:29:39,583';

Zeitstempel_End = '01.07.2016, 15:31:14,582';

%% Excelsheet einlesen

%Format xlsx, Sheet Nr.1
%nach Zahlen und Buchstaben sortieren
[num, txt]=xlsread(Dateiname);

Zeit = txt(2:end,1);
txt = txt(:,2:end);


% %% %conversion into matlab time 
    time2start = datenum(Zeitstempel_Anf,'dd.mm.yyyy, HH:MM:SS,FFF');   %Startzeit -> Matlabtime
    time2stop = datenum(Zeitstempel_End,'dd.mm.yyyy, HH:MM:SS,FFF');    %Endzeit -> Matlabtime
    Datum = zeros(size(Zeit,1),1);  %konditioniert einen Vektor f�r Datum vor, damit die Schleife schneller l�uft
%%Datum -> Matlabtime
for i=1:size(Zeit,1)
    Datum(i,1) = datenum(Zeit{i,1},'dd.mm.yyyy, HH:MM:SS,FFF');
end



  % %% Finden der Start und Stopzeit
        rmin = find(Datum(:,1)>time2start, 1 );
        if isempty(rmin)==1
             rmin = 1;
        end
       %get line to end for y-range
        rmax = find(Datum(:,1)>time2stop, 1 );
        if isempty(rmax)==1
             rmax = length(Post(:,1));
        end
        
      
 num = num(rmin:rmax,:);

VP_Zahl = size(num,1);

num = mean(num,1);

        
 for c = 1:size(num,2),
    num(:,~any(num))=[];            %alle leeren Zahlen-Spalten l�schen
 end

 
varMat = txt(1,:);                  %Zeile mit Variablennamen ausw�hlen
 e = cellfun('isempty',varMat);     %Leere Zellen finden
                 varMat(e) = [];    %Leere Zellen l�schen

ind = find(strcmp(varMat, 'Datum'));%Zelle mit dem Inhalt Datum finden
                 varMat(ind) = [];  %Zelle mit Datum l�schen
                 
%varNames = char(varMat(1,:)); %Bestimmen der Spalten�berschriften=Variablennamen 


varNames = char('T_AUL','T_ABL','T_ZUL_Mitte','T_ZUL_L','T_ZUL_O','T_ZUL_U','T_ZUL_R','T_FOL_Mitte','T_FOL_L','T_FOL_O','T_FOL_U','T_FOL_R','T_ZUL_PHI','T_FOL_PHI','Spannung','PHI_AUL','PHI_ZUL','PHI_FOL','PHI_ABL');

%Zahlenreihen den Variablennamen zuordnen und in Workspace schreiben
   for col=1:size(varNames,1),
          assignin ('base',deblank(varNames(col,:)),num(:,col));
   end;

 Zeit = mat2cell(Zeitstempel_Anf,[1],[24]);
  
   %% Berechnungen
  
%Funktionsaufruf zur Berechnung der relativen Feuchte
[PHI_ABL, PHI_AUL, PHI_FOL, PHI_ZUL] = Berechnung_relative_Feuchte_aus_Spannung(PHI_ABL, PHI_AUL, PHI_FOL, PHI_ZUL, T_ABL, T_AUL, T_FOL_PHI, T_ZUL_PHI, Spannung);

%Funktionsaufruf zur Berechnung der Absoluten Feuchte
Feuchtesensortemperaturen = [T_AUL, T_ABL, T_ZUL_PHI, T_FOL_PHI];
Feuchtewerte = [PHI_AUL, PHI_ABL, PHI_ZUL, PHI_FOL,];

[x_AUL, x_ABL, x_ZUL, x_FOL] = Berechnung_absolute_Feuchte(Feuchtesensortemperaturen, Feuchtewerte, P_amb);

%Funktionsaufruf zur Berechnung der Feuchte in der Pr�fbox
Absfeuchte = [x_ZUL, x_FOL];
Mitteltemperaturen = [T_ZUL_Mitte, T_FOL_Mitte];

[PHI_ZUL, PHI_FOL] = Feuchterueckrechnung(Mitteltemperaturen, Absfeuchte, P_amb);

%Funktionsaufruf zur Berechnung der �bertragungskoeffizienten

[NTU_sen, NTU_lat, k_sen, k_lat, eff_lat, eff_sen] = Berechnung_Uebertragungswerte(PHI_ABL, PHI_AUL, PHI_FOL, PHI_ZUL, T_ABL, T_AUL, T_FOL_PHI, T_ZUL_PHI, x_AUL, P_amb, R,m);


% Zwischenwerte aus Workspace l�schen
clear col Datum num txt varMat e ind c ans ind varNames Spannung Feuchtewerte Feuchtesensortemperaturen Mitteltemperaturen Absfeuchte i;

%clearvars -except T_ei T_eo T_fi T_fo phi_ei phi_eo phi_fo phi_fi m_strom_e m_strom_f varNames

%% schreiben der Exceldatei

%Tabel erzeugen
ExTab = table(Zeit, T_AUL,T_ABL,T_ZUL_PHI,T_FOL_PHI,PHI_AUL,PHI_ABL,PHI_ZUL,PHI_FOL,x_AUL,x_ABL,x_ZUL,x_FOL,T_ZUL_Mitte,T_ZUL_O,T_ZUL_U,T_ZUL_L,T_ZUL_R,T_FOL_Mitte,T_FOL_O,T_FOL_U,T_FOL_L,T_FOL_R, k_sen, k_lat, eff_sen, eff_lat, NTU_sen, NTU_lat);
%in Excelfile schreiben
writetable(ExTab,NeuerDateiname,'WriteRowNames',true);
