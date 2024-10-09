function [layer2,layer3,sizeranges_ac,total_data_points_ac,rangesnotnansum_total_ac,nesum_total_ac,rdata_scint_ac,gdac]=check_data_ac_6(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN,Madrigal,Madrigalac,alt_cutoff)
layer2=0
layer3=0

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


[year,month,day,hour,minute,sec]=datevec(t1)




data= Madrigalac;
tfutc=end_hour_t2+(end_min/60)
toutc=start_hour_t1+(start_min/60)





if ~isempty(data)

data = data(data(:,5) >=toutc & data(:,5) <= tfutc,:);


data = data(data(:,2) <= alt_cutoff, :);
data = data(data(:,4) == 77.5, :);
data = data(data(:,1) == -154.3, :);


        
if ~isempty(data)
   
start_ut=start_hour+(start_min/60);
end_ut=end_hour+(end_min/60) ;
datascint = data(data(:,5) >=start_ut & data(:,5) <= end_ut,:);





if ~isempty(datascint)

timeu2=unique(datascint(:,5));
altu2=unique(datascint(:,2));


for ci2 = 1:length(timeu2)
counts2(ci2,1) = sum(datascint(:,5)==timeu2(ci2)); 
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

times_ac=tc2
ranges_ac=a2
[ner,nec]=size(ne2)
total_data_points_ac=ner*nec
ne_ac=ne2

[rangesr,rangesc]=size(ranges_ac)

sizeranges_ac=rangesr*rangesc



rangesnotnan=isfinite(ranges_ac)
rangesnotnansum=sum(rangesnotnan)
rangesnotnansum_total_ac=sum(rangesnotnansum)

ne2notnan=isfinite(ne_ac)
nesum2_ac=sum(ne2notnan)
nesum_total_ac=sum(nesum2_ac)




[rdata_scint,cdata_scint]=size(datascint)
rdata_scint_ac=rdata_scint


total_data_points2=sizeranges_ac*(0.8)



if nesum_total_ac>=total_data_points2
    layer2=15
else
    layer2=16;
    
end


% 
% 
ner2=rangesr/2


for necl=1:nec
    if nesum2_ac(1,necl)>=ner2
        gdac(1,necl)=1
        gdac(2,necl)=times_ac(1,necl)
    else
        gdac(1,necl)=0
        gdac(2,necl)=times_ac(1,necl)
    end
end

        

 [gdacr,gdacc]=size(gdac)
 

 gdac_sum=sum(gdac(1,:))
 if gdac_sum==gdacc
     layer3=17
 else
     layer3=18
 end
 



clearvars -except sizeranges_ac total_data_points_ac rangesnotnansum_total_ac nesum_total_ac rdata_scint_ac gdac layer2 layer3

else
    gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    layer2=0
layer3=0

end
else
    gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    layer2=0
layer3=0
end
else
    gdac=0 
    sizeranges_ac=0  
    total_data_points_ac=0  
    rangesnotnansum_total_ac=0  
    nesum_total_ac=0  
    rdata_scint_ac=0 
    layer2=0
layer3=0
end






end

