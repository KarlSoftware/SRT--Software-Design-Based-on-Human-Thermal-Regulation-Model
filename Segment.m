classdef Segment<handle
    %���㵥λ��Segment
    %���ԣ�
    %Name       char        Segment������
    %Profile    SegProfile  Segment��Ԥ������
    %T          double(4��1)      �����ڵ���¶�,��
    %BF         double(4��1)      �����ڵ��Ѫ����,ml/s
    %Q_Act      double            ���ڻ���Ӳ����Ĵ�л����
    %Ta         double            �����¶�,��
    %Tr         double            �����¶�,��
    %To         double            �����¶�,��      
    %v          double            ��Է���,m/s
    %Pa         double            ˮ������ѹ��,kPa
    %Clo        double            ��װ����,clo
    %fcl        double            ��װ���ϵ��
    %km         double            �ֲ�Q_10 effect
    %hc         double            ʵ�ʶ�������ϵ��,W/m2
    %hr         double            ʵ�ʷ��䴫��ϵ��,W/m2
    %he         double            ʵ�ʶ�������ϵ��,W/m2
    %Qdry       double            ���Ȼ�����������+���䣩,W
    %Qevap      double            ����������,W
    %Qbld       double(4��1)      Ѫ��������,W
    %Qshiv      double            ���������,W
    %Qcond      double(4��1)      Segment�ڵ��Ȼ�����,W
    %������
    %Segment    ���캯��
    %setCon     ����״̬
    %CaldT      ����Segment�����ڵ���¶ȱ仯��
    %setT       ����Segment�����ڵ���¶�,������²��ź�
    %initiallize    ��ʼ��
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
            obj.BF(4)=(obj.Profile.BFB(4)+obj.Profile.SKINV*Dl)/(1+obj.Profile.SKINC*St)*obj.km;%Ƥ��Ѫ����
            obj.BF(2)=obj.Profile.BFB(2)+0.239*(Qexmet);
            obj.Qbld=Profiles.rhoCbld*obj.BF.*(Tblp-obj.T);
            Qbld=sum(obj.Qbld);
            %�������Ȼ�����
            obj.hc=obj.Profile.hc;
            obj.hr=obj.Profile.hr;
            h=obj.hc+obj.hr;
            obj.To=[obj.Ta,obj.Tr]*[obj.hc;obj.hr]/h;
            ht=1/(obj.Clo+1/(obj.fcl*h));
            obj.Qdry=ht*(obj.To-obj.T(4))*obj.Profile.ADu;
            %��������������
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

