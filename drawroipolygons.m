function varargout = drawroipolygons(varargin)
% DRAWROIPOLYGONS MATLAB code for drawroipolygons.fig
%      DRAWROIPOLYGONS, by itself, creates a new DRAWROIPOLYGONS or raises the existing
%      singleton*.
%
%      H = DRAWROIPOLYGONS returns the handle to a new DRAWROIPOLYGONS or the handle to
%      the existing singleton*.
%
%      DRAWROIPOLYGONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWROIPOLYGONS.M with the given input arguments.
%
%      DRAWROIPOLYGONS('Property','Value',...) creates a new DRAWROIPOLYGONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drawroipolygons_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drawroipolygons_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawroipolygons

% Last Modified by GUIDE v2.5 03-Apr-2018 21:11:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @drawroipolygons_OpeningFcn, ...
                   'gui_OutputFcn',  @drawroipolygons_OutputFcn, ...
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


% --- Executes just before drawroipolygons is made visible.
function drawroipolygons_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawroipolygons (see VARARGIN)
addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

%A cell array containing the xy locations to look at and the corresponding
%traps to measure.  First column contains the xy locations. 2nd column
%contains an array with the corresponding traps.
handles.traps = 0;

%The current row of handles.traps that we are looking at
handles.row = 0;

%The current xy location
handles.currxy = 0; 

%The current phase g image sack for the current xy location.  stores image
%the original image values adjusted to double
handles.pgstack = 0; 

%The current phase g image stack for the current xy location. imadjut
%applied
handles.pgadj = 0;

%The number of traps we are looking at
handles.numrows = 0;

%The allowed number of polygons that can be drawn at any time
handles.numcol = 6;

%The number of times
handles.maxtime = 38;

%The specified time.  This changes as we step through the movie
handles.time = 0;

%The prefix for each tif file to be observed
handles.fileprefix = 0;

%The polygon coordinates stored in a cell array.  We allow for 100 polygons
%to be drawn per xy location
%The xy location corresponding to each row matches that in the input file.
handles.polycoord = 0;

%Handles to polygons drawn on the current image.  This is a 1x100 cell
%array. 
handles.polyhand = 0;

%The mask for the traps being observed in the current xy location


%handle to the current phase g image
handles.curradjimage = 0;


%current column in the polyhand array. This is reset to 1 when we go to a
%new xy location.  
%This is different from the column in the cell array that holds the
%coordinates of the different polygons
handles.col = 0; 

%The coordinates of all traps in the current image
handles.trapcoord = 0;  

%Stores the coordinates of the drawn polygons
handles.result = 0;


% Choose default command line output for drawroipolygons
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drawroipolygons wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drawroipolygons_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%Move to the previous trap in the traplist
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prefix = strcat('./tifs/',handles.fileprefix);
filename = strcat(prefix,'02',' - Alignedt02xy1c1.tif')
if exist(filename,'file') ~= 2
    'files do not exist'
    set(handles.text4,'String','files with given prefix do not exist');
    guidata(hObject,handles);
    return
end
set(handles.text4,'String','Viewing files');
if handles.row <= 1
    %not sure what to do here
else
   nextrow = handles.row - 1;
   handles = updatexy(nextrow,hObject,handles);
end
guidata(hObject,handles);


%Move to the next trap in the trap list
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prefix = strcat('./tifs/',handles.fileprefix);
filename = strcat(prefix,'02',' - Alignedt02xy1c1.tif')
if exist(filename,'file') ~= 2
    'files do not exist'
    set(handles.text4,'String','files with given prefix do not exist');
    guidata(hObject,handles);
    return
end
set(handles.text4,'String','Viewing files');
if handles.row == handles.numrows
    %not sure what to do here
elseif handles.row < handles.numrows
   nextrow = handles.row + 1;
   handles = updatexy(nextrow,hObject,handles);
end
guidata(hObject,handles);


function handles = updatexy(nextrow, hObject, handles)
   xy = handles.traps(nextrow,1);
   handles.row = nextrow;
   handles.col = 0;
   
   prefix = strcat('./tifs/',handles.fileprefix);
   
   if xy ~= handles.currxy 
       nextxy = num2strwithzeros(xy);
       for i = 1:handles.maxtime
            %The 3d array containing the phase g measurements
            tstring = num2strwithzeros(i);
            filename = strcat(prefix,nextxy,' - Alignedt',tstring,'xy1c1.tif');
            image = im2double(imread(filename));
            handles.pgstack(:,:,i) = image;
            handles.pgadj(:,:,i) = imadjust(image)
        end
   end
   
   %Set the time to 1, display time and image
   handles.currxy = xy;
   handles.time = 1;
   handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
   traptxt = sprintf('Current XY:\n%d,',xy);
   set(handles.text2,'String',traptxt);
   handles = updatetimetraptxt(hObject,handles);
   
   filename  = strcat('./masks/maskal_xy',num2str(xy),'.tif');
   handles.trapmask = imread(filename);
   s = regionprops(handles.trapmask,'centroid')
   centroids = cat(1,s.Centroid);
   orderedindices = orderrois(centroids);
   handles.trapcoord = centroids(orderedindices,:) 
   guidata(hObject,handles)

%Go to the previous time
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prefix = strcat('./tifs/',handles.fileprefix);
filename = strcat(prefix,'02',' - Alignedt02xy1c1.tif')
if exist(filename,'file') ~= 2
    'files do not exist'
    set(handles.text4,'String','files with given prefix do not exist');
    guidata(hObject,handles);
    return
end
L = get(gca,{'xlim','ylim'})

if handles.time > 1
    handles.time = handles.time - 1;
    handles.col=0;
    handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
    zoom reset
    set(gca,{'xlim','ylim'},L)
    handles = updatetimetraptxt(hObject,handles);

    guidata(hObject,handles)
end


%Go to the next time;
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prefix = strcat('./tifs/',handles.fileprefix);
filename = strcat(prefix,'02',' - Alignedt02xy1c1.tif')
if exist(filename,'file') ~= 2
    'files do not exist'
    set(handles.text4,'String','files with given prefix do not exist');
    guidata(hObject,handles);
    return
end
L = get(gca,{'xlim','ylim'})

if handles.time < handles.maxtime
    handles.time = handles.time + 1;
    handles.col=0;
  
    handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
    zoom reset
    set(gca,{'xlim','ylim'},L);
    handles = updatetimetraptxt(hObject,handles);

    guidata(hObject,handles);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
traps = csvread(get(handles.edit2,'String'),1,0);
handles.numrows = size(traps,1);
handles.traps = traps;
handles.row = 0; 
handles.fileprefix = get(handles.edit1,'String');
handles.time = 1;
handles.polyhand = cell(1,handles.numcol);
handles.polycoord = cell(1,handles.numcol);
handles.pgstack = zeros(512,512,handles.maxtime)
handles.pgadj = zeros(512,512,handles.maxtime);
handles.result = cell(size(traps,1),40);
guidata(hObject,handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Saves the coordinates of the currently drawn polygons.
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validpolyhands = getvalidpolyhand(handles.polyhand);
coords = cellfun(@getPosition,validpolyhands,'un',0);
handles.polycoord = coords;
handles.result{handles.row,handles.time} = coords;
handles.result(1:10,:)
guidata(hObject,handles);



%Draws the previously saved poly coordinates on the current axes
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:size(handles.polycoord,2)
   handles.polyhand{i} = impoly(gca,handles.polycoord{1,i}); 
end
handles.col = size(handles.polycoord,2)+1;
guidata(hObject,handles);

%Allows a polygon to be drawn on the current image
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.col >= handles.numcol
    set(handles.text4,'String','Cannot draw any more polygons');
    guidata(hObject,handles);
    return;
end
handles.col = handles.col + 1;
handles.polyhand{1,handles.col} = impoly(gca);
guidata(hObject,handles);


function handles = updatetimetraptxt(hObject,handles)
trap = handles.traps(handles.row,2);
firstobstime = handles.traps(handles.row,3);
lastobstime = handles.traps(handles.row,4);

traptxt = sprintf('%d,',trap);
traptxt = sprintf(strcat('Current trap:\n',traptxt));
set(handles.text5,'String',traptxt);

if (handles.time >= firstobstime) & (handles.time <=lastobstime)
    set(handles.text6,'String', sprintf('Observable? \n Yes'));
else
    set(handles.text6,'String', sprintf('Observable? \n No'));
end

timetxt = sprintf('Current time:\n%d',handles.time);
set(handles.text3,'String',timetxt);
guidata(hObject, handles);


%Overlays the roi corresponding to the trapped cells of interest in the
%current xy frame
%Also draws a circle centered at each of the trap roi centers
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
green = cat(3, zeros(size(handles.trapmask)),ones(size(handles.trapmask)),zeros(size(handles.trapmask))); 
hold on;
h = imshow(green);
set(h,'AlphaData',handles.trapmask*0.25);
viscircles(handles.trapcoord,repmat(15,size(handles.trapcoord,1),1));
hold off;


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nearbypoly = handles.result;
save(get(handles.edit3,'String'),'nearbypoly');



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%allow the results to be loaded from a mat file in the current directory
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load(get(handles.edit4,'String'))
handles.result = nearbypoly;
guidata(hObject, handles);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
