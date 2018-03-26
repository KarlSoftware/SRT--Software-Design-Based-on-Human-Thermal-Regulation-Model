%65-Node Thermoegulation Model
%Created by Di Mou at 10/26/2017
%Reference: 
%S.Tanabe, J.Nakano, K.Kobayashi, Development of 65-Node thermoregulation-model for evaluation of thermal environment, Journal of Architectural Planning and Environmental Engineering(AIJ) 541 (2001) (in Japanese).

clc,clear
%-----------------------------------------建立模型--------------------
fprintf('65MN ThermoRegulation Model\n');
fprintf('Created by Di Mou at 10/26/2017\n');
fprintf('Reference: \n');
fprintf('S.Tanabe, J.Nakano, K.Kobayashi, Development of 65-Node thermoregulation-model for evaluation of thermal environment, Journal of Architectural Planning and Environmental Engineering(AIJ) 541 (2001) (in Japanese).\n\n');
Bd=Body();
Bd.addSegment(Profiles.Head,'Head');
Bd.addSegment(Profiles.Chest,'Chest');
Bd.addSegment(Profiles.Back,'Back');
Bd.addSegment(Profiles.Pelvis,'Pelvis');
Bd.addSegment(Profiles.Shoulder,'LShlder');
Bd.addSegment(Profiles.Shoulder,'RShlder');
Bd.addSegment(Profiles.Arm,'LArm');
Bd.addSegment(Profiles.Arm,'RArm');
Bd.addSegment(Profiles.Hand,'LHand');
Bd.addSegment(Profiles.Hand,'RHand');
Bd.addSegment(Profiles.Thigh,'LThigh');
Bd.addSegment(Profiles.Thigh,'RThigh');
Bd.addSegment(Profiles.Leg,'LLeg');
Bd.addSegment(Profiles.Leg,'RLeg');
Bd.addSegment(Profiles.Foot,'LFoot');
Bd.addSegment(Profiles.Foot,'RFoot');
Bd.showBasicProperties
Bd.initiallize
%--------------------------设置环境参数-------------------------------
Ta=10*ones(Bd.SegNum,1);
Tr=Ta;
RH=50*ones(Bd.SegNum,1);
Pa=Profiles.P(Ta,RH);
v=0.1*ones(Bd.SegNum,1);
Clo=zeros(Bd.SegNum,1);
Act=1;
Bd.setCondition(Ta,Tr,Pa,v,Clo,Act);
% ------------------------计算---------------------------------
Duration=3600;%计算时长
dt=60;%初始时间步长
Maxiteration=1e5;%最大迭代数
[dt,RealtStep,Tstep]=Bd.RunCalculation(Duration,dt,Maxiteration);
Bd.showT_all