this.taichi_mc.dx = 0;
this.taichi_mc.dy = 0;
this.taichi_mc.dr = 0;
control.vpush();
control.speedblind(true);
control.vx = (this.px - control.px) / 39 / 0.01;
if(control.vx < 0)
{
   control.vx = 0;
}
control.vy = 0;
control.nogravity = true;
control.slow(50,0.01);
