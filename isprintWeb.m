function records = isprintWeb(cgiUrl, file, parms, user_fullname, user_email, user_affiliation, filters, missing, assumed, knownbad)
%  isprintWeb  	Create an isprint-like 3D array of doubles via a command similar to the isprint command-line application, but access data via the web
%  
%  The calling syntax is:
%  
%  		[records] = isprintWeb(cgiurl, file, parms, user_fullname, user_email, user_affiliation, [filters, [missing, [assumed, [knownbad] ] ] ])
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
%   Example: data = isprintWeb('http://madrigal.haystack.mit.edu/cgi-bin/madrigal/', ...
%                                '/opt/madrigal/experiments/1998/mlh/07jan98/mil980107g.001', ...
%                                'gdlat,ti,dti', ...
%                                'Bill Rideout', 'wrideout@haystack.mit.edu', 'MIT');
%
%   For now avoids limits with urlread by only asking for maxRecs records at once.  Repeatedly
%   calls isprintUnguarded, which is a method without any additional filtering.
%
%    $Id: isprintWeb.m 4428 2014-07-30 18:52:48Z brideout $

% constant
maxRecs = 100;

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

% verify user entered doubles for missing, assumed, knownbad
if (strcmp(class(missing), 'char'))
    error('missing must be a float or NaN, not a string')
end
if (strcmp(class(assumed), 'char'))
    error('assumed must be a float or NaN, not a string')
end
if (strcmp(class(knownbad), 'char'))
    error('knownbad must be a float or NaN, not a string')
end

% first try to use wget rather than the isprintUnguarded hack
try
    records = isprintWget(cgiUrl, file, parms, user_fullname, user_email, user_affiliation, filters, missing, assumed, knownbad);
    return
catch exc
    %exc
   warning('wget may not be installed, less robust Matlab urlread will be used instead');
end


numRec = getNumRec(cgiUrl, file, ...
                   user_fullname, user_email, user_affiliation);
               
records = [];  % sum all results together    
startRec = 0;
endRec = maxRecs;

results = {};

while (1)
    % do until maxRec of isprint
    filterStr = getFilterStr(startRec, endRec);
    % add user filters
    filterStr = [filterStr, ' ',  filters];
    data = isprintUnguarded(cgiUrl, file, parms, ...
                            user_fullname, user_email, user_affiliation, ...
                            filterStr, missing, assumed, knownbad);
                           
    dataLens = size(data);
	     
    if (length(dataLens) == 3)
        results{length(results)+1} = data;
    end

    startRec = endRec + 1;
    endRec = startRec + maxRecs;
    if (startRec > numRec)
        break;
    end

end

% now find largest numRows and total number records, and copy in data
maxRows = 0;
totalRecs = 0;
numParms = 0;
for i = 1:length(results)
    sizeArr = size(results{i});
    if (sizeArr(1) > maxRows)
        maxRows = sizeArr(1);
    end
    totalRecs = totalRecs + sizeArr(3);
    numParms = sizeArr(2);
end

% create the three dimensional array
records = zeros(maxRows, numParms, totalRecs);
records(:,:,:) = missing;

% copy in data
thisRec = 0;
% loop through each group of recno
for i = 1:length(results)
    thisData = results{i};
    % loop through each record in that group
    sizeArr = size(thisData);
    for j = 1:sizeArr(3)
        thisRec = thisRec + 1;
        numRows = sizeArr(1);
        records(1:numRows,:,thisRec) = thisData(:,:,j);
    end
end

end


% getFilterStr is a private method to generate recno filter strings
function filterStr = getFilterStr(startRec, endRec)
    % getFilterStr is an internal method to make an isprint filter to accept
    % only certain recno
    [filterStr, errmsg] = sprintf('filter=recno,%i,%i', startRec, endRec);
                  
end

% getNumRec is a private method to determine the number of records in a file
function numRec = getNumRec(cgiurl, filename, ...
                   user_fullname, user_email, user_affiliation)
    % getNumRec returns the number of records in a file
    data = isprintUnguarded(cgiurl, filename, 'recno', ...
                            user_fullname, user_email, user_affiliation);
    numRec = data(end);
end
