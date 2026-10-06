control.vpush();
control.speedblind(true);
control.combo = true;
hittarget._visible = false;
control.slow(100,0.01);
control.vx = ((this.px - control.px) * 150 + 250) / 30 / 150 / 0.01;
control.vy = 0;
control.nogravity = true;
new Color(taichi_mc).setTransform(new Color(hittarget).getTransform());
this.taichi_mc._y = (- control.py) * 150;
this.taichi_mc._rotation = control.r;
this.taichi_mc._x = (control.px - this.px) * 150;
this.taichi_mc.dx = (225 - this.taichi_mc._x) / 30;
this.taichi_mc.dy = (control.py * 150 - 525) / 13;
this.taichi_mc.dr = 15;
movecount = 0;
moveobjsub = function()
{
   miki3_mc._y = miki2_mc._y;
   miki3_mc._x = miki2_mc._x;
   miki3_mc._xscale = miki2_mc._xscale;
   miki2_mc._y = miki1_mc._y;
   miki2_mc._x = miki1_mc._x;
   miki2_mc._xscale = miki1_mc._xscale;
   if(movecount <= 14)
   {
      miki1_mc._y = (- movecount) / 14 * 450;
      miki1_mc._xscale = 100 * Math.cos(movecount / 14 * 2 * 3.141592653589793);
   }
   else if(movecount <= 23)
   {
      miki1_mc._y = -450 + (movecount - 14) / 9 * 450;
   }
   else if(movecount <= 31)
   {
      miki1_mc._x = (movecount - 23) / 8 * 300;
      miki1_mc._y = (- (movecount - 23)) / 8 * 175;
      miki1_mc._xscale = -100;
   }
   taichi_mc._x += taichi_mc.dx;
   taichi_mc._y += taichi_mc.dy;
   taichi_mc._rotation += taichi_mc.dr;
   movecount++;
};
