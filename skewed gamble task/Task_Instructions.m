function instruct = Task_Instructions(type,S,params,keys)

timing.StartInstruct = GetSecs;

Screen('TextColor',S.wID,params.text.color);
Screen('TextSize',S.wID,params.text.instrsize);
Screen('Preference','TextRenderer',0)

% Define the cell matrix that contains the different instruction pages
% I usually define them up here and present them using the codes below.
if strcmpi(type,'BeginInstruct') % This is the first instruction that I always include when I start the study.
    message{1} = ['Welcome to our study!\n\n'...
                  'Press SPACEBAR to continue'];       
elseif strcmpi(type,'MyTask')
    % you can break up the instruction lines for the CODE by combining separate strings like I do here
    message{1} = ['Welcome to the gambling game!\n\n'...
                  'On each page, you will see a gamble. Your task is to decide whether or not to accept the gamble.\n\n'...
                  'The gamble is presented as a pie with each slice representing the chance of winning or losing money. The bigger the slice, the more likely the outcome.'...
                  'The smaller the slice, the less likely the outcome.\n\n'...
                  'Press SPACEBAR to continue.'];
                  
    message{2} = ['Each slice of the pie will be presented in one corner of the screen.'...
                  'Above or below each slice will be the amount of money that you can win or lose.\n\n'...
                  'Pay attention to the "+" and "-" signs of the gamble.'...
                  'A "+" means that you could win that amount of money, and a "-" means that you could lose that amount of money.'...
                  'Although some gambles look similar, they have different signs so pay attention to the sign.\n\n'...
                  'Press SPACEBAR to continue.'];
              
    message{3} = ['One of these choices will be played for real money. The outcome of this gamble will determine your final payment.\n\n'...
                  'You will not know which gamble is played for real money, so please choose the gamble you prefer on each trial.\n\n'...
                  'Press SPACEBAR to continue.'];
              
    message{4} = ['To accept the gamble, press the number 1. To reject the gamble, press the number 0.\n\n'...
                  'Remember, there is no right or wrong answer. It is just your personal preference.\n\n'...
                  'Press SPACEBAR to continue.'];
              
    message{5} = ['Do you have any questions?\n\n'...
                  'Press SPACEBAR when you are ready to begin the practice trials.'];
end

% After you have created all of your instructions, you can present them
% here, one-by-one.
for i = 1:length(message)
    FlushEvents;
    DrawFormattedText(S.wID,message{i},'center','center',S.textColor,80,[],[], 1.5);
    Screen(S.wID,'Flip');
    timing.InstructOnset(i) = GetSecs;
    while 1
        [~, ~, key] = KbCheck;
        if find(key) == keys.space
            timing.InstructOffset(i) = GetSecs;
            pause(0.2) % pause slightly before next screen. Obsviously keep a good accounting of all your timing as you create your study
            break;
        end
    end
end

instruct.Messages = message;
instruct.Timing = timing;