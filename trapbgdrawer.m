function varargout = trapbgdrawer(varargin)
% TRAPBGDRAWER MATLAB code for trapbgdrawer.fig
%      TRAPBGDRAWER, by itself, creates a new TRAPBGDRAWER or raises the existing
%      singleton*.
%
%      H = TRAPBGDRAWER returns the handle to a new TRAPBGDRAWER or the handle to
%      the existing singleton*.
%
%      TRAPBGDRAWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAPBGDRAWER.M with the given input arguments.
%
%      TRAPBGDRAWER('Property','Value',...) creates a new TRAPBGDRAWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trapbgdrawer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trapbgdrawer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trapbgdrawer

% Last Modified by GUIDE v2.5 16-Apr-2018 12:31:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trapbgdrawer_OpeningFcn, ...
                   'gui_OutputFcn',  @trapbgdrawer_OutputFcn, ...
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


% --- Executes just before trapbgdrawer is made visible.
function trapbgdrawer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trapbgdrawer (see VARARGIN)
addpath('/Users/thomasyoung/Dropbox/templates/matlab_imageanalysis')

%A cell array containing the xy locations to look at and the corresponding
%traps to measure.  First column contains the xy locations. 2nd column
%contains an array with the corresponding traps.
handles.xys = 0;

%The current row of handles.xy that we are looking at
handles.row = 0;

%The current phase g image sack for the current xy location.  stores image
%the original image values adjusted to double
handles.pgstack = 0; 

%The current phase g image stack for the current xy location. imadjut
%applied
handles.pgadj = 0;

%The number of xy locations we are looking at
handles.numrows = 0;

%The allowed number of polygons per xy location
handles.numcol = 40;

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

%Handles to background polygons drawn on the current image
handles.bgpolyhand = 0;

%handle to the current phase g image
handles.curradjimage = 0;

%Handles to the trap centered rectangles drawn on the current image
%These are the local areas around each cell  Everying in these regions that
%has not been circled is considered background
handles.localrect = 0;


%current column in the polyhand array. This is reset to 1 when we go to a
%new xy location.  
handles.col = 0; 

%current columns in the bg polyhand array.  The polygons in this array
%correspond to background regions
handles.bgcol = 0; 

%The rectangle coordinates with respect to a centroid
handles.rect = 0;

%the orientation of traps;
handles.trapdir = 'up';

%The rectangle coordinates with respect to a centroid for up-facing traps
handles.uprect = 0;

%The rectangle coordinates with respect to a centroid for down-facing traps
handles.downrect = 0;


%Upward trap polygon coordinates with respect to a centroid
handles.uptrap = 0;

%Downward trap polygon coordinates with respect to a centroid
handles.downtrap = 0; 

%The coordinates of all traps in the current image
handles.trapcoord = 0;  


%Handles to the drawn rects. Allows user to adjust their widths
handles.drawnrect = 0;

%handles to drawn rect coord. saved whenever the rectangle mask is exported
handles.drawnrectcoord = 0;

%The mask for the current xy and trap
handles.automask = zeros(512,512);

% Choose default command line output for trapbgdrawer
handles.output = hObject;



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trapbgdrawer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trapbgdrawer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
   xy = handles.xys{nextrow,1};
   handles.row = nextrow;
   handles.col = 0;
   handles.bgcol = 0;
   %handles.polyhand = cell(1,handles.numcol);
   %handles.bgpolyhand = cell(1,handles.numcol);
   
   prefix = strcat('./tifs/',handles.fileprefix);
   nextxy = num2strwithzeros(xy);
   for i = 1:handles.maxtime
        %The 3d array containing the phase g measurements
        tstring = num2strwithzeros(i);
        filename = strcat(prefix,nextxy,' - Alignedt',tstring,'xy1c1.tif');
        image = im2double(imread(filename));
        handles.pgstack(:,:,i) = image;
        handles.pgadj(:,:,i) = imadjust(image)
    end
   
   %Set the time to 1, display time and image
   handles.time = 1;
   handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
   traptxt = sprintf('Current XY:\n%d,',xy);
   set(handles.text2,'String',traptxt);
   handles = updatetimetraptxt(hObject,handles);
   
   filename  = strcat('./masks/maskal_xy',num2str(xy),'.tif');
   trapmask = imread(filename);
   s = regionprops(trapmask,'centroid')
   centroids = cat(1,s.Centroid);
   orderedindices = orderrois(centroids);
   handles.trapcoord = centroids(orderedindices,:) 
guidata(hObject,handles)
    


function handles = updatetimetraptxt(hObject,handles)
   traps = handles.xys{handles.row,2};
   firstobstime = handles.xys{handles.row,3};
   lastobstime = handles.xys{handles.row,4};
   
   traptxt = sprintf('%d,',traps);
   traptxt = sprintf(strcat('Current trap:\n',traptxt));
   set(handles.text3,'String',traptxt);
   
   traptxt = sprintf('%d,',traps(firstobstime<=handles.time & lastobstime>=handles.time));
   traptxt = sprintf(strcat('Observable trap:\n',traptxt));
   set(handles.text8,'String',traptxt);
   
   timetxt = sprintf('Current time:\n%d',handles.time)
   set(handles.text5,'String',timetxt);
guidata(hObject, handles)
    

%Allows the user to draw a rectangle around the first trap.  
%The coordinates of the upper left hand corner of the rectangle with
%respect to the trap are saved.
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rectangle = imrect(gca);
rectpos = getPosition(rectangle);
rectpos(1:2) = rectpos(1:2) - handles.trapcoord(1,:);
handles.rect = rectpos;
handles.trapdir
size(handles.trapdir)
if strcmp(handles.trapdir,'up')
    handles.uprect = handles.rect;
elseif strcmp(handles.trapdir,'down')
    handles.downrect = handles.rect;
end
guidata(hObject,handles);

%Checks to see whether there is a rect mask for the first time point. If
%so, draws the rectangles contained in this mask.  Otherwise draws
%rectangles using the bounding rectangle defined previously and specified
%widths.
%draws a larger rectangle around each trap of interest.
%The larger rectangle  is larger on each side by the amount width
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
width = str2num(get(handles.edit1,'String'))
traps = handles.xys{handles.row,2}
todrawcentroids = handles.trapcoord(traps,:)
handles.drawnrect = cell(1,size(traps,1));
if strcmp(handles.trapdir,'up')
    handles.rect = handles.uprect;
elseif strcmp(handles.trapdir,'down')
    handles.rect = handles.downrect;
end
for i = 1:size(todrawcentroids,1)
   xycoord = todrawcentroids(i,:) + handles.rect(1:2) - width*ones(1,2);
   wh = handles.rect(3:4)+2*width*ones(1,2);
   handles.drawnrect{i} = imrect(gca,[xycoord,wh]);
end
guidata(hObject,handles);



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


%Drawing polygons on the current figure and storing handles in
%handles.polyhand
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
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


%Saves the union of the currently drawn polygons and the automatically
%detected mask
%Save the coordinates of the current drawn polygon
%Also saves a mask corresponding to the union of the polygons drawn on the
%current image
% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validpolyhands = getvalidpolyhand(handles.polyhand);
validbgpolyhands = getvalidpolyhand(handles.bgpolyhand);
outfn = strcat(get(handles.edit5,'String'),'notbg_t',num2str(handles.time),'xy',num2str(handles.xys{handles.row,1}),'.tif');
polymask = polyhandlestomask(validpolyhands,handles.curradjimage);
bgpolymask = polyhandlestomask(validbgpolyhands,handles.curradjimage);
combinedmask = handles.automask;
if size(polymask,1) ~= 0
    combinedmask = combinedmask | polymask;
end
if size(bgpolymask,1) ~= 0 
    combinedmask = ~bgpolymask & combinedmask;
end

imwrite(combinedmask,outfn);
%coords = cellfun(@getPosition,validpolyhands,'un',0);
%handles.polycoord(handles.row,:) = cell(1,handles.numcol);
%handles.polycoord(handles.row,1:size(coords,2))=coords;
%handles.polycoord
handles.automask = zeros(512,512);
guidata(hObject,handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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

%Reading in the traps to look at
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
traps = csvread(get(handles.edit4,'String'),1,0);
xys = unique(traps(:,1));
numxys = size(xys,1);
handles.xys = cell(numxys,4)
for i = 1:numxys
    currxy = xys(i,1);
    handles.xys{i,1} = currxy
    handles.xys{i,2} = traps(traps(:,1)==currxy,2)
    handles.xys{i,3} = traps(traps(:,1)==currxy,3)
    handles.xys{i,4} = traps(traps(:,1)==currxy,4)
end
handles.numrows = size(xys,1);
handles.fileprefix = get(handles.edit2,'String');
handles.time = 1;
handles.polyhand = cell(1,handles.numcol);
handles.bgpolyhand = cell(1,handles.numcol);
handles.polycoord = cell(numxys,handles.numcol);
handles.pgstack = zeros(512,512,handles.maxtime)
handles.pgadj = zeros(512,512,handles.maxtime);
guidata(hObject,handles);


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

%Allows user to draw an upward trap on the first trap and determine its
%coordinates as an offset
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trappoly = impoly(gca);
polycoord = getPosition(trappoly);
if strcmp(handles.trapdir,'up')
    handles.uptrap = polycoord-repmat(handles.trapcoord(1,:),size(polycoord,1),1)
elseif strcmp(handles.trapdir,'down')
    handles.downtrap = polycoord-repmat(handles.trapcoord(1,:),size(polycoord,1),1)
end
guidata(hObject,handles);



%Draws the upward trap at each of the specified positions
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
coordtodraw = handles.trapcoord(handles.xys{handles.row,2},:);
trap = 0;
if strcmp(handles.trapdir,'up')
    trap = handles.uptrap;
elseif strcmp(handles.trapdir,'down')
    trap = handles.downtrap;
end
for i = 1:size(coordtodraw,1)
    newcoord = trap + repmat(coordtodraw(i,:),size(trap,1),1)
    handles.col = handles.col + 1;
    handles.polyhand{1,handles.col} = impoly(gca,newcoord);
end
guidata(hObject,handles);


%Saves a .mat file containing all the polygon coordinate information
%rows correspond to handles.xys
%Also saves the corresponding xy locations as a csv file.  
%Saves a mask containing a local region around each trap of interest.  
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nonbgpolycoord = handles.polycoord;
save('nonbgpolycoord.mat','nonbgpolycoord');


%Allows the user to save a mask corresponding to the positions of the drawn
%rectangles in handles.drawnrect.
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%save a tif file containing the mask with combined rectangles
outfn = strcat(get(handles.edit5,'String'),'/rect_t',num2str(handles.time),'xy',num2str(handles.xys{handles.row,1}),'.tif');
imwrite(polyhandlestomask(handles.drawnrect,handles.curradjimage),outfn);
handles.drawnrectcoord = cell(size(handles.drawnrect))
handles.drawnrect = getvalidpolyhand(handles.drawnrect)
for i = 1:size(handles.drawnrect,2)
   rectangle('Position',getPosition(handles.drawnrect{i})); 
   handles.drawnrectcoord{i} = getPosition(handles.drawnrect{i});
   getPosition(handles.drawnrect{i})
   delete(handles.drawnrect{i});
end
guidata(hObject,handles);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'up'
        handles.trapdir = 'up';
    case 'down'
        handles.trapdir = 'down';
end
guidata(hObject,handles);



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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Steps to the next time and the current location
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 prefix = strcat('./tifs/',handles.fileprefix);
    filename = strcat(prefix,'02',' - Alignedt02xy1c1.tif')
    if exist(filename,'file') ~= 2
        'files do not exist'
        set(handles.text5,'String','files with given prefix do not exist');
        guidata(hObject,handles);
        return
    end
    L = get(gca,{'xlim','ylim'})
    
    if handles.time < handles.maxtime
        handles.time = handles.time + 1;
        handles.col=0;
        handles.bgcol=0;
        %handles.polyhand = cell(1,handles.numcol);
        
        handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
        zoom reset
        set(gca,{'xlim','ylim'},L)
        handles = updatetimetraptxt(hObject,handles);

        guidata(hObject,handles)
    end

    
%Step to the previous time at the current xy location    
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 prefix = strcat('./tifs/',handles.fileprefix);
    filename = strcat(prefix,'02',' - Alignedt02xy1c1.tif')
    if exist(filename,'file') ~= 2
        'files do not exist'
        set(handles.text5,'String','files with given prefix do not exist');
        guidata(hObject,handles);
        return
    end
    L = get(gca,{'xlim','ylim'})
    
    if handles.time > 1
        handles.time = handles.time - 1;
        handles.col=0;
        handles.bgcol=0;
        %handles.polyhand = cell(1,handles.numcol);
        
        handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
        zoom reset
        set(gca,{'xlim','ylim'},L)
        handles = updatetimetraptxt(hObject,handles);

        guidata(hObject,handles)
    end

    
%Computes an entropy based thresholding to identify regions that are not background    
% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
entropyco = str2num(get(handles.edit6,'String'));
sesize = str2num(get(handles.edit7,'String'));
nhoodsize = str2num(get(handles.edit8,'String'));
handles.automask = entropymask(handles.pgstack(:,:,handles.time),nhoodsize,entropyco,sesize);
[B,L] = bwboundaries(handles.automask,'holes');
%imshow(label2rgb(L, @jet, [.5 .5 .5]));
%imshow(imad)
green = cat(3, zeros(size(handles.automask)),ones(size(handles.automask)),zeros(size(handles.automask))); 
hold on;
h = imshow(green);
set(h,'AlphaData',handles.automask*0.25);
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2)
end
hold off;
guidata(hObject,handles)

%Draws the rectangles based on the coordinates that were previously saved
%when the last background mask was drawn
% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i = 1:size(handles.drawnrect,2)
    handles.drawnrectcoord{i}
    handles.drawnrect{i} = imrect(gca,handles.drawnrectcoord{i});
end
guidata(hObject,handles)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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

%Allows the user to draw polygons to specify background regions
% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.bgcol >= handles.numcol
    set(handles.text4,'String','Cannot draw any more bg polygons');
    guidata(hObject,handles);
    return;
end
handles.bgcol = handles.bgcol + 1;
handles.bgpolyhand{1,handles.bgcol} = impoly(gca);
setColor(handles.bgpolyhand{1,handles.bgcol},'r');
guidata(hObject,handles);

%Jump to the image for the current xy location at the specified time.  The
%time is specified in the edit box edit3
% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = str2num(get(handles.edit3,'String'));
if (time <= handles.maxtime) & (time >=1)
    L = get(gca,{'xlim','ylim'})
    handles.time = time;
    handles.col=0;
    handles.bgcol=0;
    %handles.polyhand = cell(1,handles.numcol);
    handles.curradjimage = imshow(handles.pgadj(:,:,handles.time));
    zoom reset
    set(gca,{'xlim','ylim'},L)
    handles = updatetimetraptxt(hObject,handles);
    guidata(hObject,handles);
end

%Draws the rectangles currently on the image.  Does not save a mask
% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.drawnrectcoord = cell(size(handles.drawnrect))
handles.drawnrect = getvalidpolyhand(handles.drawnrect)
for i = 1:size(handles.drawnrect,2)
   rectangle('Position',getPosition(handles.drawnrect{i})); 
   handles.drawnrectcoord{i} = getPosition(handles.drawnrect{i});
%    getPosition(handles.drawnrect{i})
   delete(handles.drawnrect{i});
end
guidata(hObject,handles);


% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rectfn = strcat(get(handles.edit5,'String'),'rect_t1xy',num2str(handles.xys{handles.row,1}),'.tif');
handles.time
if exist(rectfn,'file') == 2
    rectmask = imread(rectfn);
    rectcoord = regionprops(rectmask,'BoundingBox');
    handles.drawnrect = cell(1,size(rectcoord,2));
    for i = 1:size(rectcoord,1);
        handles.drawnrect{i} = imrect(gca,rectcoord(i).BoundingBox);
    end
end
guidata(hObject,handles);


%Allows interactive placement and drawing of a rectangle containing non bgpixels
% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.col >= handles.numcol
    set(handles.text4,'String','Cannot draw any more polygons');
    guidata(hObject,handles);
    return;
end
handles.col = handles.col + 1;
handles.polyhand{1,handles.col} = imrect(gca);
guidata(hObject,handles);


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.bgcol >= handles.numcol
    set(handles.text4,'String','Cannot draw any more polygons');
    guidata(hObject,handles);
    return;
end
handles.bgcol = handles.bgcol + 1;
handles.bgpolyhand{1,handles.bgcol} = imrect(gca);
guidata(hObject,handles);



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
