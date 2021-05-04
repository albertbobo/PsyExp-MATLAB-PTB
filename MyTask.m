function MyTask
clear;    % 清除所有变量
clc;      % 清除命令行窗口中的内容
sca;      % 关闭PTB里所有打开的窗口

Screen('Preference', 'SkipSyncTests', 2);

try
    % 定义变量
    global sub_info w ifi is_quit left_key down_key right_key esc_key count_correct rest_block
    
    % 录入被试基本信息
    prompt = {
        '被试编号'
        '姓名'
        '性别[1 = 男, 2 = 女]'
        '年龄'
        '利手[1 = 左, 2 = 右]'
        };
    
    dlg_title = '被试基本信息';
    
    % 默认信息为空
    def_input = {'', '', '', '', ''};
    
    % 被试基本信息
    sub_info = inputdlg(prompt, dlg_title, [1, 50], def_input);
    
    % 提取用户信息
%     sub_id = str2double([sub_info{1}]);
%     sub_name= [sub_info{2}];
%     sub_gender = str2double([sub_info{3}]);
%     sub_age = str2double([sub_info{4}]);
%     sub_handedness = str2double([sub_info{5}]);
    
    
    % 打开一个窗口，窗口命名为“w”，“wrect”返回的值是窗口的分辨率
    [w, wrect] = Screen('OpenWindow', 0, [17, 17, 17]);		% 窗口背景色为R17 G17 B17
    
    % 获取屏幕的中心点的位置，用x_center和y_center这两个值作为坐标来呈现注视点
    [x_center, y_center] = RectCenter(wrect);
    
    % 获取当前显示器每刷新一帧所需的秒数
    ifi = Screen('GetFlipInterval', w);		% 60Hz的显示器每刷新一帧需要0.0167s
    
    % 设置窗口中呈现的文本的字体、字号
    Screen('TextFont', w, 'Microsoft Yahei UI');
    Screen('TextSize', w, 40);
    
    % 定义按键
    KbName('UnifyKeynames');
    
    % 设置按键
    left_key = KbName('LeftArrow');		% ←积极的
    down_key = KbName('DownArrow');		% ↓中性的
    right_key = KbName('RightArrow');	% →消极的
    space_key =  KbName('Space');
    esc_key = KbName('Escape');
    
    % 定义变量is_quit，0表示没有按esc，1表示按了，需要退出
    is_quit = 0;
    
    % 读取指导语图片
    instruction0 = Screen('MakeTexture', w, imread('images\prompt\instruction0.png'));
    instruction1 = Screen('MakeTexture', w, imread('images\prompt\instruction1.png'));
    instruction2 = Screen('MakeTexture', w, imread('images\prompt\instruction2.png'));
    redo_practice = Screen('MakeTexture', w, imread('images\prompt\redo_practice.png'));
    ending_practice = Screen('MakeTexture', w, imread('images\prompt\ending_practice.png'));
    rest_block = Screen('MakeTexture', w, imread('images\prompt\rest_block.png'));
    ending_test1 = Screen('MakeTexture', w, imread('images\prompt\ending_test1.png'));
    rest_part = Screen('MakeTexture', w, imread('images\prompt\rest_part.png'));
    ending = Screen('MakeTexture', w, imread('images\prompt\ending.png'));
    
    
    % -------------实验开始-------------
    % 隐藏鼠标
    HideCursor;
    % 指定有效的按键
    RestrictKeysForKbCheck([left_key, down_key, right_key, space_key, esc_key]);
    
    % 呈现引导语
    Screen('DrawTexture', w, instruction0, []);
    Screen('Flip', w);
    WaitSecs(2);
    
    % -------------进入实验一
    
    while 1
        % 限制左/下/右按键以免误触
        DisableKeysForKbCheck([left_key, down_key, right_key]);
        
        % 呈现实验一引导语
        Screen('DrawTexture', w, instruction1, []);
        Screen('Flip', w);
        KbWait;     % 等待按空格键继续
        
        [~, ~, keyCode] = KbCheck;		% 检测当前按键
        if keyCode(esc_key)             % 按下esc键
            is_quit = 1;
            break;
        end
        
        % ------------进入实验一练习部分
        
        % 呈现练习词汇1000ms并将记录的反应信息存入data\task1\practice
        TaskOne('images\practice\words\', 1, 'practice');
        
        % 如果正确的个数大于等于6，则练习通过，退出练习部分
        if count_correct >= 6
            break;
        end
        
        % 提示练习未通过
        Screen('DrawTexture', w, redo_practice, []);
        Screen('Flip', w);
        WaitSecs(3);
        
        if keyCode(esc_key)
            is_quit = 1;
            break;
        end
        
    end    
    
    if is_quit == 1
        sca;
        return;
    end
    
       
    % ------------进入实验一正式实验
    
    % 限制左/下/右按键以免误触
    DisableKeysForKbCheck([left_key, down_key, right_key]);
       
    % 提示练习通过，进入正式实验
    Screen('DrawTexture', w, ending_practice, []);
    Screen('Flip', w);
    KbWait;     % 等待按空格键继续
        
    [~, ~, keyCode] = KbCheck;		% 检测当前按键
    if keyCode(esc_key)             % 按下esc键
        sca;
        return;
    end
    
    % 开始实验，呈现词汇1000ms并将记录的反应信息存入data\task1\experiment
    TaskOne('images\experiment\words\', 1, 'experiment');
    
    disp(count_correct);
    
    % 限制按键以免误触
    DisableKeysForKbCheck([left_key, down_key, right_key]);
    
    % 提示实验一结束
    Screen('DrawTexture', w, ending_test1, []);
    Screen('Flip', w);
    KbWait;     % 等待按空格键继续
    
    
    % ------------进入实验二练习部分
    
    
    
    % ------------进入实验二正式实验
    
    
    
    % -------------实验结束-------------
    
    
    % 呈现结束语3000ms
    Screen('DrawTexture', w, ending, []);
    Screen('Flip', w);
    WaitSecs(3);
    
    sca;
    
    
    
catch
    psychrethrow(psychlasterror);
    ShowCursor;
    sca;
    
end

end
