function altde=ps2atom(ps)
% ���ݾ�ѹ�����������
if ps<0
    ps=0;
end
altde=fzero(@(x)getps(x)-ps,5000);

function ps=getps(altde)
ps=atomstatic(altde);

