function download_data_input_2(year, month, day, kindat, pfisrdir,hour,hour2,hour3,min1,min2,min3,PRN,doyin)



switch kindat
    case 5950
        kindstr = '';
       
    case 5951
        kindstr = 'ac';
        
end





pubpfisrdir = 'E:\GNSS_Research\edited_code\run_h\working_code\data_plots';
 
%dowload data with the 21 data types
          	%filename = download_madrigal_pfisr_format(year, month, day, kindat, pubpfisrdir,hour,hour2,hour3,min1,min2,min3,PRN,doyin);

            %dowload just the required data types
            filename = download_madrigal_pfisr_input_2(year, month, day, kindat, pubpfisrdir,hour,hour2,hour3,min1,min2,min3,PRN,doyin);

            
            
            hs=num2str(hour2)
he=num2str(hour3)
mins=num2str(min2)
mine=num2str(min3)
sat=num2str(PRN)
doyi=num2str(doyin)
% 			if kindat==5950
%                 filename = ['Madrigal', kindstr, datestr(datenum([year, month, day]), 'yymmdd'),'_',hs,'_',mins,'_',he,'_',mine,'_','PRN','_',sat,'_','DOY','_',doyi,'.txt'];
% 
%                 %filename = ['Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'), '.txt'];
%             
%                 data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data_plots\';
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
%     filename = ['Madrigal', kindstr, datestr(datenum([year, month, day]), 'yymmdd'),'_',hs,'_',mins,'_',he,'_',mine,'_','PRN','_',sat,'_','DOY','_',doyi,'.txt'];
% 
%     %filename = ['Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'), '.txt'];
%             
%     data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data_plots\';
% 
%         directory=[data_directory, filename];
%         data = load([data_directory, filename]);
%     
%     Madrigalac=data;
%         	cmdstr = ['Madrigal = Madrigal' kindstr ';'];
%     	eval(cmdstr)
%     
% end






% % 				if ~isempty(data)
% %         			rows=find(data(:,12)==day&data(:,17)==year&data(:,19)==month);
% %             			eval(['Madrigal' kindstr '=data(rows,:);'])
% %     				cmdstr = ['Madrigal = Madrigal' kindstr ';'];
% % 				eval(cmdstr);
% %         			outfilename=[mypfisrdir, 'Madrigal', kindstr, '_', ...
% % 				datestr(datenum([year, month, day]), 'yyyy_mm_dd'), '.mat'];
% % %     				save(outfilename, ['Madrigal', kindstr]);
% %     				%save(filesave, ['Madrigal', kindstr]);
  				
			end	
% 		end % try loading .txt from elsewhere, catch download for th first time.
% 	end % try loading my .mat file.
%end % try loading student .mat file.