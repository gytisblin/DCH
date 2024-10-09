 function [neac] = plotPFISR_NeTe_automated_ac_input_1(year,month,day,starttime,endtime,start_hour,start_min,end_hour,end_min,doyin,hour,hour2,hour3,min1,min2,min3,PRN)

 neac=[]
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


flag='Ne'
beam=64157
codetype='ac'







 hold on



    t0 = t1;
    tf = t2;



alt_cutoff = 195; % km




[year,month,day,hour,min,sec]=datevec(t1)
Madrigal = load_pfisr_matfile_input_1(year,month,day,5950,hour,hour2,hour3,min1,min2,min3,PRN,doyin);
Madrigalac = load_pfisr_matfile_input_1(year,month,day,5951,hour,hour2,hour3,min1,min2,min3,PRN,doyin);

    
if ~isempty(Madrigalac)
else
    neac=0
    return
end
if codetype=='lp'
    if exist('Madrigal')

PFISR_data = zeros(size(Madrigal, 1),16);

cols = [15, 17, 10, 6, 2, 8, 1, 12]; cols2 = 14; cols3 = 7; cols4=19;
        PFISR_data(:,1:8) = Madrigal(:,cols);%, ...
        % so re-order with columns as
        upBrows = find(Madrigal(:,1) == -154.3 & Madrigal(:,14) == 77.5);
        PFISR_data(upBrows,9) = 64157;
        PFISR_data(:,10) = Madrigal(:,cols2);
        PFISR_data(:,11) = log10(Madrigal(:,cols3));
        PFISR_data(:,13) = Madrigal(:,9);
        PFISR_data(:,15) = Madrigal(:,9);
         PFISR_data(:,17)=Madrigal(:,19);
            %];
        clear cols cols2 cols3
end    
% columns
% 1:DATENUM,2:AZM,3:ELM,4:BEAMID,5:RANGE,6:NEL,7:DNEL,8:TI,9:DTI,10:TE,11:DTE,12:DNE
data = [datenum(PFISR_data(:,1:6)), PFISR_data(:,7:end)];


if strcmp(flag, 'Ne')
    cols = 6;
elseif strcmp(flag, 'Te')
    cols = 10;
elseif strcmp(flag, 'Ti');
    cols = 8;
end

delta = 0;
if delta
    deltaflag = 'delta';
else
    deltaflag = 'normal';
end

data = data(data(:,1) <= datenum(tf) & data(:,1) >= datenum(t0),:);

    
    
    
    
end







if codetype=='ac'
if exist('Madrigalac')
PFISR_data = zeros(size(Madrigalac, 1),16);


cols = [15, 17, 10, 6, 2, 8, 1, 12]; cols2 = 14; cols3 = 7; cols4=19;
        PFISR_data(:,1:8) = Madrigalac(:,cols);%, ...
        
        upBrows = find(Madrigalac(:,1) == -154.3 & Madrigalac(:,12) == 77.5);
        PFISR_data(upBrows,9) = 64157;%repmat(64157,size(Madrigalac,1),1);%, ...
        PFISR_data(:,10) = Madrigalac(:,cols2);%, ...
        PFISR_data(:,11) = log10(Madrigalac(:,cols3));
        PFISR_data(:,13) = Madrigalac(:,9);
        PFISR_data(:,15) = Madrigalac(:,9);
        PFISR_data(:,17)=Madrigalac(:,19);
            %];
        clear cols cols2 cols3

end    

data = [datenum(PFISR_data(:,1:6)), PFISR_data(:,7:end)];


if strcmp(flag, 'Ne')
    cols = 6;
elseif strcmp(flag, 'Te')
    cols = 10;
elseif strcmp(flag, 'Ti');
    cols = 8;
end

delta = 0;
if delta
    deltaflag = 'delta';
else
    deltaflag = 'normal';
end

data = data(data(:,1) <= datenum(tf) & data(:,1) >= datenum(t0),:);

end







switch codetype
    case 'lp'
data = data(data(:,5) > alt_cutoff,:);
    case 'ac'
        data = data(data(:,5) <= alt_cutoff, :);
end

if ~isempty(data)
    beamid = unique(data(:, 4), 'stable');

    for ibeam = find(beamid == beam);%length(beamid)
        AZb(ibeam, :) = unique(data(data(:, 4) == beamid(ibeam), 2));
        ELb(ibeam, :) = unique(data(data(:, 4) == beamid(ibeam), 3));
        beamstr = strjoin({num2str(beamid(ibeam)), ...
            [num2str(AZb(ibeam, :)), '$^\circ$ az'], [num2str(ELb(ibeam, :)), '$^\circ$ el']}, ', ');

        
        data_beam = data(data(:, 4) == beamid(ibeam), :);

        ranges = unique(data_beam(:, 5), 'stable');

        nonnanrangerows = find(isfinite(data_beam(:,5)));
        ranges = ranges(isfinite(ranges))
        times = unique(data_beam(:, 1), 'stable');
        
        
        length_time=length(times)
        
        for i=1:length(times)
            time=times(i,1)
            kt=data_beam(:,1)==time
            data_from_beam=data_beam(data_beam(:,1)==time,:)
            [NumRows_range, NumColums]=size(data_from_beam)
            [NumRows_ranges,NumColums]=size(ranges)
            if data_from_beam(1,5)==data_from_beam(floor(NumRows_range/2+1),5)
               data_from_beam2=data_from_beam
               data_from_beam=[]
               NumRows_range2=NumRows_range
               NumRows_range=[]
               NumRows_range=NumRows_range2/2
                for nrr=1:(NumRows_range2/2)
                    data_from_beam(nrr,:)=data_from_beam2(nrr,:)
                end
            else
            end
            
            if NumRows_range<NumRows_ranges
                
                ranges_sorted=sort(ranges)
            else
               ranges_sorted=sort(ranges) 
            end
                
            range(:,i)=ranges_sorted
            
            
            for r=1:NumRows_range
                
            range_from_beam(r,i)=data_from_beam(r,5)
            end
            for r=NumRows_range+1:NumRows_ranges
                    range_from_beam(r,i)=0
            
            end
            
            
            
            
            
             NumRows_count(i,1)=NumRows_range
             
            
            if NumRows_range<NumRows_ranges
                 for j=1:NumRows_ranges
                     [I,J,V]=find(ranges_sorted(j,1)==range_from_beam(:,i))
                     
               if range_from_beam(j,i)==range(j,1)
                   ne(j,i) = 10.^data_from_beam(j, cols);
                  dne(j,i)=data_from_beam(j,12);
               elseif isempty(I)==0 
               ne(j,i) = 10.^data_from_beam(I, cols);
               dne(j,i)=data_from_beam(I,12);
              
                else
                    ne(j,i)=NaN
                    dne(j,i)=NaN

               end
                 end 
                

                 
            else
                for j=1:NumRows_ranges
                ne(j,i) = 10.^data_from_beam(j, cols);
                dne(j,i)=data_from_beam(j,12)
                end
            end
        end
                      
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        switch flag
            case 'Ne'

lengthrange=length(ranges)

            case 'Te'
        te = data_beam(:, cols);

        tegrid = reshape(te, length(ranges), []);
           case 'Ti'
                ti = data_beam(:,cols);
                tigrid = reshape(ti, [], length(times));
        end
        
        
       
        [timegrid, rangegrid] = meshgrid(times, ranges);
if ~isempty(ne)
[rtimegrigac,ctimegrid]=size(timegrid)
        
        positionstartac=find(timegrid>=scintstart)
        
        if ~isempty(positionstartac)
else
    neac=0
    return
end

        
        if positionstartac>1
        positionstart2ac=(positionstartac(1,1)-1)/rtimegrigac
        elseif positionstartac(1,1)<rtimegrigac
            positionstart2ac=(positionstartac(1,1))
        else
            positionstart2ac=(positionstartac(1,1))/rtimegrigac
        end
        
        if positionstart2ac==1
            column_startac=positionstart2ac
            column_start_loopac=column_startac-1
        else
        column_startac=positionstart2ac+1
        column_start_loopac=column_startac-1
        end
        
        positionendac=find(timegrid<=scintend)
        positionendlengthac=length(positionendac)
        column_endac=positionendlengthac/rtimegrigac
        
        column_lengthac=column_endac-column_startac+1

        for clac=1:column_lengthac
            neac(:,clac)=ne(:,column_start_loopac+clac)
        end
if ~isempty(neac)
else
    neac=0
end
end
        if delta

        else
            switch flag
                case 'Ne'
                    
            pcolor(timegrid, rangegrid, log10(ne));
%                    
            caxis([10, 12]);
            title(['\parbox{6in}{\centering ', beamstr, '\\', ...
                'PFISR Electron Density $N_e$}'],'interpreter','latex');
            cb = colorbar;
            set(get(cb, 'YLabel'), 'String', ...
                '$\log_{10}{N_e} [m^{-3}]$', ...
                'interpreter', 'latex');
                case 'Te'
                    pcolor(timegrid, rangegrid, tegrid);
                    caxis([0, 3000]);
                    title(['\parbox{6in}{\centering ', beamstr, '\\', ...
                        'PFISR Electron Temperature $T_e$}'], ...
                        'interpreter', 'latex');
                    cb = colorbar;
                    set(get(cb, 'YLabel'), 'String', ...
                        '$T_e$ [K]', ...
                        'interpreter', 'latex');
                case 'Ti'

            end
        end
        shading flat;
        set(gca, 'layer', 'top');
        grid off;
        xlabel('Time [HH:MM UT]');
        ylabel('Altitude [km]');
        ylim([50, 700]);
        xlim(datenum([t1; t2]));
        datetick('x', 'HH:MM', 'keeplimits');
        
        
        ax = axis;
        
        
       plot(ax(1:2), [alt_cutoff alt_cutoff], 'k', 'LineWidth', 2);
       plot(ax(1:2), [150 150], 'k', 'LineWidth', 2);
       plot(repmat(scintstart, 2, 1), ax(3:4), 'k', 'LineWidth',2);
       plot(repmat(scintend, 2, 1), ax(3:4), 'k', 'LineWidth', 2);

        string1='PFISR'
  string2=num2str(year)
  string3=num2str(month)
  string4=num2str(day)
  string5=num2str(start_hour)
  string6=num2str(start_min)
  string7=num2str(end_hour)
  string8=num2str(end_min)
  string9='PRN'
  string10=num2str(PRN)
  string11='DOY'
  string12=num2str(doyin)
  dash='_'
  
  plotname =strcat(string1,dash,string2,dash,string3,dash,string4,dash,string5,dash,string6,dash,string7,dash,string8,dash,string9,dash,string10,dash,string11,dash,string12)



plotpath='E:\GNSS_Research\edited_code\run_h\FINAL_CODE_FOR_DCH_PAPER\plots_input_1\'
        
        plot_name=strcat(plotpath,plotname)
         saveas(figure(1),plot_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        saveas(figure(1),plot_name,'png')
        

    end


else
    neac=0
end
end


