function [altde,mach]=qcps2atom(qc2ps,param,type)
% ��ѹ��ѹ֮�ȷ����������
switch nargin
    case 1
        param=0;
        type=1;
    case 2
        type=1;
end
if qc2ps<0
    error('����ѹ֮�Ȳ���С��0');
end

switch type
    case 1 % �߶�
        altde=param;
    case 2 % ���
        mach=param;
        if qc2ps<=0 || mach<=0
            qc2ps=0;
            mach=0;
        end
        altde=fzero(@(x)getqc2ps(x,mach)-qc2ps,5000);
end
% ���㾲ѹ
ps=atomstatic(altde);
% ���㶯ѹ
qc=qc2ps*ps;
% �������
[altde,mach]=qc2atom(qc,altde);

function qc2ps=getqc2ps(altde,mach)
[tmp1,tmp2,tmp3,tmp4,qc2ps]=atomdynamic(altde,mach);

