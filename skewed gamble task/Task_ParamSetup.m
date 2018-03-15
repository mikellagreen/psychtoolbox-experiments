function params = Task_ParamSetup()

% Set randomization seed 
% ----------------------------------------------------------------------- %
params.random_seed = RandStream.create('mt19937ar','seed',sum(100*clock));
RandStream.setGlobalStream(params.random_seed);

% Screen information
% ----------------------------------------------------------------------- %
params.screen.viewdist = 65; 			% 65 cm = 25.6 inches; Tobii best viewing distance
params.screen.scrdiag  = 43; 			% 43 cm for an 17-inch monitor; 34 cm for 13.3-inch
params.screen.id = max(Screen('Screens')); % 0th screen is main screen; max(Screen('Screens')) for external
%params.screen.id = 1; % 0th screen is main screen; max(Screen('Screens')) for external

% Response buttons - you can always add more below
% I have placed a few repreentative buttons here, including the 1 & 0's 
% that I noticed you used in your task with PsychoPy
% ----------------------------------------------------------------------- %
KbName('UnifyKeyNames'); % make keyboard mapping the same on all PTB-supported operating systems (OSX, Windows, Linux)

params.keyboard.space = KbName('space');
params.keyboard.f  = KbName('F');
params.keyboard.j  = KbName('J');
params.keyboard.t  = KbName('R');
params.keyboard.q  = KbName('Q');
params.keyboard.t  = KbName('T');
params.keyboard.x  = KbName('X');
params.keyboard.key1  = KbName('1!'); % KbName('1') maps to the numpad, instead of the numbers on top of text rows
params.keyboard.key0  = KbName('0)');
if isequal(computer, 'MACI64') || isequal (computer, 'MACI')
    params.keyboard.esc = KbName('escape');
else
    params.keyboard.esc = KbName('ESCAPE');
end

% Timing parameters
% Here are some timing parameters - change as you see fit.
% Don't have to have all of these categories of timing, but some
% presentative timing were included as example.
% ----------------------------------------------------------------------- %
params.timing.fix 		= 1;		% duration of fixation cross in s
params.timing.decision	= 10;		% maximum duration of decision phase in s
params.timing.choice	= 10;		% maximum duration of choice phase in s
params.timing.feedback 	= 1;		% duration of feedback frame in s

% Color parameters
% Colors are defined by RGB values, maximum value of 255.
% ----------------------------------------------------------------------- %
params.color.white 	 = WhiteIndex(params.screen.id); % dev = device variables
params.color.black 	 = BlackIndex(params.screen.id);
params.color.green 	 = [0 153 0];
params.color.red 	 = [255 0 0];
params.color.blue	 = [85 141 213];
params.color.bgcolor = params.color.black;
   
% Font parameters
% ----------------------------------------------------------------------- %
params.text.font    = 'Arial';	% used font throughout the experiment
params.text.color 	= params.color.white;
params.text.trialsize = 40;			% stimulus text size
params.text.instrsize = 24;			% instruction text size
      
% Fixation parameters
% ----------------------------------------------------------------------- %
params.fix.color     = params.color.white;	% fixation cross color = white
params.fix.stroke    = 4;   		% fixation cross stroke thickness in pixel
params.fix.visang    = 0.5;
params.fix.textSize  = 50;

end