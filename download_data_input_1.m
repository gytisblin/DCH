function Madrigal= download_data_input_1(year, month, day, kindat,hour,hour2,hour3,min1,min2,min3,PRN,doyin)


switch kindat
    case 5950
        kindstr = '';
       
    case 5951
        kindstr = 'ac';
        
end


pubpfisrdir = 'E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_1\';
 
filename = download_madrigal_pfisr_input_1(year, month, day, kindat, pubpfisrdir,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
  
  				
			end	
