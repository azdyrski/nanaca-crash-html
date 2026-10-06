control.setspecial(code.misato,true);
new Color(taichi_mc).setTransform(new Color(hittarget).getTransform());
hittarget._visible = false;
this.taichi_mc._y = (- control.py) * 150;
this.taichi_mc._x = (control.px - this.px) * 150;
this.taichi_mc.dx = (250 - (control.px - this.px) * 150) / 24;
this.taichi_mc.dy = (control.py * 150 - 300) / 24;
this.taichi_mc._rotation = control.r;
taichi_mc.dr = 15;
control.backeffect("combo");
movecount = 0;
moveobjsub = function()
{
   kiri3_mc._y = kiri2_mc._y;
   kiri3_mc._x = kiri2_mc._x;
   kiri2_mc._y = kiri1_mc._y;
   kiri2_mc._x = kiri1_mc._x;
   kiri3._visible = kiri3_mc._y == kiri2_mc._y && kiri3_mc._x == kiri2_mc._x;
   kiri2._visible = kiri2_mc._y == kiri1_mc._y && kiri2_mc._x == kiri1_mc._x;
   miki3_mc._y = miki2_mc._y;
   miki3_mc._x = miki2_mc._x;
   miki2_mc._y = miki1_mc._y;
   miki2_mc._x = miki1_mc._x;
   miki3._visible = miki3_mc._y == miki2_mc._y && miki3_mc._x == miki2_mc._x;
   miki2._visible = miki2_mc._y == miki1_mc._y && miki2_mc._x == miki1_mc._x;
   if(movecount <= 40)
   {
      kiri1_mc._y = ((movecount - 20) * (movecount - 20) / 400 - 1) * 175;
      kiri1_mc._x = movecount * 350 / 40;
   }
   if(movecount >= 6)
   {
      if(movecount <= 17)
      {
         miki1_mc._y = -125 + (movecount - 6) / 11 * 125;
         miki1_mc._x = -375 + (movecount - 6) / 11 * 375;
      }
      else if(movecount <= 25)
      {
         miki1_mc._y = (- (movecount - 17)) / 8 * 275;
         miki1_mc._x = (movecount - 17) / 8 * 275;
      }
      else if(movecount <= 34)
      {
         miki1_mc._y = -275 - (movecount - 25) / 9 * 25;
         miki1_mc._x = 275 + (movecount - 25) / 9 * 75;
      }
      else if(movecount <= 55)
      {
         miki1_mc._y = -300 + (movecount - 34) * (movecount - 34) / 441 * 300;
         miki1_mc._x = 350 + (movecount - 34) / 21 * 125;
      }
   }
   taichi_mc._x += taichi_mc.dx;
   taichi_mc._y += taichi_mc.dy;
   taichi_mc._rotation += taichi_mc.dr;
   movecount++;
};
