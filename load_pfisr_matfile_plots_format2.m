function Madrigal= load_pfisr_matfile_plots_format2(year, month, day, kindat, pfisrdir,hour,hour2,hour3,min1,min2,min3,PRN,doyin)

% function Madrigal= load_pfisr_matfile(year, month, day, kindat, mypfisrdir)
% Created by V. Sreenivash 2018
% Commented by S. Datta-Barua
% 20 Feb 2019
% 4 Apr 2019 Once V's paper is done, change the file naming convention to
% be yy_mm_dd.mat instead of dd_mm_yy.mat.  Also use datestr to create, so
% you don't have to zero-pad the strings.
% Those changes have been done.
%
% This function returns a variable containing the PFISR data for the
% user-specified UT date.  If the .mat file from which it is loaded doesn't
% exist, then the function calls download_madrigal_pfisr.m which calls
% globalIsprint.m to download the data from the website.
%
% 17 Nov 2020 I accessed Vaishnavi's Madrigal downloads to reproduce her result.
% 8 Dec 2020 Commented to now access Pau's downloads to reproduce his result.
% 7 Jun 2021 Re-doing PFISR download process to get from Madrigal but not throw
% exception if there were no experiments for a given date.

% data=[];
% Madrigal = [];

switch kindat
    case 5950
        kindstr = '';
       
    case 5951
        kindstr = 'ac';
        
end





pubpfisrdir = 'E:\GNSS_Research\edited_code\run_h\working_code\data_plots';
 
          	%filename = download_madrigal_pfisr_format(year, month, day, kindat, pubpfisrdir);
hs=num2str(hour2)
he=num2str(hour3)
mins=num2str(min2)
mine=num2str(min3)
sat=num2str(PRN)
doyi=num2str(doyin)
			if kindat==5950
                filename = ['Madrigal', kindstr, datestr(datenum([year, month, day]), 'yymmdd'),'_',hs,'_',mins,'_',he,'_',mine,'_','PRN','_',sat,'_','DOY','_',doyi,'.txt'];

                %filename = ['Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'), '.txt'];
            
                data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data_plots\';

                directory=[data_directory, filename];
                data = load([data_directory, filename]);

                Madrigal=data;
                cmdstr = ['Madrigal = Madrigal' kindstr ';'];
                eval(cmdstr)
        
           
elseif kindat==5951
    %filename = ['Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'), '.txt'];
     filename = ['Madrigal', kindstr, datestr(datenum([year, month, day]), 'yymmdd'),'_',hs,'_',mins,'_',he,'_',mine,'_','PRN','_',sat,'_','DOY','_',doyi,'.txt'];
       
    data_directory='E:\GNSS_Research\edited_code\run_h\working_code\data_plots\';

        directory=[data_directory, filename];
        data = load([data_directory, filename]);
    
    Madrigalac=data;
        	cmdstr = ['Madrigal = Madrigal' kindstr ';'];
    	eval(cmdstr)
    
end
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