back_mc._visible = false;
count = 0;
this.onEnterFrame = function()
{
   count++;
   crash_mc._alpha = (control.i_power * 25 - 100 * count) / 5 + 100;
   crash_mc._x = -200 * count / 30 + 450;
   chara_mc._x = 450 - 6.666666666666667 * count;
   if(crash_mc._alpha < 100)
   {
      back_mc._visible = true;
   }
   if(crash_mc._alpha <= 0)
   {
      crash_mc._visible = false;
   }
   if(count >= 30)
   {
      delete this.onEnterFrame;
   }
};
