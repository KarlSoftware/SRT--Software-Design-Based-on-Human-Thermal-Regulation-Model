classdef SegProfile
    %Segment预设类
    %属性：
    %ADu    double  皮肤表面积,m2
    %hc     double  (自然）对流换热系数,W/m2
    %hr     double  辐射换热系数,W/m2
    %SKINR  double  皮肤感受器加权系数
    %SKINS  double  出汗信号分配系数
    %SKINV  double  血管扩张信号分配系数
    %SKINC  double  血管收缩信号分配系数
    %Chilf  double  冷颤信号分配系数
    %Metf   double  由于活动量增加的代谢分配系数
    %Cskin  double  皮肤热容
    %Cres   double  呼吸换热分配系数
    %Cerr   double  头部节点标记
    %Qb     double(4×1) 基础代谢
    %BFB    double(4×1) 基础血流量
    %Tset   double(4×1) 温度设定点
    %C      double(4×4) 节点热容
    %invC   double(4×4) C矩阵的逆
    %A      double(4×4) 导热A矩阵
    %方法：
    %SegProfile 构造函数
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

