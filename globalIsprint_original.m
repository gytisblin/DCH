function [] = globalIsprint(url,parms,output,user_fullname,user_email,user_affiliation,startTime,endTime,inst,filters,kindats,expName,fileDesc)
% globalIsprint is a script to search through the entire Madrigal database
% for appropriate data to print in ascii to a file
%
%    Inputs:
%
%        url - url to homepage of site to be searched (Example: 
%              'http://madrigal.haystack.mit.edu/madrigal/'
%
%        parms - a comma delimited string listing the desired Madrigal 
%            parameters in mnemonic form.  
%            (Example: 'year,month,day,hour,min,sec,gdalt,dte,te').  
%            Ascii space-separated data will be returned in the same  
%            order as given in this string. See 
%            http://madrigal.haystack.mit.edu/cgi-bin/madrigal/getMetadata
%            "Parameter code table" for all possible parameters.
%
%        output - the local file name to store the resulting ascii data.
%                 (Example: '/tmp/isprint.txt')
%
%        user_fullname - the full user name (Example: 'Bill Rideout')
%
%        user email -  Example: 'brideout@haystack.mit.edu'
%
%        user_affiliation - Example: 'MIT'
%
%        startTime - a Matlab time to begin search at. Example:
%                    datenum('20-Jan-1998 00:00:00') Time in UT
%
%        endTime - a Matlab time to end search at. Example:
%                  datenum('21-Jan-1998 23:59:59') Time in UT
%
%        inst - instrument code (integer).  See 
%            http://madrigal.haystack.mit.edu/cgi-bin/madrigal/getMetadata
%            "Instrument Table" for this list. Examples: 30 for Millstone
%            Hill Incoherent Scatter Radar, 80 for Sondrestrom Incoherent 
%            Scatter Radar
%
%    Optional inputs
%
%        filters - is the optional filters requested in exactly the form given in isprint
%         command line (example = 'filter=gdalt,,500 filter=ti,500,1000')
%         See:  http://madrigal.haystack.mit.edu/madrigal/ug_commandLine.html for details
%
%        kindats - is an optional array of kindat (kinds of data) codes to accept.
%           The default is an empty array, which will accept all kindats.
%  
%        expName - a case insensitive regular expression that matches the experiment
%           name.  Default is zero-length string, which matches all experiment names.
%
%        fileDesc - a case insensitive regular expression that matches the file description.
%           Default is zero-length string, which matches all file descriptions.
%
%    Returns: Nothing.
%
%    Affects: Writes results to output file
%
%        
%
%  Example: globalIsprint('http://madrigal.haystack.mit.edu/madrigal/', ...
%                         'year,month,day,hour,min,sec,gdalt,dte,te', ...
%                         '/tmp/isprint.txt', ...
%                         'Bill Rideout', ...
%                         'brideout@haystack.mit.edu', ...
%                         'MIT', ...
%                         datenum('20-Jan-1998 00:00:00'), ...
%                         datenum('21-Jan-1998 23:59:59'), ...
%                         30);
%
%  $Id: globalIsprint.m 5086 2015-06-08 15:59:01Z brideout $
%
% S Datta-Barua, Illinois Institute of Technology
% Modified to not throw exception if date is missing data. 7 Jun 2021

if (nargin < 10)
    filters = '';
end

if (nargin < 11)
    kindats = [];
end

if (nargin < 12)
    expName = '';
end

if (nargin < 13)
    fileDesc = [];
end

% handle the case when experiments extend outside time range
stVec = datevec(startTime);
etVec = datevec(endTime);
timeFiltStr1 = sprintf(' date1=%02i/%02i/%04i time1=%02i:%02i:%02i ', ...
    stVec(2), stVec(3), stVec(1), stVec(4), stVec(5), round(stVec(6)));
timeFiltStr2 = sprintf(' date2=%02i/%02i/%04i time2=%02i:%02i:%02i ', ...
    etVec(2), etVec(3), etVec(1), etVec(4), etVec(5), round(etVec(6)));

filters = [filters, timeFiltStr1, timeFiltStr2];
    
cgiurl = getMadrigalCgiUrl(url);
expArray = getExperimentsWeb(cgiurl, inst, startTime, endTime, 1);
% Modified Bill Rideout's code to exit instead of throwing exception.
% S. Datta-Barua 7 June 2021
if (isempty(expArray))
%    exception = MException('Madmatlab:NoExperimentsFound', ...
%       'No experiments found for these arguments');
%    throw(exception);
    disp('Madmatlab:NoExperimentsFound.  No experiments found for these arguments');
	return;
end

% fid = fopen(output, 'w');
fid = fopen(output, 'w');

% loop through each experiment
for i = 1:length(expArray)

    % expName filter, if any
    if (length(expName) > 0)
        result = regexpi(expArray(i).name, expName);
        if (length(result) == 0)
            continue;
        end
    end

     % for each experiment, find all default files
     expFileArray = getExperimentFilesWeb(cgiurl, expArray(i).id);
     for j = 1:length(expFileArray)
         if (expFileArray(j).category ~= 1)
             continue
	 end
	 
	 % kindat filter
	 if (length(kindats) > 0)
             okay = 0;
             for k = 1:length(kindats)
                 if (expFileArray(j).kindat == kindats(k))
                     okay = 1;
                     break;
                 end
             end
             if (okay == 0)
                 continue;
             end
	 end
	 
	 % fileDesc filter, if any
         if (length(fileDesc) > 0)
             result = regexpi(expFileArray(j).status, fileDesc);
             if (length(result) == 0)
                 continue;
             end
         end

	 fprintf(1, 'Working on file %s\n', expFileArray(j).name);
         
         % run isprintWeb
         data = isprintWeb(cgiurl, expFileArray(j).name, parms, ...
                           user_fullname, user_email, user_affiliation, ...
                           filters);
                           
         dataLens = size(data);
	     
	 if (length(dataLens) < 3)
	     continue;
	 end

         for i3 = 1:dataLens(3)
             for i1 = 1:dataLens(1)
                 dataOkay = 1;
                 for i2 = 1:dataLens(2)
                     % skip time NaN
		     if ((i2 == 1) && (isnan(data(i1,i2,i3))))
		         dataOkay = 0;
		         break;
		     end
		     if (dataOkay == 1)
                         fprintf(fid, '%g ', data(i1,i2,i3));
                     end
                 end
                 % end of line
                 if (dataOkay == 1)
                     fprintf(fid, '\n ');
                 end
             end
         end % writing this file

     end % experiment file loop
     
end % experiment loop

fclose(fid);
end
