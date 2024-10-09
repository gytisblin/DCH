function textfile = download_madrigal_pfisr_input_1(year, month, day, kindat, downloaddir,hour,hour2,hour3,min1,min2,min3,PRN,doyin)

switch kindat
	case 5950
		kindstr = '';
	case 5951
		kindstr = 'ac';
end
hs=num2str(hour2)
he=num2str(hour3)
mins=num2str(min2)
mine=num2str(min3)
sat=num2str(PRN)
doyi=num2str(doyin)
textfile = [downloaddir,'\','Madrigal' kindstr datestr(datenum([year, month, day]), 'yymmdd'),'.txt'];

% http://isr.sri.com/madrigal
%http://cedar.openmadrigal.org/
%https://data.amisr.com/madrigal/ New Madrigal 3 repo at SRI:


 globalIsprint_original('http://data.amisr.com/madrigal/','AZM,MIN,DAYNO,GDALT,GDLAT,HOUR,NE,SEC,TI,DAY,GLON,ELM,VO,RANGE,YEAR,UT,MONTH,KP,DNE',textfile,'Gytis Blinstrubas','gblinstr@hawk.iit.edu','IIT',  datenum([year, month, day]),datenum([year, month, day+1]),61,'', kindat, '', '');        

end

