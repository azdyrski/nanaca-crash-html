control.setspecial(code.misato,true);
new Color(taichi_mc).setTransform(new Color(hittarget).getTransform());
hittarget._visible = false;
this.taichi_mc._y = (- control.py) * 150;
this.taichi_mc._x = (control.px - this.px) * 150;
this.taichi_mc.dx = (275 - (control.px - this.px) * 150) / 24;
this.taichi_mc.dy = (control.py * 150 - 300) / 24;
this.taichi_mc._rotation = control.r;
taichi_mc.dr = 15;
control.backeffect("combo");
movecount = 0;
moveobjsub = function()
{
   miki3_mc._y = miki2_mc._y;
   miki3_mc._x = miki2_mc._x;
   miki2_mc._y = miki1_mc._y;
   miki2_mc._x = miki1_mc._x;
   miki3._visible = miki3_mc._y == miki2_mc._y && miki3_mc._x == miki2_mc._x;
   miki2._visible = miki2_mc._y == miki1_mc._y && miki2_mc._x == miki1_mc._x;
   kiri3_mc._y = kiri2_mc._y;
   kiri3_mc._x = kiri2_mc._x;
   kiri3_mc._rotation = kiri2_mc._rotation;
   kiri2_mc._y = kiri1_mc._y;
   kiri2_mc._x = kiri1_mc._x;
   kiri2_mc._rotation = kiri1_mc._rotation;
   kiri3._visible = kiri3_mc._y == kiri2_mc._y && kiri3_mc._x == kiri2_mc._x;
   kiri2._visible = kiri2_mc._y == kiri1_mc._y && kiri2_mc._x == kiri1_mc._x;
   if(movecount <= 40)
   {
      miki1_mc._y = ((movecount - 20) * (movecount - 20) / 400 - 1) * 275;
      miki1_mc._x = movecount * 200 / 40;
   }
   if(movecount >= 6)
   {
      if(movecount <= 17)
      {
         kiri1_mc._y = -150 + (movecount - 6) / 11 * 150;
         kiri1_mc._x = -400 + (movecount - 6) / 11 * 400;
      }
      else if(movecount <= 25)
      {
         kiri1_mc._y = (- (movecount - 17)) / 8 * 275;
         kiri1_mc._x = (movecount - 17) / 8 * 275;
         kiri1_mc._rotation = (movecount - 17) / 8 * 360;
         kiri1_mc._y += -75 + 79.05694150420949 * Math.sin(1.2490457723982544 + 6.283185307179586 * (movecount - 17) / 8);
         kiri1_mc._x += -25 + 79.05694150420949 * Math.cos(1.2490457723982544 + 6.283185307179586 * (movecount - 17) / 8);
      }
      else if(movecount <= 34)
      {
         kiri1_mc._y = -275 - (movecount - 25) / 9 * 25;
         kiri1_mc._x = 275 + (movecount - 25) / 9 * 75;
      }
      else if(movecount <= 56)
      {
         kiri1_mc._y = -300 + (movecount - 34) * (movecount - 34) / 484 * 300;
         kiri1_mc._x = 350 + (movecount - 34) / 22 * 150;
      }
   }
   taichi_mc._x += taichi_mc.dx;
   taichi_mc._y += taichi_mc.dy;
   taichi_mc._rotation += taichi_mc.dr;
   movecount++;
};
