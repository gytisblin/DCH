function [layer4,layer5,sizeranges_lp,total_data_points_lp,rangesnotnansum_total_lp,nesum_total_lp,rdata_scint_lp,gdlp]=check_data_lp_19(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN,Madrigal,Madrigalac)
layer4=0
layer5=0

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
beam=64157
    t0 = t1;
    tf = t2;
alt_cutoff = 195; 

[year,month,day,hour,minute,sec]=datevec(t1)




data= Madrigal;
tfutc=end_hour_t2+(end_min/60)
toutc=start_hour_t1+(start_min/60)





if ~isempty(data)

data = data(data(:,16) >=toutc & data(:,16) <= tfutc,:);

alt_cutoff=195
data = data(data(:,4) > alt_cutoff, :);
data = data(data(:,12) == 77.5, :);
data = data(data(:,1) == -154.3, :);


        
if ~isempty(data)
   
start_ut=start_hour+(start_min/60);
end_ut=end_hour+(end_min/60) ;
datascint = data(data(:,16) >=start_ut & data(:,16) <= end_ut,:);





if ~isempty(datascint)

timeu2=unique(datascint(:,16));
altu2=unique(datascint(:,4));


for ci2 = 1:length(timeu2)
counts2(ci2,1) = sum(datascint(:,16)==timeu2(ci2)); % number of times each unique value is repeated.
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
    tc2(mi2,lt2)=timeflip2(1,lt2)
    end
end

    
for talt2=1:rtu2   
 a2=NaN(max_occurence2,talt2)
    end

for talt2=1:rtu2
    ta2=timeu2(talt2,1)
    r2=find(datascint(:,16)==ta2)
            for tra2=1:length(r2)
            a2(tra2,talt2)=datascint(r2(tra2),4)
            end
    end


for tn2=1:rtu2   
 ne2=NaN(max_occurence2,tn2)
    end

for tn2=1:rtu2
    tne2=timeu2(tn2,1)
    
    rne2=find(datascint(:,16)==tne2)
            for trne2=1:length(rne2)
            ne2(trne2,tn2)=datascint(rne2(trne2),7)
            end
end

times_lp=tc2
ranges_lp=a2
[ner,nec]=size(ne2)
total_data_points_lp=ner*nec
ne_lp=ne2

[rangesr,rangesc]=size(ranges_lp)

sizeranges_lp=rangesr*rangesc



rangesnotnan=isfinite(ranges_lp)
rangesnotnansum=sum(rangesnotnan)
rangesnotnansum_total_lp=sum(rangesnotnansum)

ne2notnan=isfinite(ne_lp)
nesum2_lp=sum(ne2notnan)
nesum_total_lp=sum(nesum2_lp)





[rdata_scint,cdata_scint]=size(datascint)
rdata_scint_lp=rdata_scint


total_data_points2=sizeranges_lp*(0.8)



if nesum_total_lp>=total_data_points2
    layer4=19
else
    layer4=20;
    
end


% 
% 
ner2=rangesr/2


for necl=1:nec
    if nesum2_lp(1,necl)>=ner2
        gdlp(1,necl)=1
        gdlp(2,necl)=times_lp(1,necl)
    else
        gdlp(1,necl)=0
        gdlp(2,necl)=times_lp(1,necl)
    end
end

        
[gdlpr,gdlpc]=size(gdlp)
 

 gdlp_sum=sum(gdlp(1,:))
 if gdlp_sum==gdlpc
     layer5=21
 else
     layer5=22
 end

clearvars -except gdlp sizeranges_lp total_data_points_lp rangesnotnansum_total_lp nesum_total_lp rdata_scint_lp layer4 layer5
else
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0 
    layer4=0
layer5=0

end
else
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0
    layer4=0
layer5=0
end
else
    gdlp=0 
    sizeranges_lp=0  
    total_data_points_lp=0  
    rangesnotnansum_total_lp=0  
    nesum_total_lp=0  
    rdata_scint_lp=0 
    layer4=0
layer5=0
end






end

