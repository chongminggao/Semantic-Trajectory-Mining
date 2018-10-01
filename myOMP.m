function x = myOMP(dictionary,x,iter)
[M,N] = size(dictionary);
residual = zeros(M,iter); %�в���󣬱���ÿ�ε�����Ĳв�
residual(:,1) = x; %��ʼ���в�Ϊx
L = size(residual,2); %�õ��в�������
pos_num = zeros(1,L); %��������ÿ��ѡ��������
resi_norm = zeros(1,L); %��������ÿ�ε�����Ĳв��2����
resi_norm(1) = norm(x); %��Ϊǰ���ѳ�ʼ���в�Ϊx
iter_out = 1e-3;
iter_count = 0;
aug_mat = [];

for mm = 1:iter
    %�����˳�����
    if resi_norm(mm) < iter_out
        break;
    end
    %���dictionaryÿ�����ϴβв���ڻ�
    scalarproducts = dictionary'*residual(:,mm);
    %�ҵ��ڻ��������м����ڻ�ֵ
    [val,pos] = max(abs(scalarproducts));
    %��С���˵��������
    aug_mat = [aug_mat dictionary(:,pos)];
    %��С����ͶӰ
    proj_y = aug_mat*(aug_mat'*aug_mat)^(-1)*aug_mat'*x;
    %���²в�
    residual(:,mm+1) = x - proj_y;
    %����в��2������ƽ�����ٿ����ţ�
    resi_norm(mm+1) = norm(residual(:,mm+1));
     %����ѡ��������
    pos_num(mm) = pos;
    iter_count = iter_count + 1;
end
%����в��2��������
resi_norm = resi_norm(1:iter_count+1);
plot(resi_norm);grid;
%��ʾѡ����ֵ�ԭ��
pos_num = pos_num(1:iter_count);
disp(pos_num);
%ϡ��ϵ��
dict = dictionary(:,pos_num);
y_vec = (dict'*dict)^(-1)*dict'*x;
disp(y_vec);
figure;plot(y_vec);