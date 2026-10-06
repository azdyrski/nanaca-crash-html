control.vpop();
control.boost(s_power,s_angle);
control.speedblind(false);
control.nogravity = false;
hittarget._visible = true;
control.r = taichi_mc._rotation;
taichi_mc._visible = false;
