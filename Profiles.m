classdef Profiles
    %PROFILES 各种预设、常数以及函数
    %属性：
    %LR     double  刘易斯数,℃/kPa
    %icl    double  服装透湿系数 
    %rhoCbld    double  血液热容    
    %方法：
    %Arm    构造手臂Segment
    %Back   构造背部Segment
    %Chest  构造前胸Segment
    %Foot   构造脚部Segment
    %Hand   构造手部Segment
    %Head   构造头部Segment
    %Leg    构造腿部Segment
    %Pelvis 构造骨盆Segment
    %Shoulder构造肩膀Segment
    %Thigh  构造大腿Segment
    %P      根据空气温度T,和相对湿度RH计算水蒸气分压力,缺省RH时，计算饱和压力
    properties(Constant)
        LR=16.5;
        icl=0.45;
        rhoCbld=3.842;
    end 
    methods(Static)
        function am=Arm()
            C=[1.156;2.452;0.47;0.357];
            Cd=[0.244;2.227;7.888];
            Qb=[0.094;0.22;0.031;0.026];
            BFB=[0.044;0.186;0.024;0.125];
            Tset=[35.5;34.8;34.7;34.6];
            SKINR=0.012;
            SKINS=0.026;
            SKINV=0.016;
            SKINC=0.022;
            Chilf=0.026;
            Metf=0.014;
            ADu=0.063;
            hc=3.6;
            hr=4.4;
            Cres=0;
            Cerr=0;
            am=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function bk=Back()
            C=[8.895;18.078;4.761;1.391];
            Cd=[0.594;2.018;8.7];
            Qb=[18.699;2.537;0.501;0.158];
            BFB=[21.206;2.128;0.372;0.375];
            Tset=[36.5;35.8;34.4;33.2];
            SKINR=0.132;
            SKINS=0.129;
            SKINV=0.086;
            SKINC=0.065;
            Chilf=0.227;
            Metf=0.08;
            ADu=0.161;
            hc=2.9;
            hr=4.1;
            Cres=0;
            Cerr=0;
            bk=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function chst=Chest()
            C=[10.494;20.408;5.387;1.503];
            Cd=[0.616;2.1;9.164];
            Qb=[21.182;2.537;0.568;0.179];
            BFB=[21.625;2.128;0.372;0.5];
            Tset=[36.5;36.2;34.5;33.6];
            SKINR=0.149;
            SKINS=0.146;
            SKINV=0.098;
            SKINC=0.065;
            Chilf=0.258;
            Metf=0.091;
            ADu=0.175;
            hc=3;
            hr=4.3;
            Cres=1;
            Cerr=0;
            chst=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function ft=Foot()
            C=[0.499;0.132;0.276;0.451];
            Cd=[8.12;10.266;8.178];
            Qb=[0.122;0.035;0.056;0.1];
            BFB=[0.014;0.003;0.005;0.125];
            Tset=[35.1;34.9;34.4;33.9];
            SKINR=0.017;
            SKINS=0.018;
            SKINV=0.05;
            SKINC=0.152;
            Chilf=0;
            Metf=0.005;
            ADu=0.056;
            hc=2;
            hr=6.1;
            Cres=0;
            Cerr=0;
            ft=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function hand=Hand()
            C=[0.296;0.132;0.188;0.357];
            Cd=[2.181;6.484;5.858];
            Qb=[0.045;0.022;0.023;0.05];
            BFB=[0.025;0.022;0.012;0.253];
            Tset=[35.4;35.3;35.3;35.2];
            SKINR=0.092;
            SKINS=0.016;
            SKINV=0.061;
            SKINC=0.152;
            Chilf=0;
            Metf=0.005;
            ADu=0.05;
            hc=3.7;
            hr=4.2;
            Cres=0;
            Cerr=0;
            hand=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function hd=Head()
            C=[9.275;1.391;0.927;1.015];
            Cd=[1.601;13.224;16.008];
            Qb=[16.843;0.217;0.109;0.131];
            BFB=[12.5;0.242;0.094;0.622];
            Tset=[36.9;36.1;35.8;35.6];
            SKINR=0.07;
            SKINS=0.081;
            SKINV=0.132;
            SKINC=0.022;
            Chilf=0.02;
            Metf=0;
            ADu=0.14;
            hc=4.5;
            hr=4.9;
            Cres=0;
            Cerr=1;
            hd=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function lg=Leg()
            C=[2.856;6.173;0.965;0.733];
            Cd=[1.891;2.656;7.54];
            Qb=[0.102;0.22;0.035;0.023];
            BFB=[0.02;0.019;0.005;0.031];
            Tset=[35.6;34.4;33.9;33.4];
            SKINR=0.025;
            SKINS=0.036;
            SKINV=0.023;
            SKINC=0.022;
            Chilf=0.012;
            Metf=0.099;
            ADu=0.112;
            hc=2;
            hr=5.3;
            Cres=0;
            Cerr=0;
            lg=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function pvs=Pelvis()
            C=[21.661;28.789;7.567;2.18];
            Cd=[0.379;1.276;5.104];
            Qb=[8.05;4.067;0.804;0.254];
            BFB=[5.053;3.411;0.6;0.578];
            Tset=[36.3;35.6;34.5;33.4];
            SKINR=0.212;
            SKINS=0.206;
            SKINV=0.138;
            SKINC=0.065;
            Chilf=0.365;
            Metf=0.129;
            ADu=0.221;
            hc=2.9;
            hr=4.3;
            Cres=0;
            Cerr=0;
            pvs=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function shd=Shoulder()
            C=[1.811;3.881;0.745;0.545];
            Cd=[0.441;2.946;7.308];
            Qb=[0.181;0.423;0.61;0.05];
            BFB=[0.089;0.356;0.044;0.239];
            Tset=[35.8;34.6;33.8;33.4];
            SKINR=0.023;
            SKINS=0.051;
            SKINV=0.031;
            SKINC=0.022;
            Chilf=0.004;
            Metf=0.026;
            ADu=0.096;
            hc=3.6;
            hr=4.5;
            Cres=0;
            Cerr=0;
            shd=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function thi=Thigh()
            C=[5.883;12.976;2.017;1.522];
            Cd=[2.401;4.536;30.16];
            Qb=[0.343;0.824;0.151;0.122];
            BFB=[0.101;0.238;0.042;0.106];
            Tset=[35.8;35.2;34.4;33.8];
            SKINR=0.05;
            SKINS=0.073;
            SKINV=0.092;
            SKINC=0.022;
            Chilf=0.023;
            Metf=0.201;
            ADu=0.209;
            hc=2.8;
            hr=4.8;
            Cres=0;
            Cerr=0;
            thi=SegProfile(C,Cd,Qb,BFB,Tset,SKINR,SKINS,SKINV,SKINC,Chilf,Metf,ADu,hc,hr,Cres,Cerr);
        end
        function p=P(T,RH)
            if nargin==1
                p=exp(16.6536-4030.183./(T+235));
            else
                p=exp(16.6536-4030.183./(T+235)).*RH/100;
            end
        end
    end
end

