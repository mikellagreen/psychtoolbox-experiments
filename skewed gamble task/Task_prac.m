function Task_prac(subid)
% This version of ITC task has responses where the position of the fill in
% is. 


% Define filename of result file:
datafilename = strcat('SkewExp_',num2str(subid),'.txt');
fid = fopen(datafilename, 'wt');

try % to make sure if the program fails, still save something
    
    % ----------------------------------------------------------------------- %
    % Save directory
    % ----------------------------------------------------------------------- %
        if ~exist(fullfile(pwd,'Data Outputs'),'dir')
            mkdir(fullfile(pwd,'Data Outputs'));
        end

        if ~exist(fullfile(pwd,'Data Outputs',subid),'dir') %if directory doesn't exists
            mkdir(fullfile(pwd,'Data Outputs',subid));
        else
            if size(dir(fullfile(pwd,'Data Outputs',subid)),1) > 2 %if there are already files there (the 2 is accounting for '.' and '..' handles)
                error('Subject ID has already been used before. Please use a different ID');
            end
        end
        
     
    % ----------------------------------------------------------------------- %
    % Initialize parameters & Psychtoolbox
    % ----------------------------------------------------------------------- %
        params = Task_ParamSetup();
        
        % trial sizes should be even for equal randomization of
        % types/flips/etc

        % starting Psychtoolbox
        ListenChar(2); %allows you to quit more easily
        Screen('Preference','SkipSyncTests',1);
        [S.wID, S.wSize]=Screen('OpenWindow',params.screen.id,params.color.bgcolor);
        Screen('TextFont',S.wID,params.text.font);
        Screen('TextColor',S.wID,params.text.color);
        Screen('TextStyle',S.wID,0); %set font style to normal (0), not bold (1)

        HideCursor;
        S.centerX = S.wSize(3)/2;
        S.centerY = S.wSize(4)/2;
        S.textColor = params.color.white;
        S.screenColor = params.color.bgcolor;
        
        %Dummy calls to GetSecs, WaitSecs, KbCheck to make sure they are
        %ready when we need them. 
        KbCheck;
        WaitSecs(0.1);
        GetSecs;
        
        

    % ----------------------------------------------------------------------- %
    % Initialize other parameters
    % ----------------------------------------------------------------------- %
        frame=[0 0 250 150];
        frame_L=CenterRectOnPoint(frame,S.centerX-450,175);
        frame_R=CenterRectOnPoint(frame,S.centerX+450,175);
        keys = params.keyboard;

        data.SubID = subid;
        data.TestDate = date;
        data.Design.FrameL = frame_L;
        data.Design.FrameR = frame_R;
        data.Design.FrameSize = frame;
        data.Design.Parameters = params;
        
        %Fixation parameters
        [xCenter, yCenter] = RectCenter(S.wSize);
        ifi = Screen('GetFlipInterval', S.wID);
        Screen('BlendFunction', S.wID, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
        fixCrossDimPix = 20;
        lineWidthPix = 2;
        xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
        yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
        allCoords = [xCoords; yCoords];
      


    % ----------------------------------------------------------------------- %
    % Get Start Signal for Eye Tracking (when experimenter press "t")
    % ----------------------------------------------------------------------- %
        Screen('TextSize',S.wID,params.text.instrsize);
        message = 'Please wait for experimenter to start the study.\n\n Press t to continue (remove "Press t..." before you run your study...Participants should not know what key to progress the study :])';
        display(message);
        DrawFormattedText(S.wID,message,'center','center',S.textColor,100,[], [], 1.6);
        Screen(S.wID,'Flip');
        while 1
            [~, ~, key] = KbCheck;
            if find(key) == keys.t
                data.Timing.StartExperiment = GetSecs; % time when study starts - syncs with when ET recording starts
                break;
            end
        end
        
    % ----------------------------------------------------------------------- %
    % Beginning instructions
    % ----------------------------------------------------------------------- %
        data.study_start = GetSecs;
        data.Instruct.Start = Task_Instructions('BeginInstruct',S,params,keys);
        
        % Instruct & 8 practice probs
        display('Starting Fill-In Instructions');
        data.Instruct.MyTask = Task_Instructions('MyTask',S,params,keys);
        
     

    % ----------------------------------------------------------------------- %
    % Task - integrate this into for-loop or make another script for clean
    % protocol/streamlining
    % ----------------------------------------------------------------------- %
       % Read list of conditions and stimuli
       
        [ prob1, prob1pos, prob2, prob2pos, mag1, mag1pos, mag2, mag2pos ] = textread('trialslist.txt', '%s %s %s %s %s %s %s %s', 'delimiter', ';');
        
        % Randomize order of trials
        ntrials=36;          % get number of trials
        random=randperm(ntrials);  % randperm() is a matlab function
        probL=prob1(random);       % need to randomize through the list
        probLpos=prob1pos(random); %
        probR=prob2(random);       %
        probRpos=prob2pos(random); %
        magL=mag1(random);         %
        magLpos=mag1pos(random);   %
        magR=mag2(random);         %
        magRpos=mag2pos(random);   %
        
        for trial = 1:ntrials
            duration=2.000;
            
            Screen('DrawLines', S.wID, allCoords, lineWidthPix, S.textColor, [xCenter yCenter], 2);
            Screen('Flip', S.wID);
            WaitSecs(0.500);

        % Displaying the amount stimuli
        % ------------------------------------------------------------------- %
            
            v1 = char(magL(trial));
            v1pos = char(magLpos(trial));
            v2 = char(magR(trial));
            v2pos = char(magRpos(trial));
            
            [textloc,value1,value2] = Determine_XY(v1,v2,v1pos,v2pos,params.text.trialsize,S);
                
            DrawFormattedText(S.wID,value1,textloc.v1.x,textloc.v1.y,S.textColor);
            DrawFormattedText(S.wID,value2,textloc.v2.x,textloc.v2.y,S.textColor);    

        % Displaying the probability stimuli
        % ------------------------------------------------------------------- %
            imgstim1 = imread(char(probL(trial)));
            imgstim2 = imread(char(probR(trial))); 
            img1pos = char(probLpos(trial));
            img2pos = char(probRpos(trial));
          
            
            [pos,imageDisplay] = Determine_imgPos(imgstim1, imgstim2, img1pos, img2pos, S);
            Screen('DrawTexture', S.wID, imageDisplay.stim1, [], pos.stim1);
            Screen('DrawTexture', S.wID, imageDisplay.stim2, [], pos.stim2);
    
    
            [VBLTimestamp startrt]=Screen('Flip',S.wID); % show stimuli on screen and record stimulus onset time in "startrt"
            
            while (GetSecs - startrt)<=duration
                [KeyIsDown, endrt, key] = KbCheck;
                WaitSecs(0.001);
                if find(key) == keys.key1
                    resp = 1;
                    resp_text = 'accept';
                    break;
                elseif find(key) == keys.key0
                    resp = 0;
                    resp_text = 'reject';
                    break;
                end
            end
            rt = round(1000*(endrt-startrt));
            
            fprintf(fid,'%i\n',data.SubID);
                
        end
        
      
        % Drawing box around the stimuli so you can see exactly the location.
        % You can always remove these lines to take away the boxes
        % ------------------------------------------------------------------- %
        %Screen('FrameRect',S.wID,S.textColor,frame_L,3);
        %Screen('FrameRect',S.wID,S.textColor,frame_R,3);


    % ----------------------------------------------------------------------- %
    % Finish Study!
    % ----------------------------------------------------------------------- %
    Screen('TextSize',S.wID,params.text.instrsize);
    message = 'You have completed the study!\n\nThank you for your participation!';
    display(message);
    DrawFormattedText(S.wID,message,'center','center',S.textColor,90,[], [], 1.6);
    Screen(S.wID,'Flip');
    pause(5);
        
    save(datafilename);
    sca;
    ShowCursor;
    fclose('all');
        
    return;
catch 
   
    error('Study quit unexpectedly');
    keyboard;
    
    sca;
    ShowCursor;
    fclose('all');
end
end


function [textloc,value1,value2] = Determine_XY(v1,v2,v1pos,v2pos,textsize,S)

% Function to determine location in which to place the stimuli on left or
% right frame set up on screen.

Screen('TextSize',S.wID,textsize);
vnum1 = str2num(v1);
vnum2 = str2num(v2);


% ----------------------------------------------------------------------- %
% Set text location based on width of text
% ----------------------------------------------------------------------- %
if vnum1 > 0
    value1 = ['$' num2str(vnum1,'%5.2f')];
    textwidth_v1 = Screen(S.wID,'TextBounds', v1);
else
    value1 = ['-$' num2str(abs(vnum1),'%5.2f')];
    textwidth_v1 = Screen(S.wID,'TextBounds', v1);
end

if vnum2 > 0
    value2 = ['$' num2str(vnum2,'%5.2f')];
    textwidth_v2 = Screen(S.wID,'TextBounds', v2);
else
    value2 = ['-$' num2str(abs(vnum2),'%5.2f')];
    textwidth_v2 = Screen(S.wID,'TextBounds', v2);
end

if string(v1pos) == "(-1,-1)"
   textloc.v1.x = S.centerX-450-(textwidth_v1(3)/2); 
   textloc.v1.y = 800-(textwidth_v1(4)/2);
else
   textloc.v1.x = S.centerX-450-(textwidth_v1(3)/2); 
   textloc.v1.y = 175-(textwidth_v1(4)/2);
end

if string(v2pos) == "(1,-1)"
   textloc.v2.x = S.centerX+450-(textwidth_v2(3)/2);
   textloc.v2.y = 800-(textwidth_v2(4)/2);
else
   textloc.v2.x = S.centerX+450-(textwidth_v2(3)/2);
   textloc.v2.y = 175-(textwidth_v2(4)/2);
end
end

function [pos,imageDisplay] = Determine_imgPos(imgstim1, imgstim2, img1pos, img2pos, S)
imageSize.stim1 = size(imgstim1);
imageSize.stim2 = size(imgstim2);

imageDisplay.stim1 = Screen('MakeTexture', S.wID, imgstim1);
imageDisplay.stim2 = Screen('MakeTexture', S.wID, imgstim2);

if string(img1pos) == "(-1,-1)"
    pos.stim1 = [S.centerX-450-(imageSize.stim1(2)/2), ...
                800-(imageSize.stim1(1)/2), ...
                S.centerX-450+(imageSize.stim1(2)/2), ...
                800+(imageSize.stim1(1)/2)];
else
    pos.stim1 = [S.centerX-450-(imageSize.stim1(2)/2), ...
                175-(imageSize.stim1(1)/2), ...
                S.centerX-450+(imageSize.stim1(2)/2), ...
                175+(imageSize.stim1(1)/2)];
end

if string(img2pos) == "(1,-1)"
    pos.stim2 = [S.centerX+450-(imageSize.stim2(2)/2),...
                800-(imageSize.stim2(1)/2),...
                S.centerX+450+(imageSize.stim2(2)/2),...
                800+(imageSize.stim2(1)/2)];
else
    pos.stim2 = [S.centerX+450-(imageSize.stim2(2)/2),...
                175-(imageSize.stim2(1)/2),...
                S.centerX+450+(imageSize.stim2(2)/2),...
                175+(imageSize.stim2(1)/2)];
end
end
    
            
    



