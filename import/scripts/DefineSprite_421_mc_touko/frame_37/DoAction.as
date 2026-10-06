control.vpush();
control.speedblind(true);
control.slow(1000,0);
this.taichi_mc._y = (- control.py) * 150;
this.taichi_mc._x = (control.px - this.px) * 150;
this.taichi_mc.dx = (275 - (control.px - this.px) * 150) / 62;
this.taichi_mc.dy = (control.py * 150 - 100) / 62;
this.taichi_mc.dr = 5;
this.taichi_mc._rotation = control.r;
control.py = 0.6666666666666666;
new Color(taichi_mc).setTransform(new Color(hittarget).getTransform());
hittarget._visible = false;
movecount = 0;
moveobjsub = function()
{
   taichi_mc._x += taichi_mc.dx;
   taichi_mc._y += taichi_mc.dy;
   taichi_mc._rotation += taichi_mc.dr;
   movecount++;
};
