function pfisr_hypothesis_new(input,start_list,type)
%This functions runs the H of the DCH process to hypothesize the scattering
%layer from PFISR electron density measurments



%The inputs are to run different list such as the main list whih is used to
%compare to the results from the Datta-Barua et al. (2021) method

%If input=1 then it will run the main list of 4929 scintillation events it
%will use data downloading the same parameters as used in the Datta-Barua et al. (2021)

%If input=2 then the list used to run the hypothesis of DCH to be compared
%to the results from the all sky image processing

%The start list is which ever event you want to start from from main list
%or the auxilary list if you want to start from the beginning just put 1 in
%the start list

%Type=1 is if you want to run the DCH process and get back an excell
%spead sheet of results 

%Type=2 if you want to make plots of Electron Density

%Type=3 to Download the required data if input=1 it will download the data
%for that list if input=2 it will download the data for that list
     
if input==1
    % Most important load is this one this is the main list
    load phase_spreadsheet_from_pfisr.txt
    imported_data=phase_spreadsheet_from_pfisr
    
elseif input==2
    if type==1
%list of all the events asi has a detection for this list is used to
%dowload the data and run dch for the 6 data type data if you want to
%compare to the results from all sky comapre to the list of single_list
    load single_list_no_asi.txt
    imported_data=single_list_no_asi
    elseif type==2
    %this is the remaining events that have data for the 6 data typesand use this to make plots
    load new_layer_phase_error_1_3_ac_corrected_remove_dates_no_data_no_asi.txt
    imported_data=new_layer_phase_error_1_3_ac_corrected_remove_dates_no_data_no_asi
    elseif type==3
    %list of all the events asi has a detection for this list is used to
    %dowload the data and run dch for the 6 data type data
    load single_list_no_asi.txt
    imported_data=single_list_no_asi
end
    
end   
    
[NumRows, NumColums]=size(imported_data)
    





for i=start_list:NumRows
%This area of the code extracts the necessary data from the loaded spreadsheet 
data=imported_data(i,:)
year=data(1)
yearin=data(1)
doyin=data(2);

%The DOY is converted to a date so that the month and day of the
%scintillation event can be extracted
date_string=datetime(yearin, 1, doyin)
date_number=datenum(date_string)
date=datevec(date_number)

month=date(2)
day=date(3)
signal=data(3)
sat_num=data(4)
start_hour = data(5)
start_min = data(6)
end_hour=data(7)
end_min=data(8)
reciever=data(9)

starttime=start_hour+(start_min/60)
endtime=end_hour+(end_min/60)
PRN=sat_num;










%use this code just to download data and do nothing else
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




alt_cutoff = 195; 




[year,month,day,hour,min1,sec]=datevec(t1)
[year2,month2,day2,hour2,min2,sec2]=datevec(scintstart)
[year3,month3,day3,hour3,min3,sec3]=datevec(scintend)





if input==1
    if type==1
       [layer,layer2,layer3,layer4,layer5]= pfisr_hypothesis_input_1(year,month,day,starttime,endtime,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)
    elseif type==2
        plotPFISR_NeTe_automated_ac_input_1(year,month,day,starttime,endtime,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)
        plotPFISR_NeTe_automated_lp_input_1(year,month,day,starttime,endtime,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)

         figure(1)
         close('1')
        
    elseif type==3
        
        
      %Madrigal = 
      download_data_input_1(year,month,day,5950,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
      %Madrigalac = 
      download_data_input_1(year,month,day,5951,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
  
    end
    
    
elseif input==2
    mat_path = 'E:\GNSS_Research\edited_code\run_h\working_code\data_plots';
   if type==1
       
        %this is the updated version to run the new data with required data
       %only 6 data types
       [layer,layer2,layer3,layer4,layer5]= pfisr_hypothesis_input_2(year,month,day,starttime,endtime,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)     

       
   elseif type==2
        %this creates the plots of the the pfisr density
        plotPFISR_NeTe_automated_ac_input_2(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)
        plotPFISR_NeTe_automated_lp_input_2(year,month,day,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)
              figure(1)
  close('1')
   elseif type==3
        %use these scripts just to download the data for 6 data types
        download_data_input_2(year,month,day,5950,mat_path,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
        download_data_input_2(year,month,day,5951,mat_path,hour,hour2,hour3,min1,min2,min3,PRN,doyin);

        

    end 
end













 inew=i;

    layer_xls(inew,1)=year;
    layer_xls(inew,2)=doyin;
    layer_xls(inew,3)=signal;
    layer_xls(inew,4)=sat_num;
    layer_xls(inew,5)=start_hour;
    layer_xls(inew,6)=start_min;
    layer_xls(inew,7)=end_hour;
    layer_xls(inew,8)=end_min;
    layer_xls(inew,9)=reciever;
    
    layer_xls(inew,11)=layer;
     
     

%if any of these layers are ven it means that it did not meet the filtering
%criteria if all the numbers are odd for a row the event is usable
     layer_xls(inew,14)=layer2;
     layer_xls(inew,15)=layer3;
     layer_xls(inew,16)=layer4;
     layer_xls(inew,17)=layer5;







     
     

     
    clearvars -except type all_events i imported_data input NumColums NumRows start_list layer_xls inew
    end
    

 if input==1
 new_layer='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\results_input_1\layer_hypothesis'
 elseif input==2
      new_layer='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\results_input_2\layer_hypothesis'
 end
    
xlswrite(new_layer,layer_xls)
end

