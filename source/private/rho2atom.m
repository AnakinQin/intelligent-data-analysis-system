function altde=rho2atom(rho)
% �����ܶȷ����������
if rho<0
    rho=0;
end
altde=fzero(@(x)getrho(x)-rho,5000);

function rho=getrho(altde)
[tmp,rho]=atomstatic(altde);