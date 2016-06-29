

%% SUP1
gridValues(3,:)=tmpExport2(1,2:16);%z
gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
[X,Y]=meshgrid(0:9:918, 0:9:612);
vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');

surf(vq);figure(gcf);

%% SUP2
gridValues(3,:)=tmpExport2(1,17:31);%z
gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
[X,Y]=meshgrid(0:9:918, 0:9:612);
vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');

surf(vq);figure(gcf);

%% SUP3
gridValues(3,:)=tmpExport2(1,32:46);%z
gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
[X,Y]=meshgrid(0:9:918, 0:9:612);
vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');

surf(vq);figure(gcf);

%% EXA1
gridValues(3,:)=tmpExport2(1,47:61);%z
gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
[X,Y]=meshgrid(0:9:918, 0:9:612);
vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');

surf(vq);figure(gcf);

%% EXA2
gridValues(3,:)=tmpExport2(1,62:76);%z
gridValues(2,:)=[459,459,459,459,459,306,306,306,306,306,153,153,153,153,153];%y
gridValues(1,:)=[64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75,64.25,266.2,459,615.8,853.75];%x
[X,Y]=meshgrid(0:9:918, 0:9:612);
vq=griddata(gridValues(1,:),gridValues(2,:),gridValues(3,:),X,Y,'cubic');

surf(vq);figure(gcf);