clearvars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% generate individual time series for each identified peak
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%time and pressure range
TimeScale = datenum(1994,8,1):1:datenum(2019,12,31);
% TimeScale = datenum(2000,1,1):1:datenum(2005,12,31);
PrsRange = [10000,0];
TimeWindow = 3; %days

%what data do we want?
Range = 500; %km
Generate = 0; %only generate new data if needed, it is *very* slow

%how much to smooth?
SmoothSize = 91;

%how many days to be highlighted?
MinDaysSpecial = 2000;

%what range of lags to try?
LagSteps = 0; %set this to zero, as when I tried it there was no intra-dataset consistency so it's just optimising for noise.


%individual series to generate
Names = {}; Lons = []; Lats = [];
% Names{end+1} = 'South Pole';        Lons(end+1) =    0; Lats(end+1) = -90;  %this is a test, should return nothing
% Names{end+1} = 'Libya';            Lons(end+1) = 20; Lats(end+1) =  30;  %another test, has very poor time coverage so unsuitable for paper but good way to check time-handling code.
Names{end+1} = 'Rockies';           Lons(end+1) = -110; Lats(end+1) = 40; 
Names{end+1} = 'Iceland';           Lons(end+1) =  -18; Lats(end+1) = 65; 
Names{end+1} = 'Newfoundland';      Lons(end+1) =  -60; Lats(end+1) = 48; 
Names{end+1} = 'Greenland';         Lons(end+1) =  -47; Lats(end+1) = 64;
Names{end+1} = 'UK';                Lons(end+1) =   -2; Lats(end+1) = 54; 
Names{end+1} = 'Iran';              Lons(end+1) =   49; Lats(end+1) = 35;
Names{end+1} = 'Altai';             Lons(end+1) =   90; Lats(end+1) = 52;
Names{end+1} = 'Sikhote Alin';      Lons(end+1) =  138; Lats(end+1) = 48;
Names{end+1} = 'Urals';             Lons(end+1) =   65; Lats(end+1) = 62;
Names{end+1} = 'Alps/Balkans';      Lons(end+1) =   15; Lats(end+1) = 46;
Names{end+1} = 'Canadian Plains';   Lons(end+1) = -110; Lats(end+1) = 61;
Names{end+1} = 'Siberia';           Lons(end+1) =  100; Lats(end+1) = 65;
Names{end+1} = 'Great Lakes';       Lons(end+1) =  -83; Lats(end+1) = 46.5;
Names{end+1} = 'North Atlantic';    Lons(end+1) =  -30; Lats(end+1) = 52;
Names{end+1} = 'Azores';            Lons(end+1) =  -25; Lats(end+1) = 37;
Names{end+1} = 'CMR Border';        Lons(end+1) =  120; Lats(end+1) = 55;
Names{end+1} = 'West Russia';       Lons(end+1) =   40; Lats(end+1) = 55; 
Names{end+1} = 'Afghanistan';       Lons(end+1) =   69; Lats(end+1) = 38;

%order is hardcoded to be the same as the small multiples annualised plots
Order = [1;14;3;5;13;6;10;18;4;11;16;2;15;7;8;17;12;9];
Lons  = Lons(Order);
Lats  = Lats(Order);
Names = Names(Order);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% generate the time series (if needed)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Generate == 1;
  
  for iSeries = 1:1:numel(Names);
    disp(['Processing box over ',Names{iSeries}])
    
    %generate the time series
    func_generate_composite_time_series_lt(urlencode(Names{iSeries}),Lons(iSeries),Lats(iSeries),Range, PrsRange,TimeScale, 'STT_A', 'nanmean', TimeWindow)

    %open the file we just created and store the location metadata, to allow us to decouple the processing
    File = load(['data/',urlencode(Names{iSeries}),'.mat']);
    File.Lon = Lons(iSeries); 
    File.Lat = Lats(iSeries); 
    pause(0.1) %read/write time too fast otherwise
    save(['data/',urlencode(Names{iSeries}),'.mat'],'File')
  end
end
clear LatRange LonRange iSeries Generate Range File Lars Lons Oro PrsRange TimeWindow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the comparisons - individual
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prepare figure
clf
set(gcf,'color','w')
subplot = @(m,n,p) subtightplot (m, n, p, [0.025, 0.012], [0.05 0.1], [0.15 0.1]);

%prepare panel
subplot(3,3,[1,2,4,5])
hold on
axis([-1 1 0.5 numel(Names)+0.5])
box on; grid off
set(gca,'ydir','reverse')
set(gca,'ytick',[],'xtick',[])
Letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

%correlation lines
plot([1,1].*-1,[0.5 numel(Names)+0.5],'k-')
plot([1,1].*-0.25,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*0.5,[0.5 numel(Names)+0.5],'k--')
plot([1,1].*-0.75,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*0, [0.5 numel(Names)+0.5],'k-')
plot([1,1].*0.25,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*-0.5,[0.5 numel(Names)+0.5],'k--')
plot([1,1].*0.75,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*1, [0.5 numel(Names)+0.5],'k-')

%key
plot(-1,-0.25,'kd','markerfacecolor',[51,153,255]./255,'clipping','off','markersize',10); 
text(-0.97,-0.28,'Nino3.4','verticalalignment','middle','horizontalalignment','left','fontsize',16,'color',[51,153,255]./255,'fontweight','bold')  

plot(-0.72,-0.25,'ko','markerfacecolor','r','clipping','off','markersize',10); 
text(-0.69,-0.28,'NAM','verticalalignment','middle','horizontalalignment','left','fontsize',16,'color','r','fontweight','bold')    

plot(-0.52,-0.25,'ks','markerfacecolor',[255,128,0]./255,'clipping','off','markersize',10); 
text(-0.49,-0.28,'QBO-50','verticalalignment','middle','horizontalalignment','left','fontsize',16,'color',[255,128,0]./255,'fontweight','bold')   

plot(-0.28,-0.25,'k^','markerfacecolor',[153,51,255]./255,'clipping','off','markersize',10); 
text(-0.25,-0.28,'TSI','verticalalignment','middle','horizontalalignment','left','fontsize',16,'color',[153,51,255]./255,'fontweight','bold')   

plot(-0.08,-0.25,'kv','markerfacecolor',[128,128,128]./255,'clipping','off','markersize',10); 
text(-0.05,-0.28,'HadCRUT','verticalalignment','middle','horizontalalignment','left','fontsize',16,'color',[128,128,128]./255,'fontweight','bold')   


text(0.27,-0.28,['\it{All data smoothed ',num2str(SmoothSize),' days (except NAM, 7 days)}'],'fontsize',12)


CorrStore = NaN(5,numel(Names));
NStore    = NaN(numel(Names),1);
LagStore  = CorrStore;

for iSeries=1:1:numel(Names)
  
  %plot a basic line as a marker
  plot([-2,2],[1,1].*iSeries,'-','color',[1,1,1].*0.5)
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %correlate time series
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
  %get data
  File = ['data/',urlencode(Names{iSeries}),'.mat'];
  if ~exist(File,'file'); continue; end
  load(File);
  
  %extract and smooth time series
  Time = File.Settings.TimeScale;
  Amp  = smoothn2(File.Results.STT_A,[SmoothSize,1]);
  clear File
  
  %how many useful days of data at this location?
  UsefulDays = sum(~isnan(Amp));  
  NStore(iSeries) = UsefulDays;
  
  if UsefulDays < MinDaysSpecial; Alpha = 0.33; else Alpha = 1; end

  %ENSO
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ENSO = load([LocalDataDir,'/Miscellany/nino34.mat']);
  ENSO.Nino34 = smoothn2(ENSO.Nino34,[SmoothSize,1]);
  ENSO.NewTime = datenum(1994,1,1):1:datenum(2019,12,31);  
  ENSO.Nino34 = interp1(ENSO.Time,ENSO.Nino34,ENSO.NewTime)'; 
  
  %NAM
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  NAM = load([LocalDataDir,'/Miscellany/daily_nam.mat']);
  NAM.NAM = smoothn2(NAM.NAM,[7,1]); %NOTE SEVEN DAY SMOOTHER, NOT THE SAME AS THE OTHERS
  
  %QBO
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  QBO = load([LocalDataDir,'/Miscellany/QBO.mat']);
  QBO.Time = floor(QBO.Time); %shift from noon to midnight to make the logic easier - on a 91-day smoothing this is very minor...
  QBO.QBO = smoothn2(QBO.QBO,[SmoothSize,1]);
  
  %TSI
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  TSI = load([LocalDataDir,'/Miscellany/tsi.mat']);
  TSI.TSI = smoothn2(TSI.TSI,[SmoothSize,1]);
  
  %HadCRUT
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  HadCrut = rCDF([LocalDataDir,'/Miscellany/HadCRUT.4.6.0.0.median.nc']);
  HadCrut.MatlabTime = datenum(1850,1,HadCrut.time);
  HadCrut.NH = squeeze(nanmean(HadCrut.temperature_anomaly(:,HadCrut.latitude > 0,:),[1,2]));
  HadCrut.NewTime = datenum(1994,1,1):1:datenum(2019,12,31);
  HadCrut.NH = interp1(HadCrut.MatlabTime,HadCrut.NH,HadCrut.NewTime);
  
  %simple linear trend (for testing)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  Lin.Lin = 1:1:numel(TimeScale);
  Lin.Time = TimeScale;
  
 
  for iIndex=1:1:5;
    
    switch iIndex
%       case 1; ThisIndex = Lin.Lin'; ThisTime = Lin.Time';      %for testing
      case 1; ThisIndex = ENSO.Nino34; ThisTime = ENSO.NewTime';
      case 2; ThisIndex = NAM.NAM;     ThisTime = NAM.Time;
      case 3; ThisIndex = QBO.QBO;     ThisTime = QBO.Time;
      case 4; ThisIndex = TSI.TSI;     ThisTime = TSI.Time;
      case 5; ThisIndex = HadCrut.NH'; ThisTime = HadCrut.NewTime';
      otherwise
        stop
    end
    
    %we have data. Try repeatedly shifting the lag to get the best correlation, in case there's a lag correlation the data is hiding
    %look at LagStore by eye afterwards - if there's no consistency, then we're just optimising for nosie and this shouldn't be done
    CorrStore(iIndex,iSeries) = 0;
    for Lag = LagSteps
      
      %lag the data
      A = circshift(Amp,Lag);
      B = ThisIndex;
      
      %remove points which have gone off the end
      if     Lag > 0; A(      1:Lag) = NaN; B(      1:Lag) = NaN;
      elseif Lag < 0  A(end-Lag:end) = NaN; B(end-Lag:end) = NaN;
      end

      %find r
      [CommonDays,ia,ib] = intersect(Time,ThisTime);
      Good = find(~isnan(CommonDays + A(ia) + B(ib)));
      if numel(Good) > 1;
        r = corrcoef(A(Good),B(Good)); r = r(2);
        if abs(r) > abs(CorrStore(iIndex,iSeries)); CorrStore(iIndex,iSeries) = r; LagStore(iIndex,iSeries) = Lag; end
      end
      
    end
  end

  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %plot
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
   
  h = plot(CorrStore(1,iSeries), iSeries,'ko','markerfacecolor','r','markersize',10);
  hm1 = setMarkerColor(h,'r',Alpha);
  
  h = plot(CorrStore(2,iSeries),iSeries,'kd','markerfacecolor',[51,153,255]./255,'markersize',10);
  hm1 = setMarkerColor(h,[51,153,255]./255,Alpha);
  
  h = plot(CorrStore(3,iSeries), iSeries,'ks','markerfacecolor',[255,128,0]./255,'markersize',10);
  hm1 = setMarkerColor(h,[255,128,0]./255,Alpha);
  
  h = plot(CorrStore(4,iSeries),iSeries,'k^','markerfacecolor',[153,51,255]./255,'markersize',10); 
  hm1 = setMarkerColor(h,[153,51,255]./255,Alpha);
   
  h = plot(CorrStore(5,iSeries),iSeries,'kv','markerfacecolor',[128,128,128]./255,'markersize',10);
  hm1 = setMarkerColor(h,[128,128,128]./255,Alpha);
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %location name
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

  %final labelling
  text(-1.02,iSeries,[Names{iSeries},' (',Letters(iSeries),')'],'verticalalignment','middle','horizontalalignment','right','fontsize',14)  
% %   if UsefulDays > MinDaysSpecial
% %     text(1.22,iSeries,[num2str(UsefulDays),' days:'],'verticalalignment','middle','horizontalalignment', 'right','fontsize',14)  
% %   else
% %     text(1.22,iSeries,['\it{',num2str(UsefulDays),' days}:'],'verticalalignment','middle','horizontalalignment', 'right','fontsize',14)    
% %   end
  
  
  
  
  drawnow
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the comparisons - statistical
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%prepare axes
subplot(3,3,[7,8])
cla
axis([-1 1 0.5 5.5])
hold on
box on; grid off; set(gca,'ytick',[],'xtick',-1:0.25:1,'ydir','reverse')
xlabel('Pearson Linear Correlation Coefficient')

%correlation lines
plot([1,1].*-1,[0.5 numel(Names)+0.5],'k-')
plot([1,1].*-0.25,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*0.5,[0.5 numel(Names)+0.5],'k--')
plot([1,1].*-0.75,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*0, [0.5 numel(Names)+0.5],'k-')
plot([1,1].*0.25,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*-0.5,[0.5 numel(Names)+0.5],'k--')
plot([1,1].*0.75,[0.5 numel(Names)+0.5],'k:')
plot([1,1].*1, [0.5 numel(Names)+0.5],'k-')

%horizontal lines
for iX=1:1:5;plot([-2,2],[1,1].*iX,'-','color',[1,1,1].*0.5); end

%plot the distributions, and box-and-whisker plots
for iVar=1:1:size(CorrStore,1);
  
  %find colours
  switch iVar; 
    case 2; Colour = 'r';                Shape = 'o';
    case 1; Colour = [51,153,255]./255;  Shape = 'd';
    case 3; Colour = [255,128,0]./255;   Shape = 's';
    case 4; Colour = [153,51,255]./255;  Shape = '^';
    case 5; Colour = [128,128,128]./255; Shape = 'v';
  end
  
  %compute and plot box/whisker diagram
  Points = prctile(CorrStore(iVar,:),[0,2.5,18,50,82,97.5,100]);
  for iPoint=2:1:6; plot([1,1].*Points(iPoint),iVar+[-1,1].*0.33,'color',Colour,'linewi',2);  end
  plot(Points([2,6]),iVar.*[1,1],'color',Colour,'linewi',2)
  patch(Points([3,5,5,3,3]),iVar+0.33.*[-1,-1,1,1,-1],Colour)
  plot([1,1].*Points(4),[-1,1].*0.33 + iVar,'k-','linewi',2)
  
%   %plot individual points
%   plot(CorrStore(iVar,:),iVar.*ones(numel(Names),1),Shape,'color','k','markerfacecolor','w')
  
  %plot points with plenty of data
  plot(CorrStore(iVar,NStore > MinDaysSpecial),iVar.*ones(numel(find(NStore > MinDaysSpecial)),1)-0.15,Shape,'color','k','markerfacecolor','k')  
  %and those with less data
  plot(CorrStore(iVar,NStore < MinDaysSpecial),iVar.*ones(numel(find(NStore < MinDaysSpecial)),1)+0.15,Shape,'color','k','markerfacecolor','w')
  
end


%plot the titles
text(-1.02,2,'NAM','verticalalignment','middle','horizontalalignment','right','fontsize',14,'color','r','fontweight','bold') 
text(-1.02,1,'Nino3.4','verticalalignment','middle','horizontalalignment','right','fontsize',14,'color',[51,153,255]./255,'fontweight','bold') 
text(-1.02,3,'QBO-50','verticalalignment','middle','horizontalalignment','right','fontsize',14,'color',[255,128,0]./255,'fontweight','bold') 
text(-1.02,4,'TSI','verticalalignment','middle','horizontalalignment','right','fontsize',14,'color',[153,51,255]./255,'fontweight','bold') 
text(-1.02,5,'HadCRUT','verticalalignment','middle','horizontalalignment','right','fontsize',14,'color',[128,128,128]./255,'fontweight','bold') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the data coverage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(3,3,[3,6])
cla
axis([min(TimeScale) datenum(2020,1,1)  0.5 numel(Names)+0.5]);
box on; grid on; hold on

for iSeries=1:1:numel(Names)
  
  %plot a basic line as a marker
  plot([min(TimeScale) datenum(2020,1,1)],[1,1].*iSeries,'-','color',[1,1,1].*0.5)  
  
  %get data
  File = ['data/',urlencode(Names{iSeries}),'.mat'];
  if ~exist(File,'file'); continue; end
  load(File);
    
  %plot days covered
  Vals = ~isnan(File.Results.STT_A); 
  for iDay=1:1:numel(Vals)
    if Vals(iDay) == 1;
    plot([1,1].*TimeScale(iDay),[-1,1].*0.33+iSeries,'k-')
    end
  end

  text(datenum(2020,1,50),iSeries,['(',Letters(iSeries),') ',Names{iSeries}],'verticalalignment','middle','horizontalalignment','left','fontsize',14)  

  drawnow
end
datetick('x','yyyy','keeplimits')
set(gca,'ydir','reverse','ytick',[])

