function records = isprintWget(cgiUrl, file, parms, user_fullname, user_email, user_affiliation, filters, missing, assumed, knownbad)
%  isprintWget - Create an isprint-like 3D array of doubles via a command
%  similar to the isprint command-line application, but access data via
%  wget
%
%  This method differs from isprintWeb in that wget is used to download the
%  data.  Throws error if wget not found
%  
%  The calling syntax for this method is:
%  
%  		[records] = isprintUnguarded(cgiurl, file, parms, user_fullname, user_email, user_affiliation, [filters, [missing, [assumed, [knownbad] ] ] ])
%  
%   where 
%
%     cgiurl (string) to Madrigal site cgi directory that has that
%      filename.
%        (Example: 'http://madrigal.haystack.mit.edu/cgi-bin/madrigal/') 
%         Note that method getMadrigalCgiUrl converts homepage url into cgiurl.
%  
%     file is path to file
%         (example = '/home/brideout/data/mlh980120g.001')
%  
%     parms is the desired parameters in the form of a comma-delimited
%         string of Madrigal mnemonics (example = 'gdlat,ti,dti')
%
%     user_fullname - is user name (string)
%
%     user_email - is user email address (string)
%
%     user_affiliation - is user affiliation (string) 
%  
%     filters is the optional filters requested in exactly the form given in isprint
%         command line (example = 'time1=15:00:00 date1=01/20/1998 
%                       time2=15:30:00 date2=01/20/1998 filter=ti,500,1000')
%         See:  http://madrigal.haystack.mit.edu/madrigal/ug_commandLine.html for details
%
%     missing is an optional double to represent missing values.  Defaults to NaN
%
%     assumed is an optional double to represent assumed values.  Defaults to NaN
%
%     knownbad is an optional double to represent knownbad values.  Defaults to NaN
%
%     The returned records is a three dimensional array of double with the dimensions:
%
%         [Number of rows, number of parameters requested, number of records]
%
%     If error or no data returned, will return error explanation string instead.
%
%   Example: data = isprintUnguarded('http://madrigal.haystack.mit.edu/cgi-bin/madrigal/', ...
%                                '/opt/madrigal/experiments/1998/mlh/07jan98/mil980107g.001', ...
%                                'gdlat,ti,dti', ...
%                                'Bill Rideout', 'wrideout@haystack.mit.edu', 'MIT');
%
%   Unlike isprintWeb, no effort is made to protect the user from
%   requesting too more data than the Matlab method urlread can handle
%
%    $Id: isprintWget.m 4339 2014-05-05 05:34:08Z brideout $

% deal with arguments

% defaults
missingValue = NaN;
assumedValue = NaN;
knownbadValue = NaN;


if (nargin < 6)
    error('Usage: [records] = isprintWeb(url, file, parms, user_fullname, user_email, user_affiliation, [filters, [missing, [assumed, [knownbad] ] ] ])');
end
if (nargin < 7)
    filters = '';
end
if (nargin < 8)
    missing = missingValue;
end
if (nargin < 9)
    assumed = assumedValue;
end
if (nargin < 10)
    knownbad = knownbadValue;
end

% be sure cgiUrl ends with /
if ~strcmp(cgiUrl(end), '/')
    cgiUrl = strcat(cgiUrl, '/');
end

% build the complete cgi string, replacing characters as required by cgi standard
cgiUrl = strcat(cgiUrl, 'isprintService.py?file=', strrep(file,'/','%2F'));
% parm + to %2B
parms = strrep(parms,'+','%2B');
cgiUrl = strcat(cgiUrl, '&header=t&parms=', strrep(parms,',','+'));
cgiUrl = strcat(cgiUrl, '&user_fullname=', strrep(user_fullname,' ','+'));
cgiUrl = strcat(cgiUrl, '&user_email=', user_email);
cgiUrl = strcat(cgiUrl, '&user_affiliation=', strrep(user_affiliation,' ','+'));
if (length(filters) > 1)
    % the filter string requires the following conversions...
    % = to %3D
    filters = strrep(filters,'=','%3D');
    % , to %2C
    filters = strrep(filters,',','%2C');
    % / to %2F
    filters = strrep(filters,'/','%2F');
    % + to %2B
    filters = strrep(filters,'+','%2B');
    % space to +
    filters = strrep(filters,' ','+');
    cgiUrl = strcat(cgiUrl, '&filters=', filters);
end

% save to a random text file
outputFile = sprintf('/tmp/junk%i.txt', randi(1000000000,1));
% temp only - for mac
wget_command = horzcat('wget -q -O', ' ', outputFile, ' "', cgiUrl, '"');

% try to use wget
[result, cmdout] = system(wget_command);
if (result ~= 0)
    exception = MException('Madmatlab:WgetFailed', ...
       'Unable to run wget - please make sure its installed');
    throw(exception);
end
cat_command = horzcat('cat ', outputFile);
[result, text] = system(cat_command);
% remove temp file
delete(outputFile);

% look for errors - if html returned, error occurred
htmlList = findstr(text, '</html>');
if (~isempty(htmlList))
    err.message = strcat('Unable to run isprintWeb - html error is ', text);
    err.identifier = 'madmatlab:scriptError';
    rethrow(err);
end

% look for errors - if "****" returned, error occurred
errList = findstr(text, '****');
if (~isempty(errList))
    err.message = strcat('Unable to run isprintWeb - error is ', text);
    err.identifier = 'madmatlab:scriptError';
    rethrow(err);
end


% now parse the isprint output into a 3D array of doubles

% the first parse is simply to get dimensions

% get numParms
if length(parms) < 2
    err.message = strcat('parms cannot be empty string');
    err.identifier = 'madmatlab:badArguments';
    rethrow(err);
end

commaMarks = regexp(parms, ',');
numParms = length(commaMarks) + 1;

% get all new lines
lineMarks = regexp(text, '\n');
numRecords = 0;
max2D = 0;
presentStart = 1;
atStart = 1;
lastLine = 0;
% loop through each line
for line = 1:length(lineMarks)
    thisLine = text(presentStart:lineMarks(line));
    presentStart = lineMarks(line) + 1;
    colonList = findstr(thisLine, ':');
    if (~isempty(colonList))
        % header found
        numRecords = numRecords + 1;
        % see if its the biggest
        if (atStart ~= 1 & (line - lastLine) - 3 > max2D)
            max2D = (line - lastLine) - 3;
        end
        atStart = 0;
        lastLine = line;
    end
    % handle last line
    if line == length(lineMarks)
       if ((line - lastLine) - 2 > max2D)
            max2D = (line - lastLine) - 2;
       end
    end
end

% check that some data was returned
if numRecords == 0 | max2D == 0 | numParms == 0
    records = text;
    return;
end

% create the three dimensional array
records = zeros(max2D, numParms, numRecords);
records(:,:,:) = missing;

% the next parse is to populate records
% get all new lines
lineMarks = regexp(text, '\n');
presentStart = 1;
thisRecord = 1;
this2D = 0;
thisParm = 0;
isNewRecord = 1;
isNew2D = 1;
for line=1:length(lineMarks)
    % get next line
    newLine = text(presentStart:lineMarks(line));
    presentStart = lineMarks(line) + 1;
    % check if its a new record
    if line > 2 & length(newLine) < 2
       this2D = 0;
       thisRecord = thisRecord + 1;
       continue;
    elseif length(newLine) < 2
       % ignore first empty line
       continue;
    end
   
    
    % now loop through each token
    tokenList = regexp(newLine, ' ');
    presentTokenStart = 1;
    foundFirstToken = 0;
    thisParm = 1;
    for i = 1:length(tokenList)+1
        if i == length(tokenList)+1
            token = newLine(presentTokenStart:end-1);
        else    
            token = newLine(presentTokenStart:tokenList(i)-1);
            presentTokenStart = tokenList(i) + 1;
        end
        if (isempty(token))
            continue;
        end
        % check if its a double
        newDouble = str2double(token);
        % check if its missing
        if strcmp(token, 'missing')
            newDouble = missing;
        end
        % check if its assumed
        if strcmp(token, 'assumed')
            newDouble = assumed;
        end
        % check if its knownbad
        if strcmp(token, 'knownbad')
           newDouble = knownbad;
        end
        % check if its valid
        if isnan(newDouble) & strcmp(token, 'missing')==0 & strcmp(token, 'knownbad')==0 & strcmp(token, 'assumed')==0
            break;
        end
        % increment this2D if first
        if foundFirstToken == 0
            this2D = this2D + 1;
            foundFirstToken = 1;
        end
        records(this2D, thisParm, thisRecord) = newDouble;
        thisParm = thisParm + 1;
    end
   
end

end