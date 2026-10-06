control.vpop();
control.nogravity = false;
control.boost(s_power,s_angle);
control.speedblind(false);
hittarget._visible = true;
control.px += 0.3;
control.py += 0.3;
control.slow2(20,0.5);
control.backeffect("misato");
