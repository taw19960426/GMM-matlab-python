%绘制男女生身高的GMM
clc
clear all
%男女生共取2000人，女生平均身高163，男声平均身高180
male=180+sqrt(10)*randn(1,1000);
%产生均值为180，方差为10的一个1*1000的随机数
female=163+sqrt(10)*randn(1,1000);
h=[female male];

%画出混合后的频率分布直方图，产生150个直方图
figure(1)
hist(h,150);

%画出生成的男女性的频率分布直方图
figure(2)
hist(female,100);
f=findobj(gca,'Type','patch');%得到每条曲线句柄的集合
set(f,'facecolor','g');%设置柱形图颜色
hold on
hist(male,100);%画出生成的男性的频率分布直方图
title('某校男女生身高的分布直方图');
xlabel('身高/cm');
ylabel('人数/个');
hold off;

%GMM的构造
%Step 1.首先根据经验来分别对男女生的均值、方差和权值进行初始化
mu1_first=170;sigmal_first=10;w1_first=0.7;%男生的
mu2_first=160;sigma2_first=10;w2_first=0.3;%以我们学校理工院校为例

iteration=30;%设置迭代次数
outcome=zeros(iteration,6);%定义一个数组来存储每次的迭代结果
outcome(1,1)=mu1_first;outcome(1,4)=mu2_first;
outcome(1,2)=sigmal_first;outcome(1,5)=sigma2_first;
outcome(1,3)=w1_first;outcome(1,6)=w2_first;%将第一列存储初始值

%开始迭代
for i=1:iteration-1
    [mu1_last,sigma1_last,w1_last,mu2_last,sigma2_last,w2_last]=em(male,female,outcome(i,1),outcome(i,2),outcome(i,3),outcome(i,4),outcome(i,5),outcome(i,6));
    %将迭代结果依次送入em,更新outcome中的数值
    outcome(i+1,1)=mu1_last;outcome(i+1,2)=sigma1_last;outcome(i+1,3)=w1_last;
    outcome(i+1,4)=mu2_last;outcome(i+1,5)=sigma2_last;outcome(i+1,6)=w2_last;
end

outcome ;% 输出每次迭代结果

%画出男女生的权重迭代历史
figure(3);
x1=1:0.5:iteration;
y1=interp1(outcome(:,3),x1,'spline');
%interp1用法参考https://www.cnblogs.com/jiahuiyu/articles/4978005.html   
plot(y1,'linewidth',1.5);%画出男生的权重迭代历史
hold on;
grid on;
y2=interp1(outcome(:,6),x1,'spline');
plot(y2,'r','linewidth',1.5);%画出女生权重迭代历史
legend('男生权重变化','女生权重变化','location','northeast');%坐标轴设置，将标识框放置在图的左上角
title('Changes in weights of boys and girls with the number of iterations');
xlabel('Number of iterations');
ylabel('Weights');
axis([1 iteration 0 1]);

%迭代的最终结果取出
mu1_last=outcome(iteration,1);
sigma1_last=outcome(iteration,2);
w1_last=outcome(iteration,3);
mu2_last=outcome(iteration,4);
sigma2_last=outcome(iteration,5);
w2_last=outcome(iteration,6);

figure(4);
hold on;
%男生女生以及混合后身高的概率密度曲线
t=linspace(140,220,550);%500个
%女生的概率密度函数
yy2=normpdf(t,mu2_last,sigma2_last);
plot(t,yy2,'m','linewidth',1.5);
%男生的概率密度函数
yy1=normpdf(t,mu1_last,sigma1_last);
plot(t,yy1,'linewidth',1.5);
y3=w1_last*yy1+w2_last*yy2;
plot(t,y3,'k','linewidth',1.5);
legend('女生','男生','混合');
title('男生女生以及混合后身高的概率密度曲线');
xlabel('身高/cm');ylabel('概率');hold off;%坐标轴设置
hold off;

%画高斯混合模型的随迭代次数的变化而变化图形
figure(5)
plot(t,yy2,'--g','linewidth',1.5);
hold on;
plot(t,yy1,'linewidth',1.5);
title('高斯混合模型的随迭代次数的变化图形');
xlabel('身高/cm');
ylabel('概率密度');
grid on;
weights1=outcome(:,3);
weights2=outcome(:,6);
%
%将字符串基本信息显示在右上角
text(180,0.13,'当前男生权重W1： ','FontSize',14,'FontWeight','demi');%图中显示权重
text(180,0.117,'当前女生权重W2： ','FontSize',14,'FontWeight','demi');
c=colormap(lines(iteration));%定义times条不同颜色的线条
for i=1:iteration
      pause(0.2);
    %绘制迭代i次的图像,以不同颜色
    y4=weights1(i)*yy1+weights2(i)*yy2;%对两个高斯概率密度图像进行加权
    plt=plot(t,y4,'color',c(i,:),'linewidth',1.5);%绘画加权后的图像
    %weights里面的数值转换为字符串
    str1=num2str(weights1(i));
    str2=num2str(weights2(i));
    %权重跟着i变换
    tex1=text(210,0.13,str1,'FontSize',14,'FontWeight','demi','color','r');%显示当前权重值
    tex2=text(210,0.117,str2,'FontSize',14,'FontWeight','demi','color','r');
    %删除原来的，动态显示
    pause(0.4);
    if(iteration>i)
        delete(tex1);
        delete(tex2);
        delete(plt);
    end
end
hold off;
   


    
