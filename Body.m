classdef Body<handle
    %����ģ�ͼ���ĸ�������
    %���ԣ�
    %Seg    ����        �������Segment��
    %ADu    double      Ƥ�������,m2
    %SegNum int         Segment����
    %Tblp   double      ����Ѫ���¶�,��
    %M_bas  double      ������л��,W
    %Act_0  double      ������л�ʶ�Ӧ��metֵ,met
    %Act    double      ʵ��metֵ,met
    %Qres   double      ����������,W
    %BFB    double      ����Ѫ����,ml/s
    %Ta     double      ͷ���ڵ�Ŀ����¶ȣ����ڼ����������,��
    %Pa     double      ͷ���ڵ��ˮ������ѹ�������ڼ����������,kPa
    %Sweat  double      ���������ź�,W
    %Chill  double      ���������ź�,W
    %Vasodilation       double  Ѫ�������ź�,ml/s
    %Vasoconstriction   double  Ѫ�������ź�,1
    %T      double      ���нڵ��¶�,��
    %dT     double      ���нڵ��¶ȶ�ʱ��ĵ���,��/s
    %Tsk    double      Ƥ���¶�,��
    %C_blp  double      ����Ѫ������,W/��
    %Tblp0  double      ����Ѫ���¶�,��
    %Creg   double(4��4) �ȵ���ϵͳϵ��      
    %������
    %Body()         ���캯��
    %addSegment()   ����Segment
    %initiallize()  ģ�ͳ�ʼ��
    %setCondition   �趨ģ�͵Ļ�������
    %RunCalculation ����ģ��
    %showBasicProperties ��ʾģ�͵Ļ�������
    %showCondition  ��ʾ���㹤������Ϣ
    %getTskMean     ����ƽ��Ƥ���¶�
    %showT_all      ��ʾ���нڵ���¶�
    properties
        Seg
        ADu
        SegNum
        Tblp
        M_bas
        Act_0
        Act
        Q_Act
        MSum
        Qres
        BFB
        Ta
        Pa
        Sweat
        Chill
        Vasodilation
        Vasoconstriction
        T
        dT
        C_skin
        Tsk
    end
    properties(Constant)
        C_blp=9.369e3;
        Tblp0=36.7;
        Creg=[
            371.2,33.6,0,0;     %�����źŵĵ���ϵ��
            0,0,0,24.4;         %���
            32.5,2.1,0,0;       %Ѫ������
            -11.5,-11.5,0,0     %Ѫ������
            ];                 
    end
    methods
        function obj=Body()
            obj.SegNum=0;
            obj.Seg=[];
            obj.ADu=0;
            obj.M_bas=0;
            obj.BFB=0;
            obj.C_skin=[];
        end
        function addSegment(obj,Segprofile,Name)
            obj.Seg=[obj.Seg;Segment(Segprofile,Name)];
            obj.SegNum=obj.SegNum+1;
            obj.ADu=obj.ADu+obj.Seg(obj.SegNum).Profile.ADu;
            obj.M_bas=obj.M_bas+sum(obj.Seg(obj.SegNum).Profile.Qb);
            obj.Act_0=obj.M_bas/obj.ADu/58.2;
            obj.BFB=obj.BFB+sum(obj.Seg(obj.SegNum).Profile.BFB);
            obj.C_skin=[obj.C_skin;obj.Seg(obj.SegNum).Profile.C(4,4)];
        end
        function initiallize(obj)
            obj.T=zeros(obj.SegNum*4,1);
            obj.Tsk=zeros(obj.SegNum,1);
            obj.dT=obj.T;
            for j=1:obj.SegNum
                obj.Seg(j).initiallize;
                obj.T(4*j-3:4*j)=obj.Seg(j).T;
            end
            obj.Tblp=obj.Tblp0;
            fprintf('\nModel initiallized\n');
            obj.getTskinMean;
        end
        function setCondition(obj,Ta,Tr,Pa,v,Clo,Act)
            obj.Ta=Ta(1);
            obj.Pa=Pa(1);
            obj.Act=Act;
            obj.Q_Act=58.2*obj.ADu*(Act-obj.Act_0);     
            for j=1:obj.SegNum
                obj.Seg(j).setCon(Ta(j),Tr(j),Pa(j),v(j),Clo(j),obj.Q_Act);
            end
            obj.showCondition
        end
        function [dt,RealtStep,Tstep]=RunCalculation(obj,Duration,dt0,Maxiteration)
            fprintf('\nStart Calculation\n');
            fprintf('Calculate time = %.2f s\nMaxiteration = %d\n\n',Duration,Maxiteration);
            flg=0;
            Realt=0;
            RealtStep=0;
            Tstep=[obj.T;obj.Tblp];
            dt=dt0;
            iteration=0;
            Qbld=zeros(obj.SegNum,1);
            while flg==0&&iteration<Maxiteration
                sig=zeros(1,3);
                %--------------�ȵ��ڼ���--------------------
                for j=1:obj.SegNum
                    sig=sig+obj.Seg(j).setT(obj.T(4*j-3:4*j));
                end
                SIG=[sig(1);sig(2)-sig(3);max(sig(1),0)*sig(2);max(-sig(1),0)*sig(3)];
                Regulation=max(0,obj.Creg*SIG);
                obj.Sweat=Regulation(1);
                obj.Chill=Regulation(2);
                obj.Vasodilation=Regulation(3);
                obj.Vasoconstriction=Regulation(4);
                %-------------------------------------------
                obj.Qres=-(0.0014*(34-obj.Ta)+0.017*(5.876-obj.Pa))*(obj.Q_Act+obj.M_bas+obj.Chill);
                for j=1:obj.SegNum
                    [obj.dT(4*j-3:4*j,1),Qbld(j)]=obj.Seg(j).CaldT(obj.Sweat,obj.Chill,obj.Vasodilation,obj.Vasoconstriction,obj.Qres,obj.Tblp);
                end
                dTbld=-sum(Qbld)/obj.C_blp;
                maxdT=max(abs([obj.dT;dTbld]));
                dt=min(dt,0.1/maxdT);
                if Duration-Realt<=dt
                    dt=Duration-Realt;
                    flg=1;
                end
                obj.T=obj.T+obj.dT*dt;
                obj.Tblp=obj.Tblp+dTbld*dt;
                Realt=Realt+dt;
                RealtStep=[RealtStep;Realt];
                Tstep=[Tstep,[obj.T;obj.Tblp]];
                iteration=iteration+1;
            end
            if iteration<Maxiteration
                fprintf('\nCalculation finished\n');
            else
                fprintf('\nExceed Maxiteration!\n');
            end
        end
        function showBasicProperties(obj)
            fprintf('Total skin area = %.2f m2\n',obj.ADu);
            fprintf('Basal metabolism = %.2f W = %.3f met\n',obj.M_bas,obj.Act_0);
            fprintf('Basal cardiac output = %.2f L/min\n',obj.BFB*60/1000);
        end
        function showCondition(obj)
            fprintf('Condition:\nAct= %.2f met\n',obj.Act);
            fprintf('Segment\t\tT_a(��)\tT_r(��)\tPa(kPa)\tv(m/s)\tClo(clo)\n');
            for j=1:obj.SegNum
                 fprintf('%s\t\t%.2f\t%.2f\t%.3f\t%.2f\t%.2f\t\n',obj.Seg(j).Name,obj.Seg(j).Ta,obj.Seg(j).Tr,obj.Seg(j).Pa,obj.Seg(j).v,obj.Seg(j).Clo/0.155);
            end
        end
        function Tskm=getTskinMean(obj)
            sumTC=0;
            for j=1:obj.SegNum
                sumTC=sumTC+obj.Seg(j).T(4)*obj.C_skin(j);
            end
            Tskm=sumTC/sum(obj.C_skin);
        end
        function showT_all(obj)
            fprintf('\nTemperature distribution(��):\n');
            fprintf('Segment\t\tCore\tMuscle\tFat \tSkin\n');
            for j=1:obj.SegNum
                obj.Tsk(j)=obj.Seg(j).T(4);
                fprintf('%s\t\t%.2f\t%.2f\t%.2f\t%.2f\n',obj.Seg(j).Name,obj.Seg(j).T(1),obj.Seg(j).T(2),obj.Seg(j).T(3),obj.Seg(j).T(4));
            end
            fprintf('Central bood pool temperature = %.2f ��\n',obj.Tblp);
            Tskm=obj.getTskinMean;
            fprintf('Mean skin temperature = %.2f ��\n\n',Tskm);
        end
    end
end


