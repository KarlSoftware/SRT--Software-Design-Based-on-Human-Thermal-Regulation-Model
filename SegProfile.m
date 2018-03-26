classdef SegProfile
    %SegmentԤ����
    %���ԣ�
    %ADu    double  Ƥ�������,m2
    %hc     double  (��Ȼ����������ϵ��,W/m2
    %hr     double  ���任��ϵ��,W/m2
    %SKINR  double  Ƥ����������Ȩϵ��
    %SKINS  double  �����źŷ���ϵ��
    %SKINV  double  Ѫ�������źŷ���ϵ��
    %SKINC  double  Ѫ�������źŷ���ϵ��
    %Chilf  double  ����źŷ���ϵ��
    %Metf   double  ���ڻ�����ӵĴ�л����ϵ��
    %Cskin  double  Ƥ������
    %Cres   double  �������ȷ���ϵ��
    %Cerr   double  ͷ���ڵ���
    %Qb     double(4��1) ������л
    %BFB    double(4��1) ����Ѫ����
    %Tset   double(4��1) �¶��趨��
    %C      double(4��4) �ڵ�����
    %invC   double(4��4) C�������
    %A      double(4��4) ����A����
    %������
    %SegProfile ���캯��
    properties
        ADu;
        hc;
        hr;
        SKINR;
        SKINS;
        SKINV;
        SKINC
        Chilf;
        Metf;
        Cskin;
        Cres;
        Cerr;
        Qb;
        BFB;
        Tset;
        C;
        invC;
        A;
    end
    methods
        function obj=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr)
            obj.C=sparse([1,2,3,4],[1,2,3,4],(C*1000));
            obj.invC=sparse([1,2,3,4],[1,2,3,4],1./(C*1000));
            obj.Cskin=C(4);
            obj.Qb=Qb;
            obj.BFB=BFB;
            obj.Tset=Tset;
            obj.SKINR=SKINR;
            obj.SKINS=SKINS;
            obj.SKINV=SKINV;
            obj.SKINC=SKINC;
            obj.Chilf=Chilf;
            obj.Metf=Metf;
            obj.ADu=ADu;
            obj.hc=hc;
            obj.hr=hr;
            obj.Cres=Cres;
            obj.Cerr=Cerr;
            obj.A=sparse([1,2,3,4,1,2,3,2,3,4],[1,2,3,4,2,3,4,1,2,3],[-Cd(1),-Cd(1)-Cd(2),-Cd(2)-Cd(3),-Cd(3),Cd(1),Cd(2),Cd(3),Cd(1),Cd(2),Cd(3)]);
        end
    end
end

