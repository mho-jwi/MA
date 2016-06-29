function errorMsg = EBC_lineplot(figureHdl,Xdata,YMatrix,numberOfColors,lineWidth,IntensityLevel)
%Plots an array of elements like the matlab plot-function and changes the
%line colors due to the EBC-defined-style, line width, number of colors and color intensity are adjustable 
%Function plots up to 28 different lines ( 4 line styles with 7 colors
%each)
% hFig = FigureHanlde, but not used yet
% xAxis-Array = Array to use for data in x-direction
% yAxis-DataArray*= Array of data to plot on y axis -- *can contain different columns of data by using [ col1, col3, col6, ...]
% numberOfColors = number of colors to use before switching to new linestyle, range [1....7]
% LineWidth = defines width of lines in plot
% EBC_IntensityLevel = Level of intensity or style to use: 1 for most intense apperance, 2 mid intensity (recommended for lines), 3 light intensity(recommende for backrounds)
         EBC_ColorMap=get_EBC_lineColorMap(IntensityLevel);
         plot1 = plot(Xdata,YMatrix);
         if numberOfColors >7
            errorMsg = 'Only 7 colors are available. Please correct your inpput data!';
         end
         for i=1:length(YMatrix(1,:))
             if i<=numberOfColors
                set(plot1(i),'Color',EBC_ColorMap(i,:),'LineWidth',lineWidth);
             elseif numberOfColors < i && i<= 2*numberOfColors 
                set(plot1(i),'Color',EBC_ColorMap((i-numberOfColors),:),'LineStyle',':','LineWidth',lineWidth);
             elseif 2*numberOfColors < i && i<= 3*numberOfColors
                set(plot1(i),'Color',EBC_ColorMap((i-2*numberOfColors),:),'LineStyle','--','LineWidth',lineWidth);
             elseif 3*numberOfColors < i && i<= 4*numberOfColors
                set(plot1(i),'Color',EBC_ColorMap((i-3*numberOfColors),:),'LineStyle','-.','LineWidth',lineWidth); 
             else
                errorMsg = 'Number of available combinations from color and style is exceeded. Please mofify your input data!';
             end
         end
end

