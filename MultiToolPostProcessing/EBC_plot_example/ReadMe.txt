source:https://svn.rwth-aachen.de/repos/EBC_SVN/resources/MatLab/library/utilities/EBC_plot_example
Author: P.Steinhoff
last editet: 14th April 2014

issue	editor			topic
1	P. Steinhoff		Initial upload of plotting function for MALTAB with "EBC-Standard"-color-coding







Example:

	numberOfColors = 5; %defines number of colors used before linestyle is changed
	LineWidth =2.0; % self-explaining
	EBC_IntensityLevel=1; % intensity according to specification from EBC-CEO (https://ercwiki.eonerc.rwth-aachen.de/ebc/tiki-index.php?page=Plot+Parameter)
	EBC_lineplot(hFig,xAxis-Array,yAxis-DataArray*,numberOfColors,LineWidth, EBC_IntensityLevel)


hFig = FigureHanlde, but not used yet
xAxis-Array = Array to use for data in x-direction
yAxis-DataArray*= Array of data to plot on y axis -- *can contain different columns of data by using [ col1, col3, col6, ...]
numberOfColors = number of colors to use before switching to new linestyle, range [1....7]
LineWidth = defines width of lines in plot
EBC_IntensityLevel = Level of intensity or style to use: 1 for most intense apperance, 2 mid intensity (recommended for lines), 3 light intensity(recommende for backrounds)




code-example in Matlab:

	start='2014-01-29_04-30';
        stop='2014-01-29_05-20';

	%% %conversion into matlab time 
    	time2start = datenum(start,'yyyy-mm-dd_HH-MM')-datenum('2014-01-01_00-00','yyyy-mm-dd_HH-MM');
    	time2stop = datenum(stop,'yyyy-mm-dd_HH-MM')-datenum('2014-01-01_00-00','yyyy-mm-dd_HH-MM');

        %set plot-label and title
        plotTitle = 'Zeitlicher Verlauf: .';
        plotLabelX = 'Uhrzeit in HH:MM:SS';

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

        %% %create y limits for figure 
            minVec=[min(min(Post(rmin:rmax,15:21))),min(min(Post(rmin:rmax,115))),min(min(Post(rmin:rmax,51:57))),min(min(Post(rmin:rmax,118)))];
            maxVec=[max(max(Post(rmin:rmax,15:21))),max(max(Post(rmin:rmax,115))),max(max(Post(rmin:rmax,51:57))),max(max(Post(rmin:rmax,118)))];
            ymin = floor(min(minVec));
            ymax = ceil (max(maxVec));
            if isnan(ymin) || isnan(ymax) || ymin==ymax
            ymin = 0; ymax = 1;
            end
        %%%Figure for air temperaturesBehHeat1 I/O:
            hFig=figure(1);%set unique figure ID
            set(hFig, 'Position', [50 50 1024 600]);
            plotName='AirTemperaturesBehHeat_1';
            numberOfColors = 3;%adjust number of colors if required
            EBC_lineplot(hFig,Post(rmin:rmax,1),Post(rmin:rmax,[15:21,115]),numberOfColors,LineWidth,EBC_IntensityLevel)
        %adjust plot appearance
            set(gca,'fontsize',textSizeGlobal,'FontName','arial');
            axis([time2start time2stop ymin ymax])
            xlabel(plotLabelX)
            ylabel('Lufttemperatur in °C')
            datetick('x',datetickStyle,'keepticks')
            title(strcat(plotTitle,plotName))
            h=legend(DefVarNames{15:21},DefVarNames{115},'Location','NorthEastOutside');
            set(h,'FontSize',textSizeLegend);
            SetNumberOfTicklabel(gca,NxTicks,datetickStyle);
        %Save figure into file
            print(gcf,'-dpng', strcat(path,inFile,'_f1_',plotName,'.png'));
            print(gcf,'-dmeta', strcat(path,inFile,'_f1_',plotName,'.emf'));
            print(gcf,'-depsc', strcat(path,inFile,'_f1_',plotName,'.eps'));
            matlab2tikz(strcat(path,inFile,'_f1_',plotName,'.tikz'),'showInfo',false, 'encoding','UTF-8','height', 'height', '\figureheight', 'width', '\figurewidth');
		%% matlab2tikz used from: https://svn.rwth-aachen.de/repos/EBC_SVN/resources/MatLab/library/utilities/EBC_plot_example/matlab2tikz_0.4.6 )