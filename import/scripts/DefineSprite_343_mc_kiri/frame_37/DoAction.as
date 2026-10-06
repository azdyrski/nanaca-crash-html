control.vpush();
control.speedblind(true);
control.combo = true;
new Color(taichi_mc).setTransform(new Color(hittarget).getTransform());
hittarget._visible = false;
control.slow(100,0.01);
control.vx = ((this.px - control.px) * 150 + 700) / 41 / 150 / 0.01;
control.vy = 0;
control.nogravity = true;
this.taichi_mc._rotation = control.r;
this.taichi_mc._y = (- control.py) * 150;
this.taichi_mc._x = (control.px - this.px) * 150;
this.taichi_mc.dx = (550 - (control.px - this.px) * 150) / 41;
this.taichi_mc.dy = (control.py * 150 - 100) / 41;
this.taichi_mc.dr = 5;
movecount = 0;
moveobjsub = function()
{
   kiri3_mc._y = kiri2_mc._y;
   kiri3_mc._x = kiri2_mc._x;
   kiri3_mc._rotation = kiri2_mc._rotation;
   kiri2_mc._y = kiri1_mc._y;
   kiri2_mc._x = kiri1_mc._x;
   kiri2_mc._rotation = kiri1_mc._rotation;
   kiri3._visible = kiri3_mc._y == kiri2_mc._y && kiri3_mc._x == kiri2_mc._x;
   kiri2._visible = kiri2_mc._y == kiri1_mc._y && kiri2_mc._x == kiri1_mc._x;
   if(movecount <= 12)
   {
      kiri1_mc._x = movecount / 12 * 400;
   }
   else if(movecount <= 23)
   {
      kiri1_mc._y = (- (movecount - 12)) / 11 * 125;
   }
   else if(movecount <= 34)
   {
      kiri1_mc._y = -125 + (movecount - 23) / 11 * 125;
      kiri1_mc._x = 400 + (movecount - 23) / 11 * 175;
      kiri1_mc._rotation = (movecount - 23) / 11 * 360;
      kiri1_mc._y += -75 + 79.05694150420949 * Math.sin(1.2490457723982544 + 6.283185307179586 * (movecount - 23) / 11);
      kiri1_mc._x += -25 + 79.05694150420949 * Math.cos(1.2490457723982544 + 6.283185307179586 * (movecount - 23) / 11);
   }
   taichi_mc._x += taichi_mc.dx;
   taichi_mc._y += taichi_mc.dy;
   taichi_mc._rotation += taichi_mc.dr;
   movecount++;
};
