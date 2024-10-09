function [AZb, ELb, beamid, op_path] = plotPFISR_NeTe_automated_lp_input_2(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)
 if start_hour-1<=0
    start_hour_t1=start_hour
else
    start_hour_t1=start_hour-1
end
if end_hour+1 >= 24
    end_hour_t2=end_hour
else
    end_hour_t2=end_hour+1
end


t1=datenum([year month day start_hour_t1 start_min 0])
t2=datenum([year month day end_hour_t2 end_min 0])
scintstart=datenum([year month day start_hour start_min 0])
scintend=datenum([year month day end_hour end_min 0])


flag='Ne'
beam=64157
codetype='lp'






hold on


    t0 = t1;
    tf = t2;



alt_cutoff = 195; % km
mat_path = 'E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_2';



[year,month,day,hour,min,sec]=datevec(t1)

Madrigal = load_pfisr_matfile_input_2(year,month,day,5950,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
Madrigalac = load_pfisr_matfile_input_2(year,month,day,5951,hour,hour2,hour3,min1,min2,min3,PRN,doyin);

if codetype=='lp'
    if exist('Madrigal')

PFISR_data = Madrigal;

end    
data = Madrigal;

tfutc=end_hour_t2+(end_min/60)
toutc=start_hour_t1+(start_min/60)

data = data(data(:,5) <= tfutc & data(:,5) >=toutc,:);





    
    
    
    
end

ab=isempty(data)

if ab==1
    
else



alt_cutoff=195

switch codetype
    case 'lp'
data = data(data(:,2) > alt_cutoff,:);
    case 'ac'
        data = data(data(:,2) <= alt_cutoff, :);
end
data = data(data(:,4) == 77.5, :);
        data = data(data(:,1) == -154.3, :);
        utc_times_unique=unique(data(:,5))
if ~isempty(data)
   
        
        
        
       
            
            
            
            
            
               
                      
        

        
timeu=unique(data(:,5))
altu=unique(data(:,2))
for ci = 1:length(timeu)
counts(ci,1) = sum(data(:,5)==timeu(ci)); % number of times each unique value is repeated.
end
max_occurence=max(counts)
[rtu,ctu]=size(timeu)
[rau,cau]=size(altu)
[rd,cd]=size(data)
for k=1:rtu
timeflip(1,k)=timeu(k,1)
end
for mi=1:max_occurence
    t(mi,:)=timeflip
end

    
for talt=1:rtu   
 a=NaN(max_occurence,talt)
    end

for talt=1:rtu
    ta=timeu(talt,1)
    r=find(data(:,5)==ta)
            for tra=1:length(r)
            a(tra,talt)=data(r(tra),2)
            end
    end


for tn=1:rtu   
 ne=NaN(max_occurence,tn)
    end

for tn=1:rtu
    tne=timeu(tn,1)
    
    rne=find(data(:,5)==tne)
            for trne=1:length(rne)
            ne(trne,tn)=data(rne(trne),3)
            end
    end
    




    
    
    
        
    times=t
    ranges=a
        
        
           
     


start_ut=start_hour+(start_min/60)
end_ut=end_hour+(end_min/60) 

datascint = data(data(:,5) <= end_ut & data(:,5) >=start_ut,:);




timeu2=unique(datascint(:,5))
altu2=unique(datascint(:,2))
for ci2 = 1:length(timeu2)
counts2(ci2,1) = sum(datascint(:,5)==timeu2(ci2)); % number of times each unique value is repeated.
end
max_occurence2=max(counts2)
[rtu2,ctu2]=size(timeu2)
[rau2,cau2]=size(altu2)
[rd2,cd2]=size(datascint)
for k2=1:rtu2
timeflip2(1,k2)=timeu2(k2,1)
end
lt=length(timeflip2)
for mi2=1:max_occurence2
    for lt2=1:lt
    t2(mi2,lt2)=timeflip2(1,lt2)
    end
end

    
for talt2=1:rtu2   
 a2=NaN(max_occurence2,talt2)
    end

for talt2=1:rtu2
    ta2=timeu2(talt2,1)
    r2=find(datascint(:,5)==ta2)
            for tra2=1:length(r2)
            a2(tra2,talt2)=datascint(r2(tra2),2)
            end
    end


for tn2=1:rtu2   
 ne2=NaN(max_occurence2,tn2)
    end

for tn2=1:rtu2
    tne2=timeu2(tn2,1)
    
    rne2=find(datascint(:,5)==tne2)
            for trne2=1:length(rne2)
            ne2(trne2,tn2)=datascint(rne2(trne2),3)
            end
    end



 times2=t2
    ranges2=a2

[ner,nec]=size(ne2)



ne2notnan=isfinite(ne2)

nesum2=sum(ne2notnan)
ner2=ner/2
rner=floor(ner2)
for necl=1:nec
    if nesum2(1,necl)>=rner
        gd(1,necl)=1
        gd(2,necl)=times2(1,necl)
    else
        gd(1,necl)=0
        gd(2,necl)=times2(1,necl)
    end
end



























pcolor(times2,ranges2,log10(ne2))

         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            pcolor(times, ranges, log10(ne));       
        
        
        
        
        
        
        
        
        
        
        
        
       
        
        
%                    
            caxis([10, 12]);
            string1='PFISR'
  string2=num2str(year)
  string3=num2str(month)
  string4=num2str(day)
  string5=num2str(start_hour)
  string6=num2str(start_min)
  string7=num2str(end_hour)
  string8=num2str(end_min)
  string9='PRN'
  string10=num2str(PRN)
  string11='DOY'
  string12=num2str(doyin)
  dash='_'
  
  plotname =strcat(string1,dash,string2,dash,string3,dash,string4,dash,string5,dash,string6,dash,string7,dash,string8,dash,string9,dash,string10,dash,string11,dash,string12)

            title('density');
            cb = colorbar;
            set(get(cb, 'YLabel'), 'String', ...
                '$\log_{10}{N_e} [m^{-3}]$', ...
                'interpreter', 'latex');
                
        end
        shading flat;
        set(gca, 'layer', 'top');
        grid off;
      
        xlabel('Time in UT');
        
        ylabel('Altitude [km]');
        ylim([50, 700]);

        
       
        ax = axis;
        

       plot(ax(1:2), [150 150], 'k', 'LineWidth', 2);
 

    start_ut=start_hour+(start_min/60)
end_ut=end_hour+(end_min/60)
        plot(repmat(start_ut, 2, 1), ax(3:4), 'k', 'LineWidth',2);
       plot(repmat(end_ut, 2, 1), ax(3:4), 'k', 'LineWidth', 2);
    
    
    
    

        
        string1='PFISR'
  string2=num2str(year)
  string3=num2str(month)
  string4=num2str(day)
  string5=num2str(start_hour)
  string6=num2str(start_min)
  string7=num2str(end_hour)
  string8=num2str(end_min)
  string9='PRN'
  string10=num2str(PRN)
  string11='DOY'
  string12=num2str(doyin)
  dash='_'
  
plotname =strcat(string1,dash,string2,dash,string3,dash,string4,dash,string5,dash,string6,dash,string7,dash,string8,dash,string9,dash,string10,dash,string11,dash,string12)

       plotpath_fig='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\plots_input_2\'
        plotpath_png='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\plots_input_2\'
        plot_name_fig=strcat(plotpath_fig,plotname)
         plot_name_png=strcat(plotpath_png,plotname)
        saveas(figure(1),plot_name_fig)
        saveas(figure(1),plot_name_png,'png')
        

    end

clear
end




