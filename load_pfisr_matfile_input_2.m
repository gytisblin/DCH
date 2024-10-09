function Madrigal= load_pfisr_matfile_input_2(year, month, day, kindat,hour,hour2,hour3,min1,min2,min3,PRN,doyin)

switch kindat
    case 5950
        kindstr = '';
       
    case 5951
        kindstr = 'ac';
        
end





pubpfisrdir = 'E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_2\';
 
hs=num2str(hour2)
he=num2str(hour3)
mins=num2str(min2)
mine=num2str(min3)
sat=num2str(PRN)
doyi=num2str(doyin)
			if kindat==5950
                filename = ['Madrigal', kindstr, datestr(datenum([year, month, day]), 'yymmdd'),'_',hs,'_',mins,'_',he,'_',mine,'_','PRN','_',sat,'_','DOY','_',doyi,'.txt'];

               
                data_directory='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_2\';

                directory=[data_directory, filename];
                data = load([data_directory, filename]);

                Madrigal=data;
                cmdstr = ['Madrigal = Madrigal' kindstr ';'];
                eval(cmdstr)
        
           
elseif kindat==5951
     filename = ['Madrigal', kindstr, datestr(datenum([year, month, day]), 'yymmdd'),'_',hs,'_',mins,'_',he,'_',mine,'_','PRN','_',sat,'_','DOY','_',doyi,'.txt'];
       
    data_directory='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\data_input_2\';

        directory=[data_directory, filename];
        data = load([data_directory, filename]);
    
    Madrigalac=data;
        	cmdstr = ['Madrigal = Madrigal' kindstr ';'];
    	eval(cmdstr)
    
end

			end	
