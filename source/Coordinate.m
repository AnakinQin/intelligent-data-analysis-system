function PositionMatrix=Coordinate(i_plot,layout)

        
column=fix((i_plot-1)/layout.m);
row=layout.m-mod(i_plot-1,layout.m)-1;
        
%% �ұ�ʼ����0.005�Ŀհף���n=1ʱ��߿հ�̫��       
% a=0.08-0.01*layout.n;  % outPosition-Position
% b=0.08-0.01*layout.m;  % outPosition-Position
% width=0.995/layout.n-a; % 0.995: �ұ�������0.005�Ŀհ�
% height=0.945/layout.m-b; % 0.945: �ϱ���0.055�Ŀհ�
% x0=(a+width)*column+a; 
% y0=(b+height)*row+b;
% PositionMatrix=[x0,y0,width,height];            
     
%% �ұ�������0.005�Ŀհף����м���ʱ�ʵ�����
% a=0.08-0.01*layout.n;  % outPosition-Position
% a=0.041;  % outPosition-Position y��̶�����ȫ��ʾ
a=0.034;  % outPosition-Position y��̶ȡ�-25.7603������ȫ��ʾ
% a=0.04+0.002*(4-layout.n)^2;  % outPosition-Position % Ҳ�ɹ̶����0.04
b=0.08-0.01*layout.m;  % outPosition-Position
width=0.995/layout.n-a; % 0.995: �ұ�������0.005�Ŀհ�
height=0.945/layout.m-b; % 0.945: �ϱ���0.055�Ŀհ�
x0=(a+width)*column+a; % ���м���ʱ�ʵ�����
y0=(b+height)*row+b;
PositionMatrix=[x0,y0,width,height];            
