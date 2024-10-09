function Madrigal= load_pfisr_matfile(year, month, day, kindat, pfisrdir)


switch kindat
    case 5950
        kindstr = '';
       
    case 5951
        kindstr = 'ac';
        
end

	





 pubpfisrdir = 'E:\GNSS_Research\edited_code\run_h\working_code\data';
if kindat==5950
                
                filename = ['Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'), '.txt'];
            
                data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data\';

                directory=[data_directory, filename];
                data = load([data_directory, filename]);

                Madrigal=data;
                cmdstr = ['Madrigal = Madrigal' kindstr ';'];
                eval(cmdstr)
        
           
elseif kindat==5951
    filename = ['Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'), '.txt'];
            
    data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data\';

        directory=[data_directory, filename];
        data = load([data_directory, filename]);
    
    Madrigalac=data;
        	cmdstr = ['Madrigal = Madrigal' kindstr ';'];
    	eval(cmdstr)
    
end

  				
			end	





































































% switch kindat
%     case 5950
%         kindstr = '';
%        
%     case 5951
%         kindstr = 'ac';
%         
% end
% 
% 
% 
% 			if kindat==5950
%                 if year==2014 && month==1 && day==4
%                     filename='pfa140103.004'
%                 else
%                     filename = ['pfa' kindstr datestr(datenum([year, month, day]), 'yymmdd'),'.004', '.txt'];
%             
%                 end
%                 
%                 data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data\';
% 
%                 directory=[data_directory, filename];
%                 data = load([data_directory, filename]);
% 
%                 Madrigal=data;
%                 cmdstr = ['Madrigal = Madrigal' kindstr ';'];
%                 eval(cmdstr)
%         
%            
% elseif kindat==5951
%     filename = ['pfa' kindstr datestr(datenum([year, month, day]), 'yymmdd'),'.002', '.txt'];
%                     
%     data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data\';
% 
%         directory=[data_directory, filename];
%         data = load([data_directory, filename]);
%     
%     Madrigalac=data;
%         	cmdstr = ['Madrigal = Madrigal' kindstr ';'];
%     	eval(cmdstr)
%     
% end
% 
%   				
% 			end	
