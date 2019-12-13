# 导入必要的库
import numpy as np
import pandas as pd
import matplotlib.pylab as plt
from scipy import stats
import em

#产生身高数据
np.random.seed(100)  # 固定随机数种子，确保下次运行数据相同
#产生满足正太分布的随机数，参数分别为：均值，方差，样本量
male=np.random.normal(180,10,1000)
female=np.random.normal(163,10,1000)

#分别画出男女生图像
m1=pd.Series(male).hist(bins=100)
f1=pd.Series(female).hist(bins=100)
m1.plot()
f1.plot()
plt.title('Histogram of height distribution of boys and girls in a school')
#某校男女生身高的分布直方图
plt.xlabel('height/cm')
plt.ylabel('People/Number')
plt.show()

#混合数据后画图
h=list(male)# 转化为list
h.extend(female)
h=np.array(h)# 再转成numpy格式的数据
h1=pd.Series(h).hist(bins=150)
h1.plot()
plt.title('Mixed probability density function')#混合后概率密度函数
plt.show()

#GMM的构造
#Step 1.首先根据经验来分别对男女生的均值、方差和权值进行初始化
mu1=170;sigmal=10;w1=0.7#男生的
mu2=160;sigma2=10;w2=0.3#以我们学校理工院校为例

d=1
n = len(h)  # 样本长度
# 开始EM算法的主循环
for iteration in range(100):
    mu1,sigmal,w1,mu2,sigma2,w2=em.em(h,mu1,sigmal,w1,mu2,sigma2,w2)

#男生女生以及混合后身高的概率密度曲线
t=np.linspace(120,220,550)#500个
m = stats.norm.pdf(t,loc=mu1, scale=sigmal) # 男生分布的预测
f = stats.norm.pdf(t,loc=mu2, scale=sigma2) # 女生分别的预测
mix=w1*m+w2*f#混合后
plt.plot(t, m, color='b')
plt.plot(t, f, color='r')
plt.plot(t, mix, color='k')
#男生女生以及混合后身高的概率密度曲线
plt.title('Probability density curve for boys and girls and mixed height')
#plt.legend([p1,p2,p3],["male","female","mixing"],loc='upper right')
plt.legend(["male","female","mixing"],loc='upper right')
plt.xlabel('height/cm')
plt.ylabel('Probability')#坐标轴设置
plt.show()