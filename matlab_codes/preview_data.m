function varargout = preview_data(varargin)
% PREVIEW_DATA MATLAB code for preview_data.fig
%      PREVIEW_DATA, by itself, creates a new PREVIEW_DATA or raises the existing
%      singleton*.
%
%      H = PREVIEW_DATA returns the handle to a new PREVIEW_DATA or the handle to
%      the existing singleton*.
%
%      PREVIEW_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREVIEW_DATA.M with the given input arguments.
%
%      PREVIEW_DATA('Property','Value',...) creates a new PREVIEW_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preview_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preview_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help preview_data

% Last Modified by GUIDE v2.5 06-May-2019 15:21:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @preview_data_OpeningFcn, ...
    'gui_OutputFcn',  @preview_data_OutputFcn, ...
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


% --- Executes just before preview_data is made visible.
function preview_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preview_data (see VARARGIN)

% Choose default command line output for preview_data
handles.output = hObject;
if ~isempty(varargin)
    handles.xpn=varargin{1}.xpn;
    handles.Fs=varargin{1}.Fs;
    handles.ch_num=varargin{1}.ch_num;
    % handles.trace_length=varargin{1}.trace_length;
    handles.raw=varargin{1}.raw;
    handles.num=varargin{1}.num;
    handles.ipen=varargin{1}.ipen;
    handles.irec=varargin{1}.irec;
    handles.iscanlen=varargin{1}.iscanlen;
    set(handles.filename_edit,'String',handles.xpn);
    set(handles.fs_edit,'String',handles.Fs);
    set(handles.ch_num_edit,'String',handles.ch_num);
    % set(handles.scanlen_edit,'String',handles.trace_length);
end
handles.disp_on=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes preview_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preview_data_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function swp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to swp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
swp_no=get(handles.swp_slider,'Value');
set(handles.swp_edit,'String',num2str(swp_no));
if handles.disp_on
    disp_btn_Callback(hObject, eventdata, handles);
end

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function swp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function swp_edit_Callback(hObject, eventdata, handles)
% hObject    handle to swp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of swp_edit as text
%        str2double(get(hObject,'String')) returns contents of swp_edit as a double
swp_no=str2num(get(handles.swp_edit,'String'));
set(handles.swp_slider,'Value',swp_no);
if handles.disp_on
    disp_btn_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function swp_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swp_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function scanlen_edit_Callback(hObject, eventdata, handles)
% hObject    handle to scanlen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scanlen_edit as text
%        str2double(get(hObject,'String')) returns contents of scanlen_edit as a double


% --- Executes during object creation, after setting all properties.
function scanlen_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scanlen_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trial_num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trial_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_num_edit as text
%        str2double(get(hObject,'String')) returns contents of trial_num_edit as a double


% --- Executes during object creation, after setting all properties.
function trial_num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxy_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxy_edit as text
%        str2double(get(hObject,'String')) returns contents of maxy_edit as a double


% --- Executes during object creation, after setting all properties.
function maxy_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxy_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function miny_edit_Callback(hObject, eventdata, handles)
% hObject    handle to miny_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miny_edit as text
%        str2double(get(hObject,'String')) returns contents of miny_edit as a double


% --- Executes during object creation, after setting all properties.
function miny_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miny_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoscaley_rbt.
function autoscaley_rbt_Callback(hObject, eventdata, handles)
% hObject    handle to autoscaley_rbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoscaley_rbt



function minx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to minx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minx_edit as text
%        str2double(get(hObject,'String')) returns contents of minx_edit as a double


% --- Executes during object creation, after setting all properties.
function minx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to maxx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxx_edit as text
%        str2double(get(hObject,'String')) returns contents of maxx_edit as a double


% --- Executes during object creation, after setting all properties.
function maxx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoscalex_rbt.
function autoscalex_rbt_Callback(hObject, eventdata, handles)
% hObject    handle to autoscalex_rbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoscalex_rbt



function filename_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_edit as text
%        str2double(get(hObject,'String')) returns contents of filename_edit as a double


% --- Executes during object creation, after setting all properties.
function filename_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xpn=get(handles.filename_edit,'String');
handles.ch_num=str2num(get(handles.ch_num_edit,'String'));
[handles.xfn,handles.xpn]=uigetfile('*.*','Select a data file',handles.xpn);
set(handles.filename_edit,'String',fullfile(handles.xpn,handles.xfn));
under_idx=strfind(handles.xfn,'_');
dot_idx=strfind(handles.xfn,'.');
handles.npen=str2num(handles.xfn(under_idx(3)+4:under_idx(4)-1));
handles.nrec=str2num(handles.xfn(under_idx(4)+1:dot_idx(end)-1));
% handles.Fs=handles.raw{rec_i,handles.iFs};% handles.Fs
handles.Fs=str2num(get(handles.fs_edit,'String'));
% set(handles.fs_edit,'String',handles.Fs);
if isfield(handles,'ipen') && isfield(handles,'irec') ...
        && isfield(handles,'iscanlen') && isfield(handles,'num') %3,2,6
    rec_i=find(handles.num(:,handles.ipen)==handles.npen &...
        handles.num(:,handles.irec)==handles.nrec)+1;
    if ~isempty(rec_i)
        handles.trace_length=handles.raw{rec_i,handles.iscanlen};% handles.trace_length
        set(handles.scanlen_edit,'String',handles.trace_length);
    else
        handles.trace_length=str2num(get(handles.scanlen_edit,'String'));
    end
else
    handles.trace_length=str2num(get(handles.scanlen_edit,'String'));
end
trace_dots=handles.Fs*handles.trace_length;
% handles.trace_length=str2num(set(handles.scanlen_edit,'String'));
fid=fopen(fullfile(handles.xpn,handles.xfn),'r','b'); % returns the identifiler
if ~isempty(strfind(handles.xfn,'.lvb'))
    handles.data=fread(fid,[trace_dots,inf],'single','b' );% 10k
else
    handles.data=fread(fid,[trace_dots,inf],'int16','b' );% 10k
end
fclose(fid);
globalmax=max(max(handles.data));
handles.data1d=reshape(handles.data,1,size(handles.data,1)*size(handles.data,2));
norm_global_data=zscore(handles.data1d);
handles.sd_global_data=std(handles.data1d);
hist_norm_global_data=histcounts(norm_global_data,-10:0.5:10);
handles.p_norm_global_data=hist_norm_global_data./sum(hist_norm_global_data);
handles.trial_num=size(handles.data,2)/handles.ch_num;
set(handles.trial_num_edit,'String',handles.trial_num);
set(handles.globalmax_txt,'String',['global max:',num2str(globalmax,2)]);
guidata(hObject, handles);

% --- Executes on button press in disp_btn.
function disp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to disp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_disp wf_raw
set(handles.update_txt,'Visible','Off');
handles.Fs=str2num(get(handles.fs_edit,'String'));
handles.trace_length=str2num(get(handles.scanlen_edit,'String'));
handles.swp_no=str2num(get(handles.swp_edit,'String'));
handles.ch_no=str2num(get(handles.ch_edit,'String'));
handles.trial_num=str2num(get(handles.trial_num_edit,'String'));
handles.ch_num=str2num(get(handles.ch_num_edit,'String'));
handles.global=get(handles.global_rbt,'Value');
if  handles.swp_no>0 && handles.swp_no<=handles.trial_num ...
        &&   handles.ch_no>0 && handles.ch_no<=handles.ch_num
    data_disp=handles.data(:,(handles.swp_no-1)*handles.ch_num+handles.ch_no);
    if get(handles.sep_display,'Value')==0
        axes(handles.sig_axes);
    else
        figure;
    end
    plot(1/handles.Fs:1/handles.Fs:handles.trace_length,data_disp,'k');
    xlabel('T');
    axis auto;
    if ~get(handles.autoscalex_rbt,'Value')
        xleft=str2num(get(handles.minx_edit,'String'));
        xright=str2num(get(handles.maxx_edit,'String'));
        xlim([xleft,xright]);
    end
    if ~get(handles.autoscaley_rbt,'Value')
        ybottom=str2num(get(handles.miny_edit,'String'));
        ytop=str2num(get(handles.maxy_edit,'String'));
        ylim([ybottom,ytop]);
    end
    absmax=abs(max(handles.data(:,handles.swp_no+1)));
    set(handles.absmax_txt,'String',['absmax:',num2str(absmax,2)]);
    set(handles.warning_txt,'visible','off');
    set(handles.warning_ch_txt,'visible','off');
    
    handles.thre_sd=str2num(get(handles.thre_edit,'String'));
    if handles.global
        sd_data=handles.sd_global_data;
    else
        sd_data=std(data_disp);
    end
    handles.thre=-handles.thre_sd*sd_data;
    hold on
    hthre=imline(handles.sig_axes,[1/handles.Fs,handles.trace_length],handles.thre*ones(1,2));%,'r');
    
    hold off
    
    axes(handles.dist_axes);
    if handles.global
        p_norm_data=handles.p_norm_global_data;
    else
        norm_data=zscore(data_disp);
        hist_norm_data=histcounts(norm_data,-10:0.5:10);
        p_norm_data=hist_norm_data./sum(hist_norm_data);
    end
    plot(p_norm_data,-9.75:0.5:9.75,'k');
    xlabel('Prob');ylabel('SD');
    hold on
    plot([0,max(p_norm_data)],-handles.thre_sd*ones(1,2),'r');
    hold off
    idx=find(-9.75:0.5:9.75<-handles.thre_sd);
    ylim([-10,10]);
    out_thre=sum(p_norm_data(idx));
    text(0.5*max(p_norm_data),-handles.thre_sd-1, [num2str(out_thre*100,2),'%']);
    
    if get(handles.all_spk_rbt,'Value')
        data_disp=handles.data1d;
    elseif     get(handles.ch_spk,'Value')
        data_disp=[];
        for swp_no=1:handles.trial_num
            data_disp=[data_disp;handles.data(:,(swp_no-1)*handles.ch_num+handles.ch_no)];
        end
    end
    out_idx=find(data_disp<handles.thre);
    diff_idx=out_idx(2:end)-out_idx(1:end-1);
    while ~isempty(find(diff_idx<=handles.Fs/1000))
        out_idx=setdiff(out_idx,out_idx(find(diff_idx<=handles.Fs/1000)+1));
        diff_idx=out_idx(2:end)-out_idx(1:end-1);
    end
    wf_before=15;
    wf_after=30;
    wf_raw=[];
    if get(handles.sep_display,'Value')==0
        axes(handles.spk_axes);
        cla;
    else
        figure
    end
    hold on
    count=0;
    invalid_iwf=[];
    for iwf=1:length(out_idx)
        if out_idx(iwf)-wf_before>=1 && out_idx(iwf)+wf_after<=length(data_disp)
            count=count+1;
            wf_raw(count,:)=data_disp(out_idx(iwf)-wf_before:...
                out_idx(iwf)+wf_after);
            plot(-wf_before/handles.Fs*1000:1/handles.Fs*1000:wf_after/handles.Fs*1000,wf_raw(count,:),'color',0.3*ones(1,3));
        else
            invalid_iwf=[invalid_iwf,iwf];
        end
    end
    
    out_idx=setdiff(out_idx,out_idx(invalid_iwf));
    plot([-wf_before/handles.Fs*1000,wf_after/handles.Fs*1000],[0,0],'k');
    plot([-wf_before/handles.Fs*1000,wf_after/handles.Fs*1000],handles.thre*ones(1,2),'r');
    hold off
else
    if  handles.swp_no>handles.trial_num || handles.swp_no<1
        set(handles.warning_txt,'visible','on');
    end
    if handles.ch_no>handles.ch_num || handles.ch_no<1
        set(handles.warning_ch_txt,'visible','on');
    end
end
handles.disp_on=1;
set(handles.update_txt,'Visible','On');
guidata(hObject, handles);



function ch_num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch_num_edit as text
%        str2double(get(hObject,'String')) returns contents of ch_num_edit as a double


% --- Executes during object creation, after setting all properties.
function ch_num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function ch_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ch_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ch_no=get(handles.ch_slider,'Value');
set(handles.ch_edit,'String',num2str(ch_no));
if handles.disp_on
    disp_btn_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function ch_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ch_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch_edit as text
%        str2double(get(hObject,'String')) returns contents of ch_edit as a double
ch_no=str2num(get(handles.ch_edit,'String'));
set(handles.ch_slider,'Value',ch_no);
if handles.disp_on
    disp_btn_Callback(hObject, eventdata, handles);
end

% --- Executes during object creation, after setting all properties.
function ch_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Init_para(hObject,eventdata,handles,varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preview_data (see VARARGIN)

% Choose default command line output for preview_data
handles.xpn=varargin.xpn;
handles.Fs=varargin.Fs;
handles.ch_num=varargin.ch_num;
% handles.trace_length=varargin{1}.trace_length;
handles.raw=varargin.raw;
handles.num=varargin.num;
handles.ipen=varargin.ipen;
handles.irec=varargin.irec;
handles.iscanlen=varargin.iscanlen;
set(handles.filename_edit,'String',handles.xpn);
set(handles.fs_edit,'String',handles.Fs);
set(handles.ch_num_edit,'String',handles.ch_num);
% set(handles.scanlen_edit,'String',handles.trace_length);
handles.disp_on=0;
% Update handles structure
guidata(hObject, handles);



function thre_edit_Callback(hObject, eventdata, handles)
% hObject    handle to thre_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thre_edit as text
%        str2double(get(hObject,'String')) returns contents of thre_edit as a double


% --- Executes during object creation, after setting all properties.
function thre_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thre_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in global_rbt.
function global_rbt_Callback(hObject, eventdata, handles)
% hObject    handle to global_rbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of global_rbt



function pre_trg_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pre_trg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pre_trg_edit as text
%        str2double(get(hObject,'String')) returns contents of pre_trg_edit as a double


% --- Executes during object creation, after setting all properties.
function pre_trg_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pre_trg_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in all_spk_rbt.
function all_spk_rbt_Callback(hObject, eventdata, handles)
% hObject    handle to all_spk_rbt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of all_spk_rbt


% --- Executes on button press in sep_display.
function sep_display_Callback(hObject, eventdata, handles)
% hObject    handle to sep_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sep_display


% --- Executes on button press in ch_spk.
function ch_spk_Callback(hObject, eventdata, handles)
% hObject    handle to ch_spk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_spk
