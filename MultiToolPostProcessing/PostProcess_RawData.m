%------------------------/
%Script to post-process measurement data from Trox-KVS
%
%functions-needed:
%import_RAW_file,importFluidPropFile_R407c,SDP1000L025,SDP1000L05,SDP1000L,
%Venturi_200_Beck,Venturi_315_Beck,Venturi_355_Beck,R407c_GetEnthalpy_T_p
%created by: P. Steinhoff (29.01.2014)
%last modified by: P. Steinhoff (21.03.2014)
%ToDo list:
%- clean up and create a more general document for everybody
%- improve latex interface for figures & tables
%------------------------
%% %Clear workspace
clearvars;
%% %Configure session T1_mSB:
%CaseIDList = [19;21;22;23];
%% %Configure session c1t1:
%CaseIDList = [15;16;17;18];
%CaseIDList = [49;50];
%% %Configure session c1t1 & c2t1 from 29.04.:
%CaseIDList = [24;25;26;27;28];
%% %Configure session c3t1 & c4t1 from 01.05.:
%CaseIDList = [29;30;31;32;33;34;35;36];

%% %Configure session c4t2 from 07.05.:
%CaseIDList = [37;38;39];
%% %Configure session c3t2 from 08.05.:
%CaseIDList = [40;41];%CaseIDList = [40;41;42];
%% %Configure session c2t2 from 08.05.:
%CaseIDList = [43;44;45];
%% %Configure session c1t2 from 09.05.:
%CaseIDList = [46;47];%CaseIDList = [46;47;48];

%% %Configure session xy:
%CaseIDList = [...];
CaseIDList = [19;21;22;23;49;50;24;25;26;27;28;29;30;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;46;47];
%% %single case:
%CaseIDList = [50];
%% %all
%CaseIDList = linspace(10,23,14);
for index=1:length(CaseIDList)
    CaseID=CaseIDList(index);
    clearvars -except CaseID index CaseIDList;
    DoPostProcessLoop = 1;
    DoPostProcessedData2XLS = 1;
    Doplot = 1;
    ExportFigureListFlag = Doplot;
    ExportTableMeansFlag = 1;
    EXAisCondensing = 0;%set default: exa is not condensing
    Msg = sprintf('/*************/ \nStart processing CaseID: %d\n/*************/',CaseID);
    disp (Msg);
    %% %Set filepath(s):
    if CaseID==1
        path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1\';
        inFile='2014_03_20_c1t1-shift-v2';
        El_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1\c1t1-Pplus.csv';
        Q_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1\c1t1-Qminus.csv';
    elseif CaseID==2
        path='D:\_EBC_0264_TroxKVS\Messungen\C2-T1\';
        inFile='2014_03_21_c2t1';
        El_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C2-T1\c2t1-Pplus.csv';
        Q_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C2-T1\c2t1-Qminus.csv';
    elseif CaseID==3
        path='D:\_EBC_0264_TroxKVS\Messungen\C3-T1\';
        inFile='2014_03_21_c3t1';
        El_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C3-T1\c3t1-Pplus.csv';
        Q_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C3-T1\c3t1-Qminus.csv';
    elseif CaseID==4
        path='D:\_EBC_0264_TroxKVS\Messungen\C4-T1\';
        inFile='2014_03_21_c4t1_Kappa_1_EXA';
        El_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C4-T1\c4t1-Pplus.csv';
        Q_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C4-T1\c4t1-Qminus.csv';
 
        path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1_mSB\';
        inFile='2014_06_05_c1t1';
        El_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1_mSB\2014_06_05_Pplus.csv';
        Q_Power_path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1_mSB\2014_06_05_Qminus.csv';
    end
    inFileEnd='.csv';

    In_filepath=strcat(path,inFile,inFileEnd);

    R407c_Enthalpy_Path='D:\_EBC_0264_TroxKVS\MATLAB_scripts\FluidProp_R407C_enthalpy_from_t_n_p.csv';
    R407c_Density_Path='D:\_EBC_0264_TroxKVS\MATLAB_scripts\FluidProp_R407C_density_from_t_n_p.csv';

    %% %Import all MultiTool and fluid data into the dataset(s):
    RawData = import_RAW_file2Strings(In_filepath);
    R407c_FluidProps_Enthalpy = importFluidPropFile_R407c(R407c_Enthalpy_Path);
    R407c_FluidProps_Density = importFluidPropFile_R407c(R407c_Density_Path);
    AvgPH4 = importfile_ElectricalPower(El_Power_path);
    AvgQH4 = importfile_ElectricalPower(Q_Power_path);
    %% %Define length of data extraction
    StartRow = 2;
    StopRow = length(RawData)-1;
    flexim20=1;
    timeShiftPel =0;
    %Define start and end time for display in figures
    if CaseID==1
        smoothAll = 0;
        ResampleFlag = 1;
        flexim20 =0;
        path='D:\_EBC_0264_TroxKVS\Messungen\C1-T1\shift-v2\';
        start='2014-03-21_04-45';
        stop='2014-03-21_05-22';
    elseif CaseID==2
        smoothAll = 0;
        ResampleFlag = 0;
        flexim20 =0;
        start='2014-03-21_06-50';
        stop='2014-03-21_07-22';
    elseif CaseID==3
        smoothAll = 0;
        ResampleFlag = 0;
        flexim20 =0;
        start='2014-03-21_08-45';
        stop='2014-03-21_09-15';
    elseif CaseID==4
        %set path for storage of data
        path='D:\_EBC_0126_Labview\Messungen\2014_02_19_C4_adjust_meas\';%path to new folder
        smoothAll = 0;
        ResampleFlag = 0;
        start='2014-02-19_16-25';
        stop='2014-02-19_17-00';
    end
    %% %conversion into matlab time 
    time2start = datenum(start,'yyyy-mm-dd_HH-MM')-datenum('2014-01-01_00-00','yyyy-mm-dd_HH-MM');
    time2stop = datenum(stop,'yyyy-mm-dd_HH-MM')-datenum('2014-01-01_00-00','yyyy-mm-dd_HH-MM');
    
    %% %switch post processing on
    if DoPostProcessLoop==1
    %% %Allocate Array for Results and prepare dataset srtucture 
    tmpA=zeros((StopRow-StartRow),size(RawData,2));
    Energy_losses_SUP_pressure_drop=zeros((StopRow-StartRow),1);
    Energy_losses_EXA_pressure_drop=zeros((StopRow-StartRow),1);
    calcMean_bef_ev = zeros((StopRow-StartRow),2);
    calcMean_beh_heat = zeros((StopRow-StartRow),2);
    calcMean_supply_air = zeros((StopRow-StartRow),2);
    %tmpA=zeros(size(RawData,1),size(RawData,2));
    Post = tmpA;
    %PostProcessedData = mat2dataset(tmpA);
    clear tmpA;
    %%
    %PostProcessedData.Properties.VarNames=RawData.Properties.VarNames;
    DefVarNames={'Zeitabs','TairSUP11','TairSUP12','TairSUP13','TairSUP14','TairSUP15','TairSUP16','TairSUP17','TairSUP18','TairSUP19','TairSUP110','TairSUP111','TairSUP112','TairSUP113','TairSUP114','TairSUP115','TairSUP21','TairSUP22','TairSUP23','TairSUP24','TairSUP25','TairSUP26','TairSUP27','TairSUP28','TairSUP29','TairSUP210','TairSUP211','TairSUP212','TairSUP213','TairSUP214','TairSUP215','TairSUP31','TairSUP32','TairSUP33','TairSUP34','TairSUP35','TairSUP36','TairSUP37','TairSUP38','TairSUP39','TairSUP310','TairSUP311','TairSUP312','TairSUP313','TairSUP314','TairSUP315','TairEXA11','TairEXA12','TairEXA13','TairEXA14','TairEXA15','TairEXA16','TairEXA17','TairEXA18','TairEXA19','TairEXA110','TairEXA111','TairEXA112','TairEXA113','TairEXA114','TairEXA115','TairEXA21','TairEXA22','TairEXA23','TairEXA24','TairEXA25','TairEXA26','TairEXA27','TairEXA28','TairEXA29','TairEXA210','TairEXA211','TairEXA212','TairEXA213','TairEXA214','TairEXA215','Tambient','TsoleSUPin','TsoleSUPout','TsoleEXAin','TsoleEXAout','dPairSUP1','dPairSUP3','dPairEXA1','dPairEXA2','VolumeFlowAirSUP','VolumeFlowAirEXA','dPairSUP2','free89','relHumiSUP1','relHumiSUP2','relHumiSUP3','relHumiEXA1','relHumiEXA2','SupplyVoltage5V','free96','free97','VolumeFlowSoleSUP','VolumeFlowSoleEXA','pSoleSUPin','pSoleSUPout','pSoleEXAin','pSoleEXAout','free104','free105','free106','free107','free108','free109','TcalcMeanSUP1','TcalcMeanSUP2','TcalcMeanSUP3','TcalcMeanEXA1','TcalcMeanEXA2','DensityAirSUP1','DensityAirSUP2','DensityAirSUP3','DensityAirEXA1','DensityAirEXA2','MassFlowAirSUP','MassFlowAirEXA','EnthalpyAirSUP1','EnthalpyAirSUP2','EnthalpyAirSup3','EnthalpyAirEXA1','EnthalpyAirEXA2','calcOverAllThermalPowerAirSUP','calcOverAllThermalPowerAirEXA','ElectricalPower','MassFlowSoleSUP','MassFlowSoleEXA','WdotSoleSUP','WdotSoleEXA','calcOverAllThermalPowerSoleSUP','calcOverAllThermalPowerSoleEXA','WdotAirSUP','WdotAirEXA','WdotRatioSUP','WdotRatioEXA','TemperatureChangeEfficiencyFactor','ThermalEfficiencyFactor','EnergyEfficiencyFactor','RatioOfExtractedPowerAir','RatioOfExtractedPowerSole','TcalcMeanSUP3OutlierCorrected','TcalcMeanEXA2OutlierCorrected'};               
    DefUnits={'Days since Jan 0','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','°C','Pa','Pa','Pa','Pa','m³/h','m³/h','Pa','free89','%','%','%','%','%','V','free96','free97','m³/h','m³/h','bar','bar','bar','bar','free104','free105','free106','free107','free108','free109','°C','°C','°C','°C','°C','kg/m³','kg/m³','kg/m³','kg/m³','kg/m³','kg/h','kg/h','kJ/kg','kJ/kg','kJ/kg','kJ/kg','kJ/kg','kW','kW','kW','kg/h','kg/h','kW/K','kW/K','kW','kW','kW/K','kW/K','NoUnit','NoUnit','NoUnit','NoUnit','NoUnit','NoUnit','NoUnit','°C','°C'};               
    %% %Set reference pressure in mbar
    pRef = 980;
    %%
    %Reorganize data and conversion of signals into physical values
    %Appended calculation of additional values
    %-----------------------
        %%
            %DefVarNames{129}='ElectricalPower';
            %DefUnits{129}='kW';
            %if CaseID > 0 && CaseID < 99
             %   Post(line,129) = interp1(AvgPH4(2:end,1),AvgPH4(2:end,2),Post(line,1));
            %else
            %    Post(:,129) = 0;
            %end
        %%
       for i=(StartRow+1):StopRow
          line = i-StartRow;
          %timestamp: 
          Post(line,1) = datenum(RawData{i,1},'dd.mm.yyyy, HH:MM:SS,FFF');
          %% %Temperatures SUP 1 (inlet)
          Post(line,2) = Pt100_linear2square_fit(str2double(RawData.Var2(i)));  
          Post(line,3) = Pt100_linear2square_fit(str2double(RawData.Var3(i))); 
          Post(line,4) = Pt100_linear2square_fit(str2double(RawData.Var4(i))); 
          Post(line,5) = Pt100_linear2square_fit(str2double(RawData.Var5(i)));
          Post(line,6) = Pt100_linear2square_fit(str2double(RawData.Var6(i)));
          Post(line,7) = Pt100_linear2square_fit(str2double(RawData.Var7(i)));
          Post(line,8) = Pt100_linear2square_fit(str2double(RawData.Var8(i)));
            Post(line,9) = Pt100_linear2square_fit(str2double(RawData.Var9(i)));
          Post(line,10) = Pt100_linear2square_fit(str2double(RawData.Var10(i)));
          Post(line,11) = Pt100_linear2square_fit(str2double(RawData.Var11(i)));
          Post(line,12) = Pt100_linear2square_fit(str2double(RawData.Var12(i)));
          Post(line,13) = Pt100_linear2square_fit(str2double(RawData.Var13(i)));
          Post(line,14) = Pt100_linear2square_fit(str2double(RawData.Var14(i)));
          Post(line,15) = Pt100_linear2square_fit(str2double(RawData.Var15(i)));  
          Post(line,16) = Pt100_linear2square_fit(str2double(RawData.Var16(i)));
          
          calcMean_SUP(line,1)=mean(Post(line,2:16)); %mean value 
          
 
          
          calcMean_EXA(line,2)=mean(Post(line,62:76)); %mean value
          calcMean_EXA(line,3)=mean(Post(line,[62,63,64,65,67,68,69,70,72,73,74,75])); %mean value without the sensors 5,10,15
          %% %Ambient Temperature
          Post(line,77) = Pt100_linear2square_fit(str2double(RawData.Var77(i)));
          
          %% %Sole
          %T_sole_SUP_in
          Post(line,78) = Pt100_linear2square_fit(str2double(RawData.Var78(i)));
          %T_sole_SUP_out
          Post(line,79) = Pt100_linear2square_fit(str2double(RawData.Var79(i)));
          %T_sole_EXA_in
          Post(line,80) = Pt100_linear2square_fit(str2double(RawData.Var80(i)));
          %T_sole_EXA_out
          Post(line,81) = Pt100_linear2square_fit(str2double(RawData.Var81(i)));
          
          %% %Pressure drop at heat exchanger
          %dP_airSUP-1
          Post(line,82) =SDP1000L05(str2double(RawData.Var82(i)),pRef);
          %dP_airSUP-3
          Post(line,83) =SDP1000L05(str2double(RawData.Var83(i)),pRef);
          %dP_airEXA-1
          Post(line,84) =SDP1000L05(str2double(RawData.Var84(i)),pRef);
          %dP_airEXA-2
          Post(line,85) =SDP1000L05(str2double(RawData.Var85(i)),pRef);
          %dP_airSUP-2
          Post(line,88) =SDP1000L05(str2double(RawData.Var88(i)),pRef);
          
          %% %VolumeFlow-air ID's: 86-87
            %notice: switch between ID's is performed
            %in MATLAB again (s. varnames of results) as the RawData does not contain what happens in the
            %GUI-section of LABVIEW!!!
          %355
          %DefVarNames{86}='VolumeFlowAirSUP';
          Post(line,86) = Venturi_355_Beck(SDP1000L(str2double(RawData.Var86(i)),pRef),2);
          
          %% %Humidity ID's: 76-85
          SupplyVoltageHumi=str2double(RawData.Var95(i));
          %Side I
          Post(line,90) = HoneyWell_HIH4010_V2phi(str2double(RawData.Var90(i)),SupplyVoltageHumi,Post(line,9));
          Post(line,91) = HoneyWell_HIH4010_V2phi(str2double(RawData.Var91(i)),SupplyVoltageHumi,Post(line,24));
          Post(line,92) = HoneyWell_HIH4010_V2phi(str2double(RawData.Var92(i)),SupplyVoltageHumi,Post(line,39));  
          Post(line,93) = HoneyWell_HIH4010_V2phi(str2double(RawData.Var93(i)),SupplyVoltageHumi,Post(line,54));
          Post(line,94) = HoneyWell_HIH4010_V2phi(str2double(RawData.Var94(i)),SupplyVoltageHumi,Post(line,69));
          
          %% %Volumeflow sole 4-20 mA prop to 0-2m³/h
          %DefVarNames{98}='VolumeFlowSoleSUP';
          if flexim20 ==0
            Post(line,98) = 1.5*( (str2double(RawData.Var98(i)) -4) /16 );
          else
            Post(line,98) = 2*( (str2double(RawData.Var98(i)) -4) /16 );
          end
          if str2double(RawData.Var98(i)) < 0 || str2double(RawData.Var98(i)) > 20
              Post(line,98) = NaN;
          end
          %DefVarNames{99}='VolumeFlowSoleEXA';
          if flexim20 ==0
            Post(line,99) = 1.5*( (str2double(RawData.Var99(i)) -4) /16 );
          else
            Post(line,99) = 2*( (str2double(RawData.Var99(i)) -4) /16 );  
          end
          if str2double(RawData.Var99(i)) < 0 || str2double(RawData.Var99(i)) > 20
              Post(line,99) = NaN;
          end
                    

      %% %End of section with direct measured propertiers
      %%
          %% %Calculate mean from sensor arrays
          %DefVarNames{110}='TcalcMeanSUP1';
          Post(line,110) = calcMean_SUP(line,1);
          %DefVarNames{111}='TcalcMeanSUP2';
          Post(line,111) = calcMean_SUP(line,2);
          %DefVarNames{112}='TcalcMeanSUP3';
          Post(line,112) = calcMean_SUP(line,3);
          
          %DefVarNames{113}='TcalcMeanEXA1';
          Post(line,113) = calcMean_EXA(line,1);
          %DefVarNames{114}='TcalcMeanEXA2';
          Post(line,114) = calcMean_EXA(line,2);

          %% %calculate densities
          %DefVarNames{115}='DensityAirSUP1';
          Post(line,115) = Density_humidAir(Post(line,110),Post(line,90),pRef);
          %DefVarNames{116}='DensityAirSUP2';
          Post(line,116) = Density_humidAir(Post(line,111),Post(line,91),pRef);
          %DefVarNames{117}='DensityAirSUP3';
          Post(line,117) = Density_humidAir(Post(line,112),Post(line,92),pRef);

          %DefVarNames{118}='DensityAirEXA1';
          Post(line,118) = Density_humidAir(Post(line,113),Post(line,93),pRef);
          %DefVarNames{119}='DensityAirEXA2';
          Post(line,119) = Density_humidAir(Post(line,114),Post(line,94),pRef);

          %% %calculate air mass-flow
          %DefVarNames{120}='MassFlowAirSUP';
          Post(line,120) = Post(line,86)*Post(line,117);
          %DefVarNames{121}='MassFlowAirEXA';
          Post(line,121) = Post(line,87)*Post(line,119);
          
          %% %calculate enthalpy
          SUPload1 = MixedLoad_humidAir(0.5*(Post(line,120)),Post(line,90),Post(line,110),0.5*(Post(line,120)),Post(line,90),Post(line,110),pRef);       
          %% %calculate enthalpy %don't use rel. humidity for non-condensing points                        
          %DefVarNames{122}='EnthalpyAirSUP1';
          Post(line,122) = HumidAir_CalcEnthalpy(Post(line,110),Post(line,90),pRef,SUPload1);
          %DefVarNames{123}='EnthalpyAirSUP2';
          Post(line,123) = HumidAir_CalcEnthalpy(Post(line,111),Post(line,91),pRef,SUPload1);
          %DefVarNames{124}='EnthalpyAirSup3';
          Post(line,124) = HumidAir_CalcEnthalpy(Post(line,112),Post(line,92),pRef,SUPload1);
          
          EXAload1 = MixedLoad_humidAir(0.5*(Post(line,121)),Post(line,93),Post(line,110),0.5*(Post(line,121)),Post(line,93),Post(line,113),pRef);
          if EXAisCondensing ==1
              %DefVarNames{125}='EnthalpyAirEXA1';
              Post(line,125) = HumidAir_CalcEnthalpy(Post(line,113),Post(line,93),pRef);
              %DefVarNames{126}='EnthalpyAirEXA2';
              Post(line,126) = HumidAir_CalcEnthalpy(Post(line,114),Post(line,94),pRef);
          else
              %DefVarNames{125}='EnthalpyAirEXA1';
              Post(line,125) = HumidAir_CalcEnthalpy(Post(line,113),Post(line,93),pRef,EXAload1);
              %DefVarNames{126}='EnthalpyAirEXA2';
              Post(line,126) = HumidAir_CalcEnthalpy(Post(line,114),Post(line,94),pRef,EXAload1);
          end
          %% %calc power from energy balance
          %DefVarNames{127}='calcOverAllThermalPowerAirSUP';
          Post(line,127) = (Post(line,120)*(Post(line,124)-Post(line,122)))/3600;
          %DefVarNames{128}='calcOverAllThermalPowerAirEXA';
          Post(line,128) = (Post(line,121)*(Post(line,126)-Post(line,125)))/3600;
          
          %129 reserved for electrical power
          Post(line,129) = interp1(AvgPH4(2:end,1),AvgPH4(2:end,2),Post(line,1));
          
          rhoSole = 1040;
          cpSole = 3.65;
          
          %DefVarNames{130}='MassFlowSoleSUP';
          Post(line,130) = Post(line,98)*rhoSole;
          
          %DefVarNames{131}='MassFlowSoleEXA';
          Post(line,131) = Post(line,99)*rhoSole;
          
          %DefVarNames{132}='WdotSoleSUP';
          Post(line,132) = Post(line,130)*cpSole/3600;
          
          %DefVarNames{133}='WdotSoleEXA';
          Post(line,133) = Post(line,131)*cpSole/3600;
          
          %DefVarNames{134}='calcOverAllThermalPowerSoleSUP';
          Post(line,134) = Post(line,132)*(Post(line,79)-Post(line,78));
          
          %DefVarNames{135}='calcOverAllThermalPowerSoleEXA';
          Post(line,135) = Post(line,133)*(Post(line,81)-Post(line,80));
          
          cpAir = 1.006;
          
          %DefVarNames{136}='WdotAirSUP';
          Post(line,136) = Post(line,120)*cpAir/3600;
          
          %DefVarNames{137}='WdotAirEXA';
          Post(line,137) = Post(line,121)*cpAir/3600;
          
          %DefVarNames{138}='WdotRatioSUP';
          Post(line,138) = Post(line,132)/Post(line,136);

          %DefVarNames{139}='WdotRatioEXA';
          Post(line,139) = Post(line,133)/Post(line,137);
  
          %DefVarNames{140}='TemperatureChangeEfficiencyFactor';
          %DefUnits{140} = 'NoUnit';
          Post(line,140) = (Post(line,112)-Post(line,110))/(Post(line,113)-Post(line,110));
          
          %DefVarNames{141}='ThermalEfficiencyFactor';
          %DefUnits{141} = 'NoUnit';
          Post(line,141) = (Post(line,120)/Post(line,121))*Post(line,140);
          
          %DefVarNames{142}='EnergyEfficiencyFactor';
          %DefUnits{142} = 'NoUnit';
          % = Q_dot_nutz / (Q_dot_max_SUP + P_el_pump + P_pressure_drop)
          eta_d = 0.6; %durchschnittlicher Gesamtwirkungsgrad bezogen auf
          %die Druckerhöung des Ventilators
          Energy_losses_SUP_pressure_drop(line) = (1/eta_d)*(Post(line,86)/3600000)*(Post(line,82)+Post(line,83)+Post(line,88));
          Energy_losses_EXA_pressure_drop(line) = (1/eta_d)*(Post(line,87)/3600000)*(Post(line,84)+Post(line,85));
          %Eta_n zur Klassifizierung nach RLT01 / DIN EN 13053
          %Berechne Leistungsziffer "Nutzen zu Aufwand":
          Epsilon = Post(line,127) /(Post(line,129) + Energy_losses_SUP_pressure_drop(line) + Energy_losses_EXA_pressure_drop(line));
          eta_t_corrected = Post(line,140)*(Post(line,121)/Post(line,120))^0.4;
          Post(line,142) = eta_t_corrected*(1-(1/Epsilon));
          
          %DefVarNames{143}='RatioOfExtractedPowerAir';
          %DefUnits{143} = 'NoUnit';
          Post(line,143) = -(Post(line,127)/Post(line,128));
          
          %DefVarNames{144}='RatioOfExtractedPowerSole';
          %DefUnits{144} = 'NoUnit';
          Post(line,144) = -(Post(line,134)/Post(line,135));
          
          %DefVarNames{145}='TcalcMeanSUP3OutlierCorrected';
          %DefUnits{145} = '°C';
          Post(line,145) = calcMean_SUP(line,4);
          %DefVarNames{146}='TcalcMeanEXA2OutlierCorrected';
          %DefUnits{146} = '°C';
          Post(line,146) = calcMean_EXA(line,3);
          
          DefVarNames{147}='TemperatureChangeEfficiencyFactorOutlierCorrected';
          DefUnits{147} = 'NoUnit';
          Post(line,147) = (Post(line,145)-Post(line,110))/(Post(line,113)-Post(line,110));
          
          DefVarNames{148}='EnergyEfficiencyFactorOutlierCorrected';
          DefUnits{148} = 'NoUnit';
          eta_t_outlier_corrected = Post(line,147)*(Post(line,121)/Post(line,120))^0.4;
          Post(line,148) = eta_t_outlier_corrected*(1-(1/Epsilon));
                  
       end
        %% %smoothing (has to happen outside of the loop)
        %option to smooth you data with a savitzky-golay filter
        k=11;   %order of the polynomial  k<f
        f=23;  %size of window the filter is looking at
        %DefVarNames{143}='smoothedCalcPowerAirTotal';
        %Post(:,143) = sgolayfilt(Post(:,142),k,f);
        %% %Section for Validation of assignment between value and unit
        validateUnits=0;
         if validateUnits==1
            for i=1:length(DefVarNames)
                compare{1,i}=DefVarNames(i);
            end
            for i=1:length(DefUnits)
                compare{2,i}=DefUnits(i);
            end
         end
        %% some calculations that do not need to be perfomed in a for loop

        if smoothAll ==1
            k=17;   %order of the polynomial  k<f
            f=101;  %size of window the filter is looking at
            for j=2:length(Post(1,:))
            Post(:,j) = sgolayfilt(Post(:,j),k,f);
            end
        end
        if ResampleFlag==1
            nth=10; %only every nth element is taken
            for j=1:length(Post(1,:))
            tmp(:,j) = Post(1:nth:end,j);
            end
            Post = tmp;
            clear tmp;
        end
       %% %Replace NaN's by 0
       Post(isnan(Post))=0;
       
       %select variables that will not be exportet into Table
       DefVarNames{101}='free'; %%DefVarNames{101}='p_sole_sup_out';
    end
    %% % reduce date values to create accurate plost matlab2tikz in latex
    Post(:,1) = Post(:,1)-datenum('2014-01-01_00-00','yyyy-mm-dd_HH-MM');
    if timeShiftPel==1 %compensate shift in measurement time due to change from GMT to GMT+1 
        AvgPH4(:,1) = AvgPH4(:,1) - datenum('2013-12-31_23-00','yyyy-mm-dd_HH-MM');
    else
        AvgPH4(:,1) = AvgPH4(:,1) - datenum('2014-01-01_00-00','yyyy-mm-dd_HH-MM');
    end
    %% %get line to start for y-range
        rmin = find(Post(:,1)>time2start, 1 );
        if isempty(rmin)==1
             rmin = 1;
        end
       %get line to end for y-range
        rmax = find(Post(:,1)>time2stop, 1 );
        if isempty(rmax)==1
             rmax = length(Post(:,1));
        end
    %% %export postprocessed data into xls sheet
    if DoPostProcessedData2XLS==1;
        %export complete dataset
        tmpExport = Post(rmin:rmax,:);
        row4Mean = length(tmpExport)+3;
            for k=2:length(tmpExport(1,:))
            tmpExport(row4Mean,k) =  mean(tmpExport(1:(rmax-rmin+1),k));
            end
        Results = mat2dataset(tmpExport);
        Results.Properties.VarNames=DefVarNames;
        Results.Properties.Units = DefUnits;
        export(Results,'XLSfile',strcat(path,'PostProcessed_Results_',inFile));
        %export temporal average only - dataset
        tmpExport2 = tmpExport(row4Mean,:);

        MeanResults = mat2dataset(tmpExport2);
        MeanResults.Properties.VarNames=DefVarNames;
        MeanResults.Properties.Units = DefUnits;
        export(MeanResults,'XLSfile',strcat(path,'PostProcessed_temporalMean_',inFile));    

        Units = mat2dataset(DefUnits);
        Units.Properties.VarNames=DefVarNames;
        export(Units,'XLSfile',strcat(path,'PostProcessed_units_',inFile)); 
    end
    %% %begin of plot section
    if Doplot==1
        %set plot-label and title
        plotTitle = 'Zeitlicher Verlauf: .';
        plotLabelX = 'Uhrzeit in HH:MM:SS';

        %get line to start for y-range
        rminP = find(AvgPH4(:,1)<time2start, 1 );
        if isempty(rminP)==1
             rminP = length(AvgPH4(:,1));
        end
        %get line to end for y-range
        rmaxP = find(AvgPH4(:,1)<time2stop, 1 );
        if isempty(rmaxP)==1
             rmaxP = 2;
        end
        %% %set size for string container to export content file with tikz informations
        imageNames = cell(50,1);
        %% %set some globals for plot appearance
        textSizeLegend = 8;
        textSizeGlobal=12;
        NxTicks =3;
        datetickStyle=13;
        numberOfColors = 5;
        LineWidth =2.0;
        EBC_IntensityLevel=1;
        EBC_ColorMap = get_EBC_lineColorMap(EBC_IntensityLevel);
        %% %create y limits for figure 1 
            minVec=[min(min(Post(rmin:rmax,2:16))),min(min(Post(rmin:rmax,110)))];
            maxVec=[max(max(Post(rmin:rmax,2:16))),max(max(Post(rmin:rmax,110)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for air temperatures SUP 1:
            hFig=figure(1);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='AirTemperatures-SUP-1';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,2:16),numberOfColors,LineWidth,EBC_IntensityLevel)
            hold on
            plot(Post(rmin:rmax,1),Post(rmin:rmax,110),'LineWidth',LineWidth,'LineStyle','-.','Color',EBC_ColorMap(2,:))
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Lufttemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{2:16},DefVarNames{110},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f1_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f1_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f1_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f1_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{1}=strcat(path,inFile,'_f1_',plotName,'.tikz');
        %% %create y limits for figure 2 
            minVec=[min(min(Post(rmin:rmax,17:31))),min(min(Post(rmin:rmax,111)))];
            maxVec=[max(max(Post(rmin:rmax,17:31))),max(max(Post(rmin:rmax,111)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for air temperatures SUP 2:
            hFig=figure(2);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='AirTemperatures-SUP-2';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,17:31),numberOfColors,LineWidth,EBC_IntensityLevel)
            hold on
            plot(Post(rmin:rmax,1),Post(rmin:rmax,111),'LineWidth',LineWidth,'LineStyle','-.','Color',EBC_ColorMap(2,:))
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Lufttemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{17:31},DefVarNames{111},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f2_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f2_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f2_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f2_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{2}=strcat(path,inFile,'_f2_',plotName,'.tikz');
       %% %create y limits for figure 3 
            minVec=[min(min(Post(rmin:rmax,32:46))),min(min(Post(rmin:rmax,112)))];
            maxVec=[max(max(Post(rmin:rmax,32:46))),max(max(Post(rmin:rmax,112)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for air temperatures SUP 3:
            hFig=figure(3);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='AirTemperatures-SUP-3';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,32:46),numberOfColors,LineWidth,EBC_IntensityLevel)
            hold on
            plot(Post(rmin:rmax,1),Post(rmin:rmax,112),'LineWidth',LineWidth,'LineStyle','-.','Color',EBC_ColorMap(2,:))
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Lufttemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{32:46},DefVarNames{112},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f3_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f3_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f3_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f3_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{3}=strcat(path,inFile,'_f3_',plotName,'.tikz');
       %% %create y limits for figure 4 
            minVec=[min(min(Post(rmin:rmax,47:61))),min(min(Post(rmin:rmax,113)))];
            maxVec=[max(max(Post(rmin:rmax,47:61))),max(max(Post(rmin:rmax,113)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for air temperatures EXA 1:
            hFig=figure(4);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='AirTemperatures-EXA-1';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,47:61),numberOfColors,LineWidth,EBC_IntensityLevel)
            hold on
            plot(Post(rmin:rmax,1),Post(rmin:rmax,113),'LineWidth',LineWidth,'LineStyle','-.','Color',EBC_ColorMap(2,:))
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Lufttemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{47:61},DefVarNames{113},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f4_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f4_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f4_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f4_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{4}=strcat(path,inFile,'_f4_',plotName,'.tikz');
       %% %create y limits for figure 5 
            minVec=[min(min(Post(rmin:rmax,62:76))),min(min(Post(rmin:rmax,114)))];
            maxVec=[max(max(Post(rmin:rmax,62:76))),max(max(Post(rmin:rmax,114)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for air temperatures EXA 2:
            hFig=figure(5);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='AirTemperatures-EXA-2';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,62:76),numberOfColors,LineWidth,EBC_IntensityLevel)
            hold on
            plot(Post(rmin:rmax,1),Post(rmin:rmax,114),'LineWidth',LineWidth,'LineStyle','-.','Color',EBC_ColorMap(2,:))
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Lufttemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{62:76},DefVarNames{114},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f5_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f5_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f5_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f5_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{5}=strcat(path,inFile,'_f5_',plotName,'.tikz');
       %% %create y limits for figure 6
            minVec=[min(min(Post(rmin:rmax,78:79))),min(min(Post(rmin:rmax,80:81)))];
            maxVec=[max(max(Post(rmin:rmax,78:79))),max(max(Post(rmin:rmax,80:81)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for sole temperatures:
            hFig=figure(6);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='SoleTemperatures';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,78:81),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Soletemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{78:81},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f6_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f6_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f6_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f6_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{6}=strcat(path,inFile,'_f6_',plotName,'.tikz');
        %% %create y limits for figure 7
            minVec=min(min(Post(rmin:rmax,98:99)));
            maxVec=max(max(Post(rmin:rmax,98:99)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for volumeflow sole:
            hFig=figure(7);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='VolumeFlowSole';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,98:99),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Volumenstrom in m³/h')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{98:99},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f7_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f7_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f7_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f7_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{7}=strcat(path,inFile,'_f7_',plotName,'.tikz');
        %% %create y limits for figure 8
            minVec=min(min(Post(rmin:rmax,86:87)));
            maxVec=max(max(Post(rmin:rmax,86:87)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for volumeflow air:
            hFig=figure(8);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='VolumeFlowAir';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,86:87),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Volumenstrom in m³/h')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{86:87},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f8_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f8_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f8_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f8_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{8}=strcat(path,inFile,'_f8_',plotName,'.tikz');
        %% %create y limits for figure 9
            minVec=min(min(Post(rmin:rmax,90:94)));
            maxVec=max(max(Post(rmin:rmax,90:94)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for rel. humidities:
            hFig=figure(9);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='MeasuredRelHumidity';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,90:94),numberOfColors,LineWidth,EBC_IntensityLevel)     
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Relative Feuchte in %')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{90:94},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f9_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f9_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f9_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f9_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{9}=strcat(path,inFile,'_f9_',plotName,'.tikz');
        %% %create y limits for figure 10
            minVec=[min(min(Post(rmin:rmax,82:85))),min(min(Post(rmin:rmax,88)))];
            maxVec=[max(max(Post(rmin:rmax,82:85))),max(max(Post(rmin:rmax,88)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for Measured diff. pressure:
            hFig=figure(10);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='MeasuredPressureDrop';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,[82,88,83,84,85]),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Druckdifferenz in Pa')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{82},DefVarNames{88},DefVarNames{83},DefVarNames{84:85},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f10_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f10_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f10_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f10_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{10}=strcat(path,inFile,'_f10_',plotName,'.tikz');
        %% %create y limits for figure 11
            minVec=min(min(Post(rmin:rmax,100:103)));
            maxVec=max(max(Post(rmin:rmax,100:103)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for sole pressure:
            hFig=figure(11);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='MeasuredPressureSole';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,[100,102,103]),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Absolutdruck in bar')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{100},DefVarNames{102:103},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f11_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f11_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f11_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f11_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{11}=strcat(path,inFile,'_f11_',plotName,'.tikz');
        %% %create y limits for figure 12
            minVec=[min(min(Post(rmin:rmax,127:128))),min(min(Post(rmin:rmax,134:135)))];
            maxVec=[max(max(Post(rmin:rmax,127:128))),max(max(Post(rmin:rmax,134:135)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for Measured power 2 air:
            hFig=figure(12);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='MeasuredHeatflux';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,[127,128,134,135]),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Leistung in kW')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{127:128},DefVarNames{134:135},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f12_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f12_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f12_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f12_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{12}=strcat(path,inFile,'_f12_',plotName,'.tikz');
        %% %create y limits for figure 13
            minVec=min(min(Post(rmin:rmax,130:131)));
            maxVec=max(max(Post(rmin:rmax,130:131)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for sole massflow
            hFig=figure(13);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='MassFlowSole';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,130:131),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Massenstrom in kg/h')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{130:131},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            %hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f13_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f13_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f13_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f13_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{13}=strcat(path,inFile,'_f13_',plotName,'.tikz');
        %% %create y limits for figure 14
            minVec=min(min(AvgPH4(rmaxP:rminP,2)));
            maxVec=max(max(AvgPH4(rmaxP:rminP,2)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for electrical Power
            hFig=figure(14);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='ElectricalPower';
            EBC_lineplot(hFig,AvgPH4(rmaxP:rminP,1),AvgPH4(rmaxP:rminP,2),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Leistung in kW')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend('OverallElectricalPower','Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f14_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f14_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f14_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f14_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{14}=strcat(path,inFile,'_f14_',plotName,'.tikz');
        %% %create y limits for figure 15
            minVec=min(min(Post(rmin:rmax,120:121)));
            maxVec=max(max(Post(rmin:rmax,120:121)));
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for electrical Power & Air-Power
            hFig=figure(15);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='MassFlowAir';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,120:121),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Massenstrom in kg/h')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{120:121},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f15_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f15_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f15_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f15_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{15}=strcat(path,inFile,'_f15_',plotName,'.tikz');
        %% %create y limits for figure 16
            minVec=[min(min(Post(rmin:rmax,132:133))),min(min(Post(rmin:rmax,136:137)))];
            maxVec=[max(max(Post(rmin:rmax,132:133))),max(max(Post(rmin:rmax,136:137)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure
            hFig=figure(16);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='ThermalCapacityFlow';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,[132,133,136,137]),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Wärmekapazitätsstrom in kW/K')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            %DefVarNames{166:167},
            h=legend(DefVarNames{132:133},DefVarNames{136:137},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f16_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f16_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f16_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f16_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{16}=strcat(path,inFile,'_f16_',plotName,'.tikz');
        %% %create y limits for figure 17
            minVec=[min(min(Post(rmin:rmax,138:139))),min(min(Post(rmin:rmax,140:142))),min(min(Post(rmin:rmax,147)))];
            maxVec=[max(max(Post(rmin:rmax,138:139))),max(max(Post(rmin:rmax,140:142))),max(max(Post(rmin:rmax,147)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure
            hFig=figure(17);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='TransferEfficiencyHeatRecovery';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,[138,139,140,141,142,147]),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop 0 2])
            xlabel(plotLabelX)
            ylabel('Efficiency factors')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{138:142},DefVarNames{147},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f17_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f17_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f17_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f17_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{17}=strcat(path,inFile,'_f17_',plotName,'.tikz');
            %
        %% %create y limits for figure 18
            minVec=[min(min(Post(rmin:rmax,143:144))),0.75];
            maxVec=[max(max(Post(rmin:rmax,143:144))),1.25];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
            tmpPlot = zeros( length(Post(:,1)),2);
            tmpPlot(:,1)=0.95;
            tmpPlot(:,2)=1.05;
        %%%Figure
            hFig=figure(18);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='RatioOfTransferedPower';
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,143:144),numberOfColors,LineWidth,EBC_IntensityLevel)
            hold all
            plot(Post(rmin:rmax,1),tmpPlot(rmin:rmax,1),'LineWidth',LineWidth,'LineStyle','--','Color',EBC_ColorMap(3,:))
            hold all
            plot(Post(rmin:rmax,1),tmpPlot(rmin:rmax,2),'LineWidth',LineWidth,'LineStyle','--','Color',EBC_ColorMap(4,:))

        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop 0.75 1.25])
            xlabel(plotLabelX)
            ylabel('Dimensionsloses Verhältnis')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{143:144},'LowerLimit','UpperLimit','Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            hold off
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f18_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f18_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f18_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f18_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{18}=strcat(path,inFile,'_f18_',plotName,'.tikz');
%%
        %% %create y limits for figure 19
            minVec=[min(min(Post(rmin:rmax,2:16)))];
            maxVec=[max(max(Post(rmin:rmax,2:16)))];
            zmin = floor(min(minVec));
            zmax = ceil (max(maxVec));
            if isnan(zmin) || isnan(zmax) || zmin==zmax
            zmin = 0; zmax = 35;
            end
        %%%Figure for CondenserAirTempeartures
            hFig=figure(19);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='SurfacePlotAirTemperaturesSUP1';
            gridValues(3,:)=tmpExport2(1,2:16);%z
            gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
            gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
            [X,Y]=meshgrid(0:9:918, 0:9:612);
            vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');
            surf(X,Y,vq);
        %adjust plot appearance
             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
             axis([0 920 0 620 zmin zmax])
             xlabel('Horiziontale Position in mm')
             ylabel('Vertikale Position in mm')
             zlabel('Temperatur in °C')
             title(plotName)
             colorbar('peer',gca);

        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f19_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f19_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f19_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f19_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{19}=strcat(path,inFile,'_f19_',plotName,'.tikz');
        %% %create y limits for figure 20
            minVec=[min(min(Post(rmin:rmax,17:31)))];
            maxVec=[max(max(Post(rmin:rmax,17:31)))];
            zmin = floor(min(minVec));
            zmax = ceil (max(maxVec));
            if isnan(zmin) || isnan(zmax) || zmin==zmax
            zmin = 0; zmax = 35;
            end
        %%%Figure for CondenserAirTempeartures
            hFig=figure(20);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='SurfacePlotAirTemperaturesSUP2';
            gridValues(3,:)=tmpExport2(1,17:31);%z
            gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
            gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
            [X,Y]=meshgrid(0:9:918, 0:9:612);
            vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');
            surf(X,Y,vq);
        %adjust plot appearance
             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
             axis([0 920 0 620 zmin zmax])
             xlabel('Horiziontale Position in mm')
             ylabel('Vertikale Position in mm')
             zlabel('Temperatur in °C')
             title(plotName)
             colorbar('peer',gca);
         %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f20_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f20_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f20_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f20_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{20}=strcat(path,inFile,'_f20_',plotName,'.tikz');
         %% %create y limits for figure 21
            minVec=[min(min(Post(rmin:rmax,32:46)))];
            maxVec=[max(max(Post(rmin:rmax,32:46)))];
            zmin = floor(min(minVec));
            zmax = ceil (max(maxVec));
            if isnan(zmin) || isnan(zmax) || zmin==zmax
            zmin = 0; zmax = 35;
            end
        %%%Figure for CondenserAirTempeartures
            hFig=figure(21);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='SurfacePlotAirTemperaturesSUP3';
            gridValues(3,:)=tmpExport2(1,32:46);%z
            gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
            gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
            [X,Y]=meshgrid(0:9:918, 0:9:612);
            vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');
            surf(X,Y,vq);
        %adjust plot appearance
             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
             axis([0 920 0 620 zmin zmax])
             xlabel('Horiziontale Position in mm')
             ylabel('Vertikale Position in mm')
             zlabel('Temperatur in °C')
             title(plotName)
             colorbar('peer',gca);
         %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f21_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f21_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f21_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f21_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{21}=strcat(path,inFile,'_f21_',plotName,'.tikz');
         %% %create y limits for figure 22
            minVec=[min(min(Post(rmin:rmax,47:61)))];
            maxVec=[max(max(Post(rmin:rmax,47:61)))];
            zmin = floor(min(minVec));
            zmax = ceil (max(maxVec));
            if isnan(zmin) || isnan(zmax) || zmin==zmax
            zmin = 0; zmax = 35;
            end
        %%%Figure for CondenserAirTempeartures
            hFig=figure(22);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='SurfacePlotAirTemperaturesEXA1';
            gridValues(3,:)=tmpExport2(1,47:61);%z
            gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
            gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
            [X,Y]=meshgrid(0:9:918, 0:9:612);
            vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');
            surf(X,Y,vq);
        %adjust plot appearance
             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
             axis([0 920 0 620 zmin zmax])
             xlabel('Horiziontale Position in mm')
             ylabel('Vertikale Position in mm')
             zlabel('Temperatur in °C')
             title(plotName)
             colorbar('peer',gca);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f22_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f22_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f22_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f22_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{22}=strcat(path,inFile,'_f22_',plotName,'.tikz');
         %% %create y limits for figure 23
            minVec=[min(min(Post(rmin:rmax,62:76)))];
            maxVec=[max(max(Post(rmin:rmax,62:76)))];
            zmin = floor(min(minVec));
            zmax = ceil (max(maxVec));
            if isnan(zmin) || isnan(zmax) || zmin==zmax
            zmin = 0; zmax = 35;
            end
        %%%Figure for CondenserAirTempeartures
            hFig=figure(23);
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='SurfacePlotAirTemperaturesEXA2';
            gridValues(3,:)=tmpExport2(1,62:76);%z
            gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
            gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
            [X,Y]=meshgrid(0:9:918, 0:9:612);
            vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');
            surf(X,Y,vq);
        %adjust plot appearance
             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
             axis([0 920 0 620 zmin zmax])
             xlabel('Horiziontale Position in mm')
             ylabel('Vertikale Position in mm')
             zlabel('Temperatur in °C')
             title(plotName)
             colorbar('peer',gca);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f23_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f23_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f23_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f23_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
            imageNames{23}=strcat(path,inFile,'_f23_',plotName,'.tikz');
         %% %create y limits for figure 24
%             minVec=[min(min(Post(rmin:rmax,152:155))),min(min(Post(rmin:rmax,155)))];
%             maxVec=[max(max(Post(rmin:rmax,152:155))),max(max(Post(rmin:rmax,155)))];
%             ymin = floor(min(minVec));
%             ymax = ceil (max(maxVec));
%             if isnan(ymin) || isnan(ymax) || ymin==ymax
%             ymin = 0; ymax = 1;
%             end
%         %%%Figure for CoolingCapacity of refrigerant(s)
%             hFig=figure(24);
%             set(hFig, 'Position', [50 50 1024 600]);
%             plotName='CoolingCapacityByRefrigerant';
%             plot(Post(rmin:rmax,1),Post(rmin:rmax,152:155))
%             hold all
%             %plot(Post(rmin:rmax,1),Post(rmin:rmax,148),Post(rmin:rmax,1),Post(rmin:rmax,149))
%             %adjust plot appearance
%             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
%             axis([time2start time2stop ymin ymax])
%             xlabel(plotLabelX)
%             ylabel('Leistung in kW')
%             datetick('x',datetickStyle,'keepticks')
%             title(strcat(plotTitle,plotName))
%             h=legend(DefVarNames{152:155},'Location','NorthEastOutside');
%             set(h,'FontSize',textSizeLegend);
%             hold off
%             SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
%         %Save figure into file
%             print(gcf,'-dpng', strcat(path,inFile,'_f24_',plotName,'.png'));
%             print(gcf,'-dmeta', strcat(path,inFile,'_f24_',plotName,'.emf'));
%             print(gcf,'-depsc', strcat(path,inFile,'_f24_',plotName,'.eps'));
%             matlab2tikz(strcat(path,inFile,'_f24_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
%             imageNames{24}=strcat(path,inFile,'_f24_',plotName,'.tikz');
%         %% %create y limits for figure 25
%             minVec=[min(min(Post(rmin:rmax,173:176))),min(min(Post(rmin:rmax,178))),min(min(Post(rmin:rmax,142)))];
%             maxVec=[max(max(Post(rmin:rmax,173:176))),max(max(Post(rmin:rmax,178))),max(max(Post(rmin:rmax,142)))];
%             ymin = floor(min(minVec));
%             ymax = ceil (max(maxVec));
%             if isnan(ymin) || isnan(ymax) || ymin==ymax
%             ymin = 0; ymax = 1;
%             end
%         %%%Figure for CoolingCapacity of refrigerant and air
%             hFig=figure(25);
%             set(hFig, 'Position', [50 50 1024 600]);
%             plotName='CoolingCapacityComparison';
%             plot(Post(rmin:rmax,1),Post(rmin:rmax,175:176),'LineStyle','--')
%             hold all
%             plot(Post(rmin:rmax,1),Post(rmin:rmax,173:174),Post(rmin:rmax,1),Post(rmin:rmax,178),Post(rmin:rmax,1),Post(rmin:rmax,142))
%         %adjust plot appearance
%             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
%             axis([time2start time2stop ymin ymax])
%             xlabel(plotLabelX)
%             ylabel('Leistung in kW')
%             datetick('x',datetickStyle,'keepticks')           
%             hLabel = get(gca,'XLabel');
%             title(strcat(plotTitle,plotName))
%             h = legend(DefVarNames{175:176},DefVarNames{173:174},DefVarNames{178},DefVarNames{142},'Location','NorthEastOutside');
%             set(h,'FontSize',textSizeLegend); 
%             hold off
%             SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
%         %Save figure into file
%             print(gcf,'-dpng', strcat(path,inFile,'_f25_',plotName,'.png'));
%             print(gcf,'-dmeta', strcat(path,inFile,'_f25_',plotName,'.emf')); 
%             print(gcf,'-depsc', strcat(path,inFile,'_f25_',plotName,'.eps'));
%             matlab2tikz(strcat(path,inFile,'_f25_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', '\figureheight', 'width', '\figurewidth');
%             imageNames{25}=strcat(path,inFile,'_f25_',plotName,'.tikz');
%         %% %create y limits for figure 26
%             minVec=[min(min(Post(rmin:rmax,170:171))),min(min(Post(rmin:rmax,179))),min(min(Post(rmin:rmax,180)))];
%             maxVec=[max(max(Post(rmin:rmax,170:171))),max(max(Post(rmin:rmax,179))),max(max(Post(rmin:rmax,180)))];
%             ymin = floor(min(minVec));
%             ymax = ceil (max(maxVec));
%             if isnan(ymin) || isnan(ymax) || ymin==ymax
%             ymin = 0; ymax = 1;
%             end
%         %%%Figure for CoolingCapacity of refrigerant and air
%             hFig=figure(26);
%             set(hFig, 'Position', [50 50 1024 600]);
%             plotName='CalculatedIdealMixedAirConditions';
%             plot(Post(rmin:rmax,1),Post(rmin:rmax,170:171),'LineStyle','--')
%             hold all
%             plot(Post(rmin:rmax,1),Post(rmin:rmax,179:180))
%         %adjust plot appearance
%             set(gca,'fontsize',textSizeGlobal,'FontName','arial');
%             axis([time2start time2stop ymin ymax])
%             xlabel(plotLabelX)
%             ylabel('Value')
%             datetick('x',datetickStyle,'keepticks')           
%             hLabel = get(gca,'XLabel');
%             title(strcat(plotTitle,plotName))
%             h = legend(DefVarNames{170:171},DefVarNames{179:180},'Location','NorthEastOutside');
%             set(h,'FontSize',textSizeLegend); 
%             hold off
%             %SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
%         %Save figure into file
%             print(gcf,'-dpng', strcat(path,inFile,'_f26_',plotName,'.png'));
%             print(gcf,'-dmeta', strcat(path,inFile,'_f26_',plotName,'.emf')); 
%             print(gcf,'-depsc', strcat(path,inFile,'_f26_',plotName,'.eps'));
%             matlab2tikz(strcat(path,inFile,'_f26_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', '\figureheight', 'width', '\figurewidth');
%             imageNames{25}=strcat(path,inFile,'_f26_',plotName,'.tikz');
    end
    %% %create file with filenames for latex
    if ExportFigureListFlag == 1
        fid = fopen(strcat(path,inFile,'_listOfFigures_allFigures.tex'), 'w+','n','UTF-8');
        fopen(fid);
        UseTikz=0;
        UsePng=1;
        UseEPS=0;
        if smoothAll==1
            fprintf(fid,'%%\\section{%s-smoothed}\n\\newpage\n',strrep(inFile,'_','-'));
        else
            fprintf(fid,'%%\\section{%s}\n\\newpage\n',strrep(inFile,'_','-'));
        end
        for i=1: length(imageNames)
            if ~isempty(imageNames{i})
                fprintf(fid,'\\begin{figure}[H]\n');
                if UseTikz==1
                    fprintf(fid,'\\setlength\\figureheight{0.3\\textwidth}\n');
                    fprintf(fid,'\\setlength\\figurewidth{0.4\\textwidth}\n');
                    fprintf(fid,'\\input{%s}\n',strrep(char(imageNames(i,:)),'\','/'));
                elseif UsePng==1 
                    fprintf(fid,'\\includegraphics[angle = 90, width=0.85\\textwidth]{%s}\n',strrep(strrep(char(imageNames(i,:)),'\','/'),'.tikz','.png'));
                else
                    fprintf(fid,'\\includegraphics[angle = 90, width=0.85\\textwidth]{%s}\n',strrep(strrep(char(imageNames(i,:)),'\','/'),'.tikz',''));
                end
                if smoothAll==1
                    fprintf(fid,'\\label{fig:%s-%d-smoothed}\n',strrep(inFile,'_','-'), i);
                    Cap = char(cellstr(imageNames(i,:)));
                    fprintf(fid,'\\caption{%s-smoothed}\n',strrep(Cap((length(path)+1):(end-5)),'_','-') );
                else
                    fprintf(fid,'\\label{fig:%s-%d}\n',strrep(inFile,'_','-'), i);
                    Cap = char(cellstr(imageNames(i,:)));
                    fprintf(fid,'\\caption{%s}\n',strrep(Cap((length(path)+1):(end-5)),'_','-') );
                end

                fprintf(fid,'\\end{figure}\n\n');
            end
        end
        fclose(fid);
    end
    %% %export data to latex table
    %create file with filenames for latex
    if ExportTableMeansFlag == 1
        fid = fopen(strcat(path,inFile,'_meanValues_TexTable.tex'), 'w+','n','UTF-8');
        fopen(fid);
        if smoothAll==1
            tabCaption = strcat( strrep(inFile,'_','-'),'-smoothed');
        else
            tabCaption = strcat( strrep(inFile,'_','-'),'-regular');
        end
        tabLabel = tabCaption;
        fprintf(fid,'\\begin{longtable}{|l|r|l|}\n');
        fprintf(fid,'\\caption{%s} \n',tabCaption);
        fprintf(fid,'\\label{tab:%s}\\\\ \n\n',tabLabel);
        %fprintf(fid,'\\centering\n');
            %fprintf(fid,'\\begin{tabular}{|l|r|l|} \n');
           fprintf(fid,'\\hline\n');
           %fprintf(fid,'\\multicolumn{3}{|c|}{%s} \\\\\n',tabCaption);
           %fprintf(fid,'\\hline\n');
           fprintf(fid,'\\textbf{Name}&\\textbf{Wert}&\\textbf{Einheit}\\\\ \n');
           fprintf(fid,'\\hline\n');
           fprintf(fid,'\\endfirsthead\n\n');

            fprintf(fid,'\\hline\n');
            fprintf(fid,'\\multicolumn{3}{|c|}{Fortsetzung: %s} \\\\\n', tabCaption);
            fprintf(fid,'\\hline\n');
            fprintf(fid,'\\textbf{Name}&\\textbf{Wert}&\\textbf{Einheit}\\\\ \n');
            fprintf(fid,'\\hline\n');
            fprintf(fid,'\\endhead\n\n');

            %fprintf(fid,'\\hline\n');
            fprintf(fid,'\\multicolumn{3}{|c|}{Fortsetzung auf nächster Seite...} \\\\\n');
            fprintf(fid,'\\hline\n');
            fprintf(fid,'\\endfoot\n\n');

            %fprintf(fid,'\\hline\n');
            fprintf(fid,'\\multicolumn{3}{|c|}{Ende: %s} \\\\\n',tabCaption);
            fprintf(fid,'\\hline\n');
            fprintf(fid,'\\endlastfoot\n\n');

            for j=2:length(Post(1,:))
                if DefUnits{j}=='%'
                    Unit = '\%';
                else 
                    Unit = DefUnits{j};
                end
                if ~strncmp('free',DefVarNames{j},4)
                    if tmpExport(row4Mean,j) == 0.00 %filtering of not used variables
                        fprintf(fid,'%s & --- & --- \\\\ \n',DefVarNames{j});
                    else
                        fprintf(fid,'%s & %0.2f & %s \\\\ \n',DefVarNames{j},tmpExport(row4Mean,j),Unit);
                    end
                    fprintf(fid,'\\hline\n');
                end
            end
            %fprintf(fid,'\\end{tabular}\n');

        fprintf(fid,'\\end{longtable}\n\n');

        fclose(fid);
    end
    %%
    Msg = sprintf('/*************/ \nFinished processing CaseID: %d\n/*************/',CaseID);
    disp (Msg);
end