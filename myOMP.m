function x = myOMP(dictionary,x,iter)
[M,N] = size(dictionary);
residual = zeros(M,iter); %残差矩阵，保存每次迭代后的残差
residual(:,1) = x; %初始化残差为x
L = size(residual,2); %得到残差矩阵的列
pos_num = zeros(1,L); %用来保存每次选择的列序号
resi_norm = zeros(1,L); %用来保存每次迭代后的残差的2范数
resi_norm(1) = norm(x); %因为前面已初始化残差为x
iter_out = 1e-3;
iter_count = 0;
aug_mat = [];

for mm = 1:iter
    %迭代退出条件
    if resi_norm(mm) < iter_out
        break;
    end
    %求出dictionary每列与上次残差的内积
    scalarproducts = dictionary'*residual(:,mm);
    %找到内积中最大的列及其内积值
    [val,pos] = max(abs(scalarproducts));
    %最小二乘的增广矩阵
    aug_mat = [aug_mat dictionary(:,pos)];
    %最小二乘投影
    proj_y = aug_mat*(aug_mat'*aug_mat)^(-1)*aug_mat'*x;
    %更新残差
    residual(:,mm+1) = x - proj_y;
    %计算残差的2范数（平方和再开根号）
    resi_norm(mm+1) = norm(residual(:,mm+1));
     %保存选择的列序号
    pos_num(mm) = pos;
    iter_count = iter_count + 1;
end
%绘出残差的2范数曲线
resi_norm = resi_norm(1:iter_count+1);
plot(resi_norm);grid;
%显示选择的字典原子
pos_num = pos_num(1:iter_count);
disp(pos_num);
%稀疏系数
dict = dictionary(:,pos_num);
y_vec = (dict'*dict)^(-1)*dict'*x;
disp(y_vec);
figure;plot(y_vec);