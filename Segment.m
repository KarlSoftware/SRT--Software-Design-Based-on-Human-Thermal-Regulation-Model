classdef Segment<handle
    %计算单位，Segment
    %属性：
    %Name       char        Segment的名称
    %Profile    SegProfile  Segment的预设属性
    %T          double(4×1)      各个节点的温度,℃
    %BF         double(4×1)      各个节点的血流量,ml/s
    %Q_Act      double            由于活动增加产生的代谢热量
    %Ta         double            空气温度,℃
    %Tr         double            辐射温度,℃
    %To         double            操作温度,℃      
    %v          double            相对风速,m/s
    %Pa         double            水蒸气分压力,kPa
    %Clo        double            服装热阻,clo
    %fcl        double            服装面积系数
    %km         double            局部Q_10 effect
    %hc         double            实际对流传热系数,W/m2
    %hr         double            实际辐射传热系数,W/m2
    %he         double            实际对流传质系数,W/m2
    %Qdry       double            显热换热量（对流+辐射）,W
    %Qevap      double            蒸发换热量,W
    %Qbld       double(4×1)      血流换热量,W
    %Qshiv      double            冷颤产热量,W
    %Qcond      double(4×1)      Segment内导热换热量,W
    %方法：
    %Segment    构造函数
    %setCon     设置状态
    %CaldT      计算Segment各个节点的温度变化率
    %setT       设置Segment各个节点的温度,并获得温差信号
    %initiallize    初始化
    properties
        Name;
        Profile;
        T;
        BF;
        Q_Act;
        Ta
        Tr
        To
        v
        Pa
        Clo
        fcl
        km
        hc
        hr
        he
        Qdry
        Qevap
        Qbld
        Qshiv
        Qcond
    end
    methods
        function obj=Segment(Profile,Name)
            obj.Name=Name;
            obj.Profile=Profile;
        end
        function setCon(obj,Ta,Tr,Pa,v,Clo,Q_Act)
            obj.Q_Act=Q_Act*obj.Profile.Metf;
            obj.Ta=Ta;
            obj.Tr=Tr;
            obj.Pa=Pa;
            obj.v=v;
            obj.Clo=Clo*0.155;
            obj.fcl=1+0.25*obj.Clo;
        end
        function [dT,Qbld]=CaldT(obj,Swt,Chi,Dl,St,Qres,Tblp)
            obj.Qcond=obj.Profile.A*obj.T;
            obj.Qshiv=Chi*obj.Profile.Chilf;
            Qexmet=obj.Q_Act+obj.Qshiv;
            obj.BF(4)=(obj.Profile.BFB(4)+obj.Profile.SKINV*Dl)/(1+obj.Profile.SKINC*St)*obj.km;%皮肤血流量
            obj.BF(2)=obj.Profile.BFB(2)+0.239*(Qexmet);
            obj.Qbld=Profiles.rhoCbld*obj.BF.*(Tblp-obj.T);
            Qbld=sum(obj.Qbld);
            %计算显热换热量
            obj.hc=obj.Profile.hc;
            obj.hr=obj.Profile.hr;
            h=obj.hc+obj.hr;
            obj.To=[obj.Ta,obj.Tr]*[obj.hc;obj.hr]/h;
            ht=1/(obj.Clo+1/(obj.fcl*h));
            obj.Qdry=ht*(obj.To-obj.T(4))*obj.Profile.ADu;
            %计算蒸发换热量
            obj.he=Profiles.LR*Profiles.icl/(obj.Clo+Profiles.icl/(obj.hc*obj.fcl));
            Emax=max(0,obj.he*obj.Profile.ADu*(Profiles.P(obj.T(4))-obj.Pa));
            obj.Qevap=-min(Emax,0.06*Emax+0.94*Swt*obj.Profile.SKINS*obj.km);
            Qskin=obj.Qdry+obj.Qevap;
            q=[
                Qres*obj.Profile.Cres;
                Qexmet;
                0;
                Qskin
                ];
            dT=obj.Profile.invC*(obj.Qcond+obj.Qbld+obj.Profile.Qb+q);
        end
        function sig=setT(obj,T)
            obj.T=T;
            ERR=obj.T-obj.Profile.Tset;
            Err=ERR(1)*obj.Profile.Cerr;
            Wrm=max(ERR(4),0)*obj.Profile.SKINR;
            Cld=max(-ERR(4),0)*obj.Profile.SKINR;
            obj.km=2^(ERR(4)/10);%Local effect
            sig=[Err,Wrm,Cld];
        end
        function initiallize(obj)
            obj.T=obj.Profile.Tset;
            obj.BF=obj.Profile.BFB;
            obj.Q_Act=0;
        end
    end 
end

