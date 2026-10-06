control.nogravity = false;
control.vx = 30;
control.vy = 1;
control.slow2(20,1);
control.py = (- taichi_mc._y) / 150;
control.r = taichi_mc._rotation;
hittarget._visible = true;
taichi_mc._visible = false;
delete moveobjsub;
