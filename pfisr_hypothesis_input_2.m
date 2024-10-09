function [layer,layer2,layer3,layer4,layer5] = pfisr_hypothesis_input_2(year,month,day,starttime,endtime,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)

pfisrdir = 'E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_2';
yyyy_mm_dd = datestr(datenum([year, month, day]), 'yyyy_mm_dd');


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
codetype='ac'


    t0 = t1;
    tf = t2;
   
alt_cutoff = 195; 
mat_path = 'E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_2';
[year,month,day,hour,min1,sec]=datevec(t1)
Madrigal = load_pfisr_matfile_input_2(year,month,day,5950,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
Madrigalac = load_pfisr_matfile_input_2(year,month,day,5951,hour,hour2,hour3,min1,min2,min3,PRN,doyin);







timestamp=[];
if ~isempty(Madrigal)
timestamp=unique(Madrigal(:,5))
end
timestampac=[];
if ~isempty(Madrigalac)
timestampac=unique(Madrigalac(:,5))
end
Maxlp=[];
Maxac=[];
save_maxNe_lp=[];
save_maxNe_ac=[];
scintrows=find(timestamp>=starttime & timestamp<endtime)
scinttime=timestamp(scintrows)
scintrowsac=find(timestampac>=starttime & timestampac<endtime)
scinttimeac=timestampac(scintrowsac)
E=0;
F=0;
T=0;
%keyboard
% First check if there are no data.
if (isempty(Madrigal) && isempty(Madrigalac))
    disp('No PFISR data available'); % N- No Madrigal Data
   layer=5; %layer='N';
gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
layer2=0
layer3=0
layer4=0
layer5=0
    return;
end
if isempty(Madrigal)
    disp('No LP data available'); % NLP- No LP
   layer=6; %layer='NLP';
gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
layer2=0
layer3=0
layer4=0
layer5=0
    return;
end
if isempty(Madrigalac)
    disp('No AC data available'); % NAC- No AC
   layer=7; %layer='NAC';
gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
layer2=0
layer3=0
layer4=0
layer5=0
    return;
end
% Next check if there are data but not for the time of interest.
if isempty(scintrows) & isempty(scintrowsac)
    disp('No PFISR data available for the time interval'); % N- No Madrigal Data
   layer=5; %layer='N';
gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
layer2=0
layer3=0
layer4=0
layer5=0
    return;
end
if isempty(scintrows)
    disp('No LP data available for the time interval'); % NLP- No LP
   layer=6; %layer='NLP';
gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
layer2=0
layer3=0
layer4=0
layer5=0
    return;
end
if isempty(scintrowsac)
    disp('No AC data available for the time interval'); % NAC- No AC
   layer=7; %layer='NAC';
gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
layer2=0
layer3=0
layer4=0
layer5=0
    return;
end

[layer2,layer3,sizeranges_ac,total_data_points_ac,rangesnotnansum_total_ac,nesum_total_ac,rdata_scint_ac,gdac]=check_data_ac_6(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN,Madrigal,Madrigalac,alt_cutoff)
if isempty(gdac)
    gdac=0
end
if isempty(sizeranges_ac)
    sizeranges_ac=0 
end
if isempty(total_data_points_ac)
    total_data_points_ac=0
end
if isempty(rangesnotnansum_total_ac)
    rangesnotnansum_total_ac=0
end
if isempty(nesum_total_ac)
    nesum_total_ac=0
end
if isempty(rdata_scint_ac)
    rdata_scint_ac=0
end
if isempty(layer2)
    layer2=0
end
if isempty(layer3)
    layer3=0
end

[layer4,layer5,sizeranges_lp,total_data_points_lp,rangesnotnansum_total_lp,nesum_total_lp,rdata_scint_lp,gdlp]=check_data_lp_6(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN,Madrigal,Madrigalac,alt_cutoff)

if isempty(gdlp)
    gdlp=0
end
if isempty(sizeranges_lp)
    sizeranges_lp=0 
end
if isempty(total_data_points_lp)
    total_data_points_lp=0
end
if isempty(rangesnotnansum_total_lp)
    rangesnotnansum_total_lp=0
end
if isempty(nesum_total_lp)
    nesum_total_lp=0
end
if isempty(rdata_scint_lp)
    rdata_scint_lp=0
end
if isempty(layer4)
    layer4=0
end
if isempty(layer5)
    layer5=0
end









  
% LP
scint_time_length=length(scinttime)
for i=1:length(scinttime)
	rows=find(Madrigal(:,1)==-154.3 & ...
		Madrigal(:,4)==77.5 & ...
		Madrigal(:,5)==scinttime(i) & ...
		Madrigal(:,2)>=alt_cutoff);


madrigal_rows_data=Madrigal(rows,3);
madrigal_rows_error=Madrigal(rows,6);


ne=[]
for k=1:length(madrigal_rows_data)
    
    ne_data=madrigal_rows_data(k,1)
    ne_error=madrigal_rows_error(k,1)

     ne_data_50_percent=ne_data*(1/3)

         if ne_error >= ne_data_50_percent
        ne(k,1)=0
    else
        ne(k,1)=ne_data
    end
end




 if isempty(ne)==1
else
ne_add=sum(ne)
end
 
 if isempty(rows)==1
  Maxlp=[]
  elseif ne_add==0
  Maxlp=-999
 else
 Maxlp=max(ne);
 end

maxrow=find(Madrigal(rows,3)==Maxlp);
	altitude=Madrigal(rows(maxrow),2);
if isfinite(Maxlp)
    if Maxlp==-999
        if isempty(save_maxNe_lp)==1
        save_maxNe_lp=[-999,-999,-999,-999];
        else
        save_maxNe_lp=[save_maxNe_lp;[-999,-999,-999,-999]];
        end
    else
        if isempty(save_maxNe_lp)==1
        save_maxNe_lp=[Madrigal(rows(maxrow),5),Madrigal(rows(maxrow),2),Madrigal(rows(maxrow),3),Madrigal(rows(maxrow),6)];
        else
        save_maxNe_lp=[save_maxNe_lp;[Madrigal(rows(maxrow),5),Madrigal(rows(maxrow),2),Madrigal(rows(maxrow),3),Madrigal(rows(maxrow),6)]];
        end
        
        end
end


end

%AC

for i=1:length(scinttimeac)
rowsac=find(Madrigalac(:,1)==-154.3&Madrigalac(:,4)==77.5&Madrigalac(:,5)==scinttimeac(i)&Madrigalac(:,2)<alt_cutoff)

madrigal_rows_data_ac=Madrigalac(rowsac,3)
madrigal_rows_error_ac=Madrigalac(rowsac,6)



ne_ac=[]
for k=1:length(madrigal_rows_data_ac)
    
    ne_data_ac=madrigal_rows_data_ac(k,1);
    ne_e_ac=madrigal_rows_error_ac(k,1);
      ne_error_ac=ne_e_ac/3

    ne_data_50_percent_ac=ne_data_ac*(1/3);
   
    if ne_error_ac >= ne_data_50_percent_ac
        ne_ac(k,1)=0;
    else
        ne_ac(k,1)=ne_data_ac;
    end
end




if isempty(ne_ac)==1
else
ne_ac_add=sum(ne_ac)
end
 if isempty(rowsac)==1
    Maxac=[]
 elseif ne_ac_add==0
     Maxac=-999
 else
 Maxac=max(ne_ac);
 end


 

 
 
 





 
maxrowac=find(Madrigalac(rowsac,3)==Maxac);
altitudeac=Madrigalac(rowsac(maxrowac),2);

if isfinite(Maxac)
    if Maxac==-999
        if isempty(save_maxNe_ac)==1
        save_maxNe_ac=[-999,-999,-999,-999];
        else
        save_maxNe_ac=[save_maxNe_ac;[-999,-999,-999,-999]];
        end
    else
        if isempty(save_maxNe_ac)==1
        save_maxNe_ac=[Madrigalac(rowsac(maxrowac),5),Madrigalac(rowsac(maxrowac),2),Madrigalac(rowsac(maxrowac),3),Madrigalac(rowsac(maxrowac),6)];
        else
        save_maxNe_ac=[save_maxNe_ac;[Madrigalac(rowsac(maxrowac),5),Madrigalac(rowsac(maxrowac),2),Madrigalac(rowsac(maxrowac),3),Madrigalac(rowsac(maxrowac),6)]];
        end
        
        end
end
end


if isempty(save_maxNe_lp)==1
else
[NumRows_save_maxNe_lp, NumColums_save_maxNe_lp]=size(save_maxNe_lp)

for q=1:NumRows_save_maxNe_lp
    if save_maxNe_lp(q,1)==-999
        max_Ne_lp_good(q,1)=1
    else
    max_Ne_lp_good(q,1)=0
    end
end
 all_ne_lp=all(max_Ne_lp_good)  
end

if isempty(save_maxNe_ac)==1
else
[NumRows_save_maxNe_ac, NumColums_save_maxNe_ac]=size(save_maxNe_ac)

for q=1:NumRows_save_maxNe_ac
    if save_maxNe_ac(q,1)==-999
        max_Ne_ac_good(q,1)=1
    else
    max_Ne_ac_good(q,1)=0
    end
end
 all_ne_ac=all(max_Ne_ac_good)  
end
if (isempty(save_maxNe_lp)&&isempty(save_maxNe_ac)) %update
    layer=5;
elseif (isempty(save_maxNe_lp))%update
    layer=6;
elseif (isempty(save_maxNe_ac)) %update
    layer=7;


% new part of code
elseif all_ne_lp&&all_ne_ac==1
    layer=8;
elseif all_ne_lp==1
    layer=9;
elseif all_ne_ac==1
    layer=10;
    
else


if (size(save_maxNe_ac,1)<=size(save_maxNe_lp,1))
    
    
    for i=1:size(save_maxNe_ac,1) 
        row_max=abs(save_maxNe_lp(:,1) - save_maxNe_ac(i,1))
        row_min=min(abs(save_maxNe_lp(:,1) - save_maxNe_ac(i,1)))
       nearestrow = find(abs(save_maxNe_lp(:,1) - save_maxNe_ac(i,1)) ...
            == min(abs(save_maxNe_lp(:,1) - save_maxNe_ac(i,1))));
        
       ac_greater=save_maxNe_ac(i,3)-save_maxNe_ac(i,4)
       lp_less=save_maxNe_lp(nearestrow,3)+save_maxNe_lp(nearestrow,4)
        
                if (save_maxNe_ac(i,3)>save_maxNe_lp(nearestrow,3)&save_maxNe_ac(i,2)<150)
                    E=E+1
                    if ac_greater>lp_less
                        E=E
                    else
                        E=E-1
                    end
                elseif (save_maxNe_ac(i,3)<save_maxNe_lp(nearestrow,3))
                    F=F+1
                    if (save_maxNe_ac(i,3)+save_maxNe_ac(i,4))<(save_maxNe_lp(nearestrow,3)-save_maxNe_lp(nearestrow,4))
                        F=F
                    else
                        F=F-1
                    end
                elseif(save_maxNe_ac(i,3)>save_maxNe_lp(nearestrow,3)&save_maxNe_ac(i,2)>=150&save_maxNe_ac(i,2)<195)
                    T=T+1
                    if (save_maxNe_ac(i,3)-save_maxNe_ac(i,4))>(save_maxNe_lp(nearestrow,3)+save_maxNe_lp(nearestrow,4))
%                         error_ac_with_error=save_maxNe_ac(nearestrow,3)-save_maxNe_ac(nearestrow,4)
%                         error_lp_with_error=save_maxNe_lp(i,3)+save_maxNe_lp(i,4)
                        T=T
                    else
                        T=T-1
                    end
                end
            
    end
           
                    
    
else
    for i=1:size(save_maxNe_lp,1)
         nearestrow = find(abs(save_maxNe_ac(:,1) - save_maxNe_lp(i,1)) ...
            == min(abs(save_maxNe_ac(:,1) - save_maxNe_lp(i,1))));
        
                if (save_maxNe_ac(nearestrow,3)>save_maxNe_lp(i,3) & save_maxNe_ac(nearestrow,2)<150)
                    E=E+1;
                    if (save_maxNe_ac(nearestrow,3)-save_maxNe_ac(nearestrow,4))>(save_maxNe_lp(i,3)+save_maxNe_lp(i,4))
                        E=E
                    else
                        E=E-1
                    end
                elseif (save_maxNe_ac(nearestrow,3)<save_maxNe_lp(i,3))
                    F=F+1;
                    if (save_maxNe_ac(nearestrow,3)+save_maxNe_ac(nearestrow,4))<(save_maxNe_lp(i,3)-save_maxNe_lp(i,4))
                        F=F
                    else
                        F=F-1
                    end
                elseif(save_maxNe_ac(nearestrow,3)>save_maxNe_lp(i,3) & save_maxNe_ac(nearestrow,2)>=150 & save_maxNe_ac(nearestrow,2)<195)
                    T=T+1;
                    if (save_maxNe_ac(nearestrow,3)-save_maxNe_ac(nearestrow,4))>(save_maxNe_lp(i,3)+save_maxNe_lp(i,4))
                        T=T
                    else
                        T=T-1
                    end
                end
            
   end
            
    
end

%Detecting region for a scintillation event on a day
if(E==0&&F==0&&T==0)
    disp('No PFISR data available EFT'); % N- No PFISR
   layer=11; %layer='N';
    
elseif(E>F&&E>T)
 disp('E region scintillation');  % E- E region
 layer=1; %layer='E';
 
elseif(F>E&&F>T)
    disp('F region scintillation'); % F- F region
    layer=2; %layer='F';
    
elseif(T>E&&T>F)
    disp('Transition region scintillation'); % T- Transition region
    layer=3; %layer='T';
    
else
    disp('region cannot be determined'); % I- Inconclusive
    layer=4; %layer='I';
end
end








end