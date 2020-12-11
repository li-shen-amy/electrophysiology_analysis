function varargout = data_process(varargin)
% DATA_PROCESS MATLAB code for data_process.fig
%      DATA_PROCESS, by itself, creates a new DATA_PROCESS or raises the existing
%      singleton*.
%
%      H = DATA_PROCESS returns the handle to a new DATA_PROCESS or the handle to
%      the existing singleton*.
%
%      DATA_PROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PROCESS.M with the given input arguments.
%
%      DATA_PROCESS('Property','Value',...) creates a new DATA_PROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_process_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_process_OpeningFcn via vara    rgin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_process

% Last Modified by GUIDE v2.5 21-Nov-2019 10:50:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @data_process_OpeningFcn, ...
    'gui_OutputFcn',  @data_process_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before data_process is made visible.
function data_process_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_process (see VARARGIN)

% Choose default command line output for data_process
handles.output = hObject;
if strcmp(computer,'MACI64')
    set(handles.prepath_edit,'String','/Users/Emily/Google Drive/data/');
    set(handles.parafile_edit,'String','/Users/Emily/Google Drive/data/pcg_exp_record_ana.xlsx');
elseif  strcmp(computer,'PCWIN64')
    set(handles.prepath_edit,'String','F:\data\');
    set(handles.parafile_edit,'String','F:\data\pcg_exp_record_ana.xlsx');
    %      set(handles.prepath_edit,'String','H:\');
    %     set(handles.parafile_edit,'String','H:\pcg_exp_record_ana.xlsx');
    %      set(handles.prepath_edit,'String','H:\TH-cre LC recording\');
    %     set(handles.parafile_edit,'String','H:\TH-cre LC recording\pcg_exp_record_ana.xlsx');
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes data_process wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = data_process_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function prepath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to prepath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prepath_edit as text
%        str2double(get(hObject,'String')) returns contents of prepath_edit as a double


% --- Executes during object creation, after setting all properties.
function prepath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prepath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open_prepath.
function open_prepath_Callback(hObject, eventdata, handles)
% hObject    handle to open_prepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.prepath=get(handles.prepath_edit,'String');
handles.prepath=uigetdir(handles.prepath,'Select the home folder');
set(handles.prepath_edit,'String',handles.prepath);
guidata(hObject, handles);



function parafile_edit_Callback(hObject, eventdata, handles)
% hObject    handle to parafile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parafile_edit as text
%        str2double(get(hObject,'String')) returns contents of parafile_edit as a double


% --- Executes during object creation, after setting all properties.
function parafile_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parafile_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in getparafile.
function getparafile_Callback(hObject, eventdata, handles)
% hObject    handle to getparafile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.parafilename,xpn,filterindex]=uigetfile({'*.xlsx','*.xls'},...
    'Select Paradigm Excel',fullfile(handles.prepath,'pcg_exp_record_ana.xlsx'));
set(handles.parafile_edit,'String',handles.parafilename);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function date_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function chnum_edit_Callback(hObject, eventdata, handles)
% hObject    handle to chnum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chnum_edit as text
%        str2double(get(hObject,'String')) returns contents of chnum_edit as a double


% --- Executes during object creation, after setting all properties.
function chnum_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chnum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xpn_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xpn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xpn_edit as text
%        str2double(get(hObject,'String')) returns contents of xpn_edit as a double


% --- Executes during object creation, after setting all properties.
function xpn_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function binfolder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to binfolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of binfolder_edit as text
%        str2double(get(hObject,'String')) returns contents of binfolder_edit as a double


% --- Executes during object creation, after setting all properties.
function binfolder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binfolder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in comsite_sel.
function comsite_sel_Callback(hObject, eventdata, handles)
% hObject    handle to comsite_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of comsite_sel


% --- Executes on button press in conv2plxbin.
function conv2plxbin_Callback(hObject, eventdata, handles)
% hObject    handle to conv2plxbin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
binfolder=get(handles.binfolder_edit,'String');
handles.binfolder=fullfile(handles.xpn,binfolder);
if ~exist(handles.binfolder,'dir')
    mkdir(handles.binfolder);
end
if get(handles.ele_10mm,'Value')
    chmap=[13,14,15,16,11,12,9,10,7,8,5,6,3,4,1,2];
else
    chmap=1:handles.ch_num;
end
if get(handles.comsite_sel,'Value')
    [all_site,~,iall_site]=unique(handles.num(:,handles.isite));
    clear session_com_all
    eval(['site_sel=[',get(handles.site_sel,'String'),'];']);
    if isempty(site_sel)
        for site=1:length(all_site)
            session_com_all{site}=[handles.num(iall_site==site,handles.isite),...
                handles.num(iall_site==site,handles.irec),...
                handles.num(iall_site==site,handles.ipen)];
        end
    else
        all_site=all_site(ismember(all_site,site_sel));
        for site=1:length(site_sel)
            idx=find(handles.num(:,handles.isite)==all_site(site));
            session_com_all{site}=[handles.num(idx,handles.isite),...
                handles.num(idx,handles.irec),...
                handles.num(idx,handles.ipen)];
        end
    end
    % chmap=[4,3,2,1,11,10,9,8,7,6,5];% 11 ch   ?-->12 ch 3 tetrode?
    % chmap=[4,3,2,1,16,15,14,13,12,11,10,9,8,7,6,5];
    
    for icom=1:length(session_com_all)
        session_com=session_com_all{icom};
        rec_site=all_site(icom);
        if ~get(handles.sep_tet,'Value')
            data_kwik=[];
            disp(['Start converting site ',num2str(rec_site),' ...']);
            for tmp=1:size(session_com,1)
                rec_i=find(handles.num(:,handles.isite)==rec_site &...
                    handles.num(:,handles.irec)==session_com(tmp,2) &...
                    handles.num(:,handles.ipen)==session_com(tmp,3))+1;
                npen=handles.raw{rec_i,handles.ipen};
                rec_session=handles.raw{rec_i,handles.irec};
                %         ntrial=raw{rec_i,itrial};
                Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
                trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
                trace_dots=Fs*trace_length;
                xfn=[handles.date,'_pen',num2str(npen),'_',num2str(rec_session),'.lvb'];
                fn=fullfile(handles.xpn,xfn);
                if exist(fn,'file')
                    fid=fopen(fn,'r','b'); % returns the identifiler
                    data=fread(fid,[trace_dots,inf],'single','b');%
                    
                    data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
                    fclose(fid);
                    trial_num=size(data,2)/handles.ch_num;
                    
                    for trial=1:trial_num
                        data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)'];
                    end
                    
                else
                    disp(['Non-exist:',fn]);
                end
            end
            %         clear data_kwik_sm
            %         for ch=1:size(data_kwik,1)
            %           [data_kwik_sm(ch,:),~] = eegfilt(data_kwik(ch,:),30000,300,10000);
            %         end
            %         data_kwik=data_kwik_sm;
            if get(handles.if_rem_com_sig,'value')
            data_kwik=data_kwik-median(data_kwik,1); % common median reference
            end
            data1d=reshape(data_kwik,1,size(data_kwik,1)*size(data_kwik,2));
            maxdata=max(abs(data1d))
            stddata=std(data1d);
            sat_mv=str2num(get(handles.sat_mv,'String'));
            if maxdata>sat_mv
                disp(['rec_',num2str(rec_session),'saturated!']);
                data_kwik(data_kwik>sat_mv)=sat_mv;
                data_kwik(data_kwik<-sat_mv)=-sat_mv;
                maxdata=sat_mv;
            end
            
            %         factor=127/maxdata;
            factor=32767/maxdata;
            data1=int16(data_kwik*factor); % 16 bit
            ntrial=size(data1,2);
            % fid=fopen(strrep(fn,'.lvb','.dat'),'w','b');
             if get(handles.if_rem_com_sig,'value')
            fid=fopen(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com_demean.bin']),'w');
            disp(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com_demean.bin']))
             else
                    fid=fopen(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com.bin']),'w');
            disp(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com.bin']))
             end
            fwrite(fid,data1,'int16');
            fclose(fid);
        else
            if get(handles.ele_10mm,'Value')
                tetrode_map=[13,14,15,16;11,12,9,10;7,8,5,6;3,4,1,2];
            else
                tetrode_map=[1:4;5:8;9:12;13:16];
            end
            
            for itet=1:size(tetrode_map,1)
                data_kwik=[];
                disp(['Start converting site ',num2str(rec_site),', tet ',num2str(itet),' ...']);
                chmap=tetrode_map(itet,:);
                for tmp=1:size(session_com,1)
                    rec_i=find(handles.num(:,handles.isite)==rec_site &...
                        handles.num(:,handles.irec)==session_com(tmp,2) &...
                        handles.num(:,handles.ipen)==session_com(tmp,3))+1;
                    npen=handles.raw{rec_i,handles.ipen};
                    rec_session=handles.raw{rec_i,handles.irec};
                    %         ntrial=raw{rec_i,itrial};
                    Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
                    trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
                    trace_dots=Fs*trace_length;
                    xfn=[handles.date,'_pen',num2str(npen),'_',num2str(rec_session),'.lvb'];
                    fn=fullfile(handles.xpn,xfn);
                    if exist(fn,'file')
                        fid=fopen(fn,'r','b'); % returns the identifiler
                        data=fread(fid,[trace_dots,inf],'single','b');%
                        
                        data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
                        fclose(fid);
                        trial_num=size(data,2)/handles.ch_num;
                        
                        for trial=1:trial_num
                            data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)'];
                        end
                        
                    else
                        disp(['Non-exist:',fn]);
                    end
                end
                %         clear data_kwik_sm
                %         for ch=1:size(data_kwik,1)
                %           [data_kwik_sm(ch,:),~] = eegfilt(data_kwik(ch,:),30000,300,10000);
                %         end
                %         data_kwik=data_kwik_sm;
                  if get(handles.if_rem_com_sig,'value')
            data_kwik=data_kwik-mean(data_kwik);
            end
                data1d=reshape(data_kwik,1,size(data_kwik,1)*size(data_kwik,2));
                maxdata=max(abs(data1d))
                stddata=std(data1d);
                sat_mv=str2num(get(handles.sat_mv,'String'));
                if maxdata>sat_mv
                    disp(['rec_',num2str(rec_session),'saturated!']);
                    data_kwik(data_kwik>sat_mv)=sat_mv;
                    data_kwik(data_kwik<-sat_mv)=-sat_mv;
                    maxdata=sat_mv;
                end
                
                %         factor=127/maxdata;
                factor=32767/maxdata;
                data1=int16(data_kwik*factor); % 16 bit
                ntrial=size(data1,2);
                % fid=fopen(strrep(fn,'.lvb','.dat'),'w','b');
                 if get(handles.if_rem_com_sig,'value')
            fid=fopen(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_t',num2str(itet),'_com_demean.bin']),'w');
                disp(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_t',num2str(itet),'_com_demean.bin']))
             else
                fid=fopen(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_t',num2str(itet),'_com.bin']),'w');
                disp(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_t',num2str(itet),'_com.bin']))
                 end
                 fwrite(fid,data1,'int16');
                fclose(fid);
            end
        end
    end
else
    if ~get(handles.sel_files,'Value')
        [all_site,~,iall_site]=unique(handles.num(:,handles.isite));
        clear session_com_all
        eval(['site_sel=[',get(handles.site_sel,'String'),'];']);
        if isempty(site_sel)
            for site=1:length(all_site)
                session_com_all{site}=[handles.num(iall_site==site,handles.isite),...
                    handles.num(iall_site==site,handles.irec),...
                    handles.num(iall_site==site,handles.ipen)];
            end
        else
            all_site=all_site(ismember(all_site,site_sel));
            for site=1:length(site_sel)
                idx=find(handles.num(:,handles.isite)==all_site(site));
                session_com_all{site}=[handles.num(idx,handles.isite),...
                    handles.num(idx,handles.irec),...
                    handles.num(idx,handles.ipen)];
            end
        end
        
        for icom=1:length(session_com_all)
            session_com=session_com_all{icom};
            rec_site=all_site(icom);
            for tmp=1:size(session_com,1)
                rec_i=find(handles.num(:,handles.isite)==rec_site &...
                    handles.num(:,handles.irec)==session_com(tmp,2) &...
                    handles.num(:,handles.ipen)==session_com(tmp,3))+1;
                npen=handles.raw{rec_i,handles.ipen};
                rec_session=handles.raw{rec_i,handles.irec};
                %         ntrial=raw{rec_i,itrial};
                Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
                trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
                trace_dots=Fs*trace_length;
                xfn=[handles.date,'_pen',num2str(npen),'_',num2str(rec_session),'.lvb'];
                fn=fullfile(handles.xpn,xfn);
                if exist(fn,'file')
                    fid=fopen(fn,'r','b'); % returns the identifiler
                    data=fread(fid,[trace_dots,inf],'single','b' );%
                    data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
                    fclose(fid);
                    trial_num=size(data,2)/handles.ch_num;
                    data_kwik=[];
                    for trial=1:trial_num
                        data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)'];
                    end
                      if get(handles.if_rem_com_sig,'value')
            data_kwik=data_kwik-mean(data_kwik);
            end
                    data1d=reshape(data_kwik,1,size(data_kwik,1)*size(data_kwik,2));
                    maxdata=max(abs(data1d));
                    stddata=std(data1d);
                    sat_mv=str2num(get(handles.sat_mv,'String'));
                    if maxdata>sat_mv
                        disp(['rec_',num2str(rec_session),'saturated!']);
                        data_kwik(data>sat_mv)=sat_mv;
                        data_kwik(data<-sat_mv)=-sat_mv;
                        maxdata=sat_mv;
                    end
                    %         factor=127/mtaxdata;
                    factor=32767/maxdata;
                    data1=int16(data_kwik*factor); % 16 bit
                    ntrial=size(data1,2);
                       if get(handles.if_rem_com_sig,'value')
                      disp(fullfile(handles.binfolder,strrep(xfn,'.lvb','_demean.bin')));
                    fid=fopen(fullfile(handles.binfolder,strrep(xfn,'.lvb','_demean.bin')),'w');
                       else
                    disp(fullfile(handles.binfolder,strrep(xfn,'.lvb','.bin')));
                    fid=fopen(fullfile(handles.binfolder,strrep(xfn,'.lvb','.bin')),'w');
                       end
                    fwrite(fid,data1,'int16');
                    fclose(fid);
                else
                    disp(['Non-exist:',fn]);
                end
            end
        end
    else
        if ~iscell(handles.xfn_comb)
            tmp{1}=handles.xfn_comb;
            handles.xfn_comb=tmp;
        end
        for icom=1:length(handles.xfn_comb)
            xfn=handles.xfn_comb{icom};
            fn=fullfile(handles.xpn_comb,xfn);
            
            if exist(fn,'file')
                under_idx=strfind(xfn,'_');
                dot_idx=strfind(xfn,'.');
                npen=str2num(xfn(under_idx(3)+4:under_idx(4)-1));
                rec_no=str2num(xfn(under_idx(4)+1:dot_idx(1)-1));
                
                rec_i=find(handles.num(:,handles.ipen)==npen &...
                    handles.num(:,handles.irec)==rec_no)+1;
                rec_site=handles.raw{rec_i,handles.isite};
                rec_session=handles.raw{rec_i,handles.irec};
                %         ntrial=raw{rec_i,itrial};
                Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
                trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
                trace_dots=Fs*trace_length;
                
                fid=fopen(fn,'r','b'); % returns the identifiler
                data=fread(fid,[trace_dots,inf],'single','b' );
                data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
                fclose(fid);
                trial_num=size(data,2)/handles.ch_num;
                data_kwik=[];
                for trial=1:trial_num
                    data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)'];
                end
                   if get(handles.if_rem_com_sig,'value')
            data_kwik=data_kwik-mean(data_kwik);
            end
                data1d=reshape(data_kwik,1,size(data_kwik,1)*size(data_kwik,2));
                maxdata=max(abs(data1d));
                stddata=std(data1d);
                sat_mv=str2num(get(handles.sat_mv,'String'));
                if maxdata>sat_mv
                    disp(['rec_',num2str(rec_session),'saturated!']);
                    data_kwik(data>sat_mv)=sat_mv;
                    data_kwik(data<-sat_mv)=-sat_mv;
                    maxdata=sat_mv;
                end
                %         factor=127/mtaxdata;
                factor=32767/maxdata;
                data1=int16(data_kwik*factor); % 16 bit
                ntrial=size(data1,2);
                  if get(handles.if_rem_com_sig,'value')
                       disp(fullfile(handles.binfolder,strrep(xfn,'.lvb','_demean.bin')));
                fid=fopen(fullfile(handles.binfolder,strrep(xfn,'.lvb','_demean.bin')),'w');
                  else
                disp(fullfile(handles.binfolder,strrep(xfn,'.lvb','.bin')));
                fid=fopen(fullfile(handles.binfolder,strrep(xfn,'.lvb','.bin')),'w');
                  end
                  fwrite(fid,data1,'int16');
                fclose(fid);
            else
                disp(['Non-exist:',fn]);
            end
        end
    end
end
disp('Converting Done!');
guidata(hObject, handles);

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in predata_btn.
function predata_btn_Callback(hObject, eventdata, handles)
% hObject    handle to predata_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle.pre.ch_num=handles.ch_num;
handle.pre.Fs=handles.Fs;
handle.pre.xpn=handles.xpn;
% handle_pre.trace_length=handles.trace_length;
handle.pre.raw=handles.raw;
handle.pre.num=handles.num;
handle.pre.ipen=handles.ipen;
handle.pre.irec=handles.irec;
handle.pre.iscanlen=handles.iscanlen;
preview_data(handle.pre);%'Init_para',1,eventdata,handles,handle_pre);
% [exptModified handles.analysisGUI] = analysisGUInew(handles.expt,{@SaveExpt_Callback,handles.SaveExpt});

% --- Executes on button press in load_para.
function load_para_Callback(hObject, eventdata, handles)
% hObject    handle to load_para (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.prepath=get(handles.prepath_edit,'String');
handles.date=get(handles.date_edit,'String');
handles.parafilename=get(handles.parafile_edit,'String');
handles.ch_num=str2num(get(handles.chnum_edit,'String'));
handles.date=get(handles.date_edit,'String');
handles.Fs=str2num(get(handles.fs_edit,'String'));
[handles.num,txt,raw]=xlsread(handles.parafilename,handles.date);
for i=1:size(raw,2)
    if strcmp(raw(1,i),'fs')
        handles.iFs=i;%1
    elseif strcmp(raw(1,i),'record')
        handles.irec=i;%2
    elseif strcmp(raw(1,i),'penetration')
        handles.ipen=i;%3
    elseif strcmp(raw(1,i),'site')
        handles.isite=i;%4
    elseif strcmp(raw(1,i),'paradigm')
        handles.ipara=i;%5
    elseif strcmp(raw(1,i),'scal_len')
        handles.iscanlen=i;%6
    elseif strcmp(raw(1,i),'duration')
        handles.idur=i;%7
    elseif strcmp(raw(1,i),'isi')
        handles.iisi=i;%8
    elseif strcmp(raw(1,i),'trial')
        handles.itrial=i;%9
    end
end
handles.xpn=fullfile(handles.prepath,handles.date);
handles.raw=raw;
set(handles.xpn_edit,'String',handles.xpn);
disp('Loading Done!');
guidata(hObject, handles);

% --- Executes on button press in open_rawfolder.
function open_rawfolder_Callback(hObject, eventdata, handles)
% hObject    handle to open_rawfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xpn=uigetdir(handles.prepath,'Select the raw data folder');
set(handles.xpn_edit,'String',handles.xpn);
guidata(hObject, handles);



function fs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs_edit as text
%        str2double(get(hObject,'String')) returns contents of fs_edit as a double


% --- Executes during object creation, after setting all properties.
function fs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in comb_btn.
function comb_btn_Callback(hObject, eventdata, handles)
% hObject    handle to comb_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.ele_10mm,'Value')
    chmap=[13,14,15,16,11,12,9,10,7,8,5,6,3,4,1,2];
else
    chmap=1:handles.ch_num;
end
session_com_all=handles.xfn_comb;

data_kwik=[];
for icom=1:length(handles.xfn_comb)
    xfn=handles.xfn_comb{icom};
    fn=fullfile(handles.xpn_comb,xfn);
    %              under_idx=strfind(xfn,'_');
    %              dot_idx=strfind(xfn,'.');
    %
    %             npen=str2num(xfn(under_idx(3)+4:under_idx(4)-1));
    %             rec_session=str2num(xfn(under_idx(4)+1:dot_idx(1)-1));
    %             rec_i=find(handles.num(:,handles.ipen)==npen &...
    %                 handles.num(:,handles.irec)==rec_session);
    %             % ntrial=raw{rec_i,itrial};
    %             Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
    %             trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
    %             trace_dots=Fs*trace_length;
    
    if exist(fn,'file')
        fid=fopen(fn,'r','b'); % returns the identifiler
        data=fread(fid,inf,'single','b' );%
        %                 data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
        fclose(fid);
        %                 trial_num=size(data,2)/handles.ch_num;
        %                 for trial=1:trial_num
        data_kwik=[data_kwik;data];%(:,(trial-1)*handles.ch_num+chmap)'];
        %                 end
    else
        disp(['Non-exist:',fn]);
    end
end
%         data1d=reshape(data_kwik,1,size(data_kwik,1)*size(data_kwik,2));
%         maxdata=max(abs(data1d));
%         stddata=std(data1d);
%         if maxdata>0.5
%             disp(['rec_',num2str(rec_session),'saturated!']);
%             data_kwik(data_kwik>0.5)=0.5;
%             data_kwik(data_kwik<-0.5)=-0.5;
%             maxdata=0.5;
%         end
%         factor=127/maxdata;
%         data1=data_kwik*factor; % 16 bit
%         ntrial=size(data1,2);
% fid=fopen(strrep(fn,'.lvb','.dat'),'w','b');
output_name=get(handles.com_output_name_edit,'String');
fid=fopen(fullfile(handles.xpn,output_name),'w');
disp(fullfile(handles.xpn,output_name));
fwrite(fid,data_kwik,'single','b');
fclose(fid);
disp('Combining Done!');
guidata(hObject, handles);

% --- Executes on button press in multisel_btn.
function multisel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to multisel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[xfn,handles.xpn_comb,~]=uigetfile('*.lvb',...
    'Select the raw data files to be combined',get(handles.xpn_edit,'String'),'MultiSelect','on');
if iscell(xfn)
    xfn_list=xfn{1};
    if length(xfn)>1
        for fi=2:length(xfn)
            xfn_list=[xfn_list,',',xfn{fi}];
        end
    end
else
    xfn_list=xfn;
end
set(handles.combfiles_edit,'String',xfn_list);
handles.xfn_comb=xfn;
guidata(hObject, handles);

function combfiles_edit_Callback(hObject, eventdata, handles)
% hObject    handle to combfiles_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of combfiles_edit as text
%        str2double(get(hObject,'String')) returns contents of combfiles_edit as a double


% --- Executes during object creation, after setting all properties.
function combfiles_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to combfiles_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function com_output_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to com_output_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of com_output_name_edit as text
%        str2double(get(hObject,'String')) returns contents of com_output_name_edit as a double


% --- Executes during object creation, after setting all properties.
function com_output_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com_output_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function site_sel_Callback(hObject, eventdata, handles)
% hObject    handle to site_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of site_sel as text
%        str2double(get(hObject,'String')) returns contents of site_sel as a double


% --- Executes during object creation, after setting all properties.
function site_sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to site_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savetomat.
function savetomat_Callback(hObject, eventdata, handles)
% hObject    handle to savetomat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('Start Exporting...');
binfolder=get(handles.binfolder_edit,'String');
handles.binfolder=fullfile(handles.xpn,binfolder);
if ~exist(handles.binfolder,'dir')
    mkdir(handles.binfolder);
end
if get(handles.ele_10mm,'Value')
    chmap=[13,14,15,16,11,12,9,10,7,8,5,6,3,4,1,2];
else
    chmap=1:handles.ch_num;
end
if get(handles.comsite_sel,'Value')
    [all_site,~,iall_site]=unique(handles.num(:,handles.isite));
    clear session_com_all
    eval(['site_sel=[',get(handles.site_sel,'String'),'];']);
    if isempty(site_sel)
        for site=1:length(all_site)
            session_com_all{site}=[handles.num(iall_site==site,handles.isite),...
                handles.num(iall_site==site,handles.irec),...
                handles.num(iall_site==site,handles.ipen)];
        end
    else
        all_site=all_site(ismember(all_site,site_sel));
        for site=1:length(site_sel)
            idx=find(handles.num(:,handles.isite)==all_site(site));
            session_com_all{site}=[handles.num(idx,handles.isite),...
                handles.num(idx,handles.irec),...
                handles.num(idx,handles.ipen)];
        end
    end
    % chmap=[4,3,2,1,11,10,9,8,7,6,5];% 11 ch   ?-->12 ch 3 tetrode?
    % chmap=[4,3,2,1,16,15,14,13,12,11,10,9,8,7,6,5];
    
    for icom=1:length(session_com_all)
        session_com=session_com_all{icom};
        rec_site=all_site(icom);
        data_kwik=[];
        for tmp=1:size(session_com,1)
            rec_i=find(handles.num(:,handles.isite)==rec_site &...
                handles.num(:,handles.irec)==session_com(tmp,2) &...
                handles.num(:,handles.ipen)==session_com(tmp,3))+1;
            npen=handles.raw{rec_i,handles.ipen};
            rec_session=handles.raw{rec_i,handles.irec};
            %         ntrial=raw{rec_i,itrial};
            Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
            trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
            trace_dots=Fs*trace_length;
            xfn=[handles.date,'_pen',num2str(npen),'_',num2str(rec_session),'.lvb'];
            fn=fullfile(handles.xpn,xfn);
            if exist(fn,'file')
                fid=fopen(fn,'r','b'); % returns the identifiler
                data=fread(fid,[trace_dots,inf],'single','b' );%
                data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
                fclose(fid);
                trial_num=size(data,2)/handles.ch_num;
                for trial=1:trial_num
                    data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)'];
                end
            else
                disp(['Non-exist:',fn]);
            end
        end
        
        %         data1d=reshape(data_kwik,1,size(data_kwik,1)*size(data_kwik,2));
        %         maxdata=max(abs(data1d));
        %         stddata=std(data1d);
        %         if maxdata>0.5
        %             disp(['rec_',num2str(rec_session),'saturated!']);
        %             data_kwik(data_kwik>0.5)=0.5;
        %             data_kwik(data_kwik<-0.5)=-0.5;
        %             maxdata=0.5;
        %         end
        %
        %         factor=127/maxdata;
        %         data1=data_kwik*factor; % 16 bit
             if get(handles.if_rem_com_sig,'value')
            data_kwik=data_kwik-mean(data_kwik);
            end
        save(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com.mat']),'data_kwik','-v7.3');
        
        %         ntrial=size(data1,2);
        %         % fid=fopen(strrep(fn,'.lvb','.dat'),'w','b');
        %         fid=fopen(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com.bin']),'w','b');
        %         disp(fullfile(handles.binfolder,[handles.date,'_',num2str(rec_site),'_com.bin']))
        %         fwrite(fid,data1,'int16','b');
        %         fclose(fid);
    end
else
    [all_site,~,iall_site]=unique(handles.num(:,handles.isite));
    clear session_com_all
    eval(['site_sel=[',get(handles.site_sel,'String'),'];']);
    if isempty(site_sel)
        for site=1:length(all_site)
            session_com_all{site}=[handles.num(iall_site==site,handles.isite),...
                handles.num(iall_site==site,handles.irec),...
                handles.num(iall_site==site,handles.ipen)];
        end
    else
        all_site=all_site(ismember(all_site,site_sel));
        for site=1:length(site_sel)
            idx=find(handles.num(:,handles.isite)==all_site(site));
            session_com_all{site}=[handles.num(idx,handles.isite),...
                handles.num(idx,handles.irec),...
                handles.num(idx,handles.ipen)];
        end
    end
    
    for icom=1:length(session_com_all)
        session_com=session_com_all{icom};
        rec_site=all_site(icom);
        
        for tmp=1:size(session_com,1)
            rec_i=find(handles.num(:,handles.isite)==rec_site &...
                handles.num(:,handles.irec)==session_com(tmp,2) &...
                handles.num(:,handles.ipen)==session_com(tmp,3))+1;
            npen=handles.raw{rec_i,handles.ipen};
            rec_session=handles.raw{rec_i,handles.irec};
            %         ntrial=raw{rec_i,itrial};
            Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
            trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
            trace_dots=Fs*trace_length;
            xfn=[handles.date,'_pen',num2str(npen),'_',num2str(rec_session),'.lvb'];
            fn=fullfile(handles.xpn,xfn);
            if exist(fn,'file')
                fid=fopen(fn,'r','b'); % returns the identifiler
                data=fread(fid,[trace_dots,inf],'single','b' );%
                data=data(round(Fs/1000)+1:end-round(Fs/1000),:);% discard the first 1ms last 1ms  2017-6-19
                fclose(fid);
                trial_num=size(data,2)/handles.ch_num;
                data_kwik=[];
                for trial=1:trial_num
                    data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)'];
                end
                   if get(handles.if_rem_com_sig,'value')
            data_kwik=data_kwik-mean(data_kwik);
            end
                data_kwik=data_kwik*1000;
                disp(fullfile(handles.binfolder,strrep(xfn,'.lvb','.mat')));
                save(fullfile(handles.binfolder,strrep(xfn,'.lvb','.mat')),'data_kwik','-v7.3');
            else
                disp(['Non-exist:',fn]);
            end
        end
    end
end
disp('Exporting Done!');
guidata(hObject, handles);


% --- Executes on button press in sel_files.
function sel_files_Callback(hObject, eventdata, handles)
% hObject    handle to sel_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sel_files



function sat_mv_Callback(hObject, eventdata, handles)
% hObject    handle to sat_mv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sat_mv as text
%        str2double(get(hObject,'String')) returns contents of sat_mv as a double


% --- Executes during object creation, after setting all properties.
function sat_mv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sat_mv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function del_trials_input_Callback(hObject, eventdata, handles)
% hObject    handle to del_trials_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of del_trials_input as text
%        str2double(get(hObject,'String')) returns contents of del_trials_input as a double


% --- Executes during object creation, after setting all properties.
function del_trials_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to del_trials_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbtn_del_trials.
function pbtn_del_trials_Callback(hObject, eventdata, handles)
% hObject    handle to pbtn_del_trials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_trials_txt=get(handles.del_trials_input,'String');
eval(['del_trials=[',del_trials_txt,'];']);
% if get(handles.ele_10mm,'Value')
%     chmap=[];
% else
%     chmap=1:handles.ch_num;
% end
chmap=1:handles.ch_num;
data_kwik=[];
xfn=get(handles.combfiles_edit,'String');
fn=fullfile(handles.xpn_comb,xfn);

if exist(fn,'file')
    fid=fopen(fn,'r','b'); % returns the identifiler
    trace_length=str2num(get(handles.edit_trace_len,'String'));% handles.trace_length
    trace_dots=handles.Fs*trace_length;
    data=fread(fid,[trace_dots,inf],'single','b' );%
    fclose(fid);
    trial_num=size(data,2)/handles.ch_num;
    trial_list=setdiff(1:trial_num,del_trials);
    for trial=trial_list
        data_kwik=[data_kwik,data(:,(trial-1)*handles.ch_num+chmap)];
    end
else
    disp(['Non-exist:',fn]);
end
output_name=get(handles.com_output_name_edit,'String');
fid=fopen(fullfile(handles.xpn,output_name),'w');
disp(fullfile(handles.xpn,output_name));
fwrite(fid,data_kwik,'single','b');
fclose(fid);
disp('Deleting Trials Done!');
guidata(hObject, handles);


function edit_trace_len_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trace_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trace_len as text
%        str2double(get(hObject,'String')) returns contents of edit_trace_len as a double


% --- Executes during object creation, after setting all properties.
function edit_trace_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trace_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ele_10mm.
function ele_10mm_Callback(hObject, eventdata, handles)
% hObject    handle to ele_10mm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ele_10mm


% --- Executes on button press in sep_tet.
function sep_tet_Callback(hObject, eventdata, handles)
% hObject    handle to sep_tet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sep_tet


% --- Executes on button press in if_rem_com_sig.
function if_rem_com_sig_Callback(hObject, eventdata, handles)
% hObject    handle to if_rem_com_sig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of if_rem_com_sig
