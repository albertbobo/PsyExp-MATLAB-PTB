% TaskOne.m

% 随机化读取实验词汇材料
function ReturnArray = TaskOne(img_url, secs, sava_path)
global sub_info w ifi is_quit left_key down_key right_key esc_key count_correct rest_block

files = dir(fullfile(img_url, '*.png'));	% 显示文件夹下所有后缀名为.png文件的完整信息
files_name = {files.name};                  % 提取后缀名为.png的所有文件的文件名，转换为n行1列

random_files = Shuffle(files_name);     % 将文件随机排列
files_length = length(random_files);	% 文件的个数
task_data = cell(files_length, 10);     % 创建空数组，保存数据，trial次数*变量数
task_data(1 : files_length, 1 : 5) = repmat(sub_info', files_length, 1);	% 将被试基本信息写入数组
count_correct = 0;

for trial = 1 : files_length
    char_files_name = char(random_files(trial));    % 带后缀的文件名
    
    % 截取文件名字符串
    cell_str = strsplit(char_files_name, {'-', '.'});	% 以“-”和“.”作为分割
    keyword = char(cell_str{1, 4});         % 取得词汇名
    potency = str2double(cell_str{1, 3});	% 取得词汇的效价
    task_data{trial, 6} = keyword;
    task_data{trial, 7} = potency;
    
    % 读取词汇图片
    images = Screen('MakeTexture', w, imread(strcat(img_url, char_files_name)));
    
    % 调用ShowFixation函数，呈现注视点500ms
    ShowFixation(0.5);
    
    % 获取刺激开始呈现的时间
    t0 = GetSecs;
    
    % 解除之前的按键禁用
    DisableKeysForKbCheck([]);
    
    % 呈现刺激材料
    for i = 1 : round(secs / ifi)
        Screen('DrawTexture', w, images, [], []);
        ReturnArray = Screen('Flip', w);
        
        % 记录反应信息       
        [~, ~, keyCode] = KbCheck;  % 检测当前按键
        if keyCode(esc_key)			% 如果按下了esc
            is_quit = 1;
            break;
        elseif keyCode(left_key)	% 如果按下了←
            resp = 3;               % 被试按键反应为←积极的
            rt = GetSecs - t0;      % 被试反应时间
            if resp == potency
                acc = 1;
                count_correct = count_correct + 1;
            else
                acc = 0;
            end
            task_data{trial, 8} = resp;
            task_data{trial, 9} = rt;
            task_data{trial, 10} = acc;
            break;
        elseif keyCode(down_key)	% 如果按下了↓
            resp = 2;
            rt = GetSecs - t0;
            if resp == potency
                acc = 1;
                count_correct = count_correct + 1;
            else
                acc = 0;
            end
            task_data{trial, 8} = resp;
            task_data{trial, 9} = rt;
            task_data{trial, 10} = acc;
            break;
        elseif keyCode(right_key)	% 如果按下了→
            resp = 1;
            rt = GetSecs - t0;
            if resp == potency
                acc = 1;
                count_correct = count_correct + 1;
            else
                acc = 0;
            end
            task_data{trial, 8} = resp;
            task_data{trial, 9} = rt;
            task_data{trial, 10} = acc;
            break;
        end      
    end
    
    % 每10个trial为一个block，休息5s
    if mod(trial, 10) == 0 && trial ~= files_length
        Screen('DrawTexture', w, rest_block, []);
        Screen('Flip', w);
        WaitSecs(5);
    end
    
    % 每次trial都保存一遍工作区的变量，以便程序中断时尽可能地保留数据
    save(strcat('data\task1\', sava_path, '\', char(task_data{1, 1}), char(task_data{1, 2}), '_', date, '_', sava_path));
    
    if is_quit == 1
        sca;
        return;
    end
    
end

% 将数据整理至一个Excel表格中
header = {
    'Id'
    'Name'
    'Gender'
    'Age'
    'Handedness'
    'Keyword'
    'Potency'
    'Resp'
    'RT'
    'ACC'
    };
data_table = cell2table(task_data, 'VariableNames', header);

% 根据变量名创建一个csv文件，用于保存数据
exp_data = strcat('data\task1\', sava_path, '\',  char(task_data{1, 1}), char(task_data{1, 2}), '_', date, '_', sava_path, '.csv');
writetable(data_table, exp_data);


end
