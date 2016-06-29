function EBC_Color_R = get_EBC_lineColorMap(IntensityLevel)
%Container for EBC-sytle defined line colors in RGB-space
%line color values specified by Prof. Müller for plots from the EBC

    %% %set EBC-colors according to definition by Michael Adolph
    if IntensityLevel==3 %%backround only
        EBC_Color(1,:)=[244 162 158];
        EBC_Color(2,:)=[147	180	220];
        EBC_Color(3,:)=[251	192	158];
        EBC_Color(4,:)=[183	156	180];
        EBC_Color(5,:)=[210	156	154];
        EBC_Color(6,:)=[231	167	206];
        EBC_Color(7,:)=[140	201	172];
        EBC_Color_R = EBC_Color/255; %rescale RGB to 0-100%
    elseif IntensityLevel==2 %%lines only
        EBC_Color(1,:)=[236 99 92];
        EBC_Color(2,:)=[75 129 196];
        EBC_Color(3,:)=[244 153 97];
        EBC_Color(4,:)=[135 104 180];
        EBC_Color(5,:)=[180 89 85];
        EBC_Color(6,:)=[203 116 172];
        EBC_Color(7,:)=[63 165 116];
        EBC_Color_R = EBC_Color/255; %rescale RGB to 0-100%
    else %%highest intensity for marker or lines
        EBC_Color(1,:)=[229	48	39];
        EBC_Color(2,:)=[16	88	176];
        EBC_Color(3,:)=[244	115	40];
        EBC_Color(4,:)=[95	55	155];
        EBC_Color(5,:)=[155	35	30];
        EBC_Color(6,:)=[190	65	152];
        EBC_Color(7,:)=[0	140	70];
        EBC_Color_R = EBC_Color/255; %rescale RGB to 0-100%
    end
end

