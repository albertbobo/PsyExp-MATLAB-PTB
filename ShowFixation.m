% ShowFixation.m

% 呈现注视点
function ReturnFixa = ShowFixation(secs)
global w ifi
fixation = Screen('MakeTexture', w, imread('images\prompt\fixation.png'));
for i = 1 : round(secs / ifi)
    Screen('DrawTexture', w, fixation, [], []);
    ReturnFixa = Screen('Flip', w);
end
end