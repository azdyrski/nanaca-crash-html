this.stop();
count = 0;
onEnterFrame = function()
{
   count++;
   _X = (count / 10 - 1) * 250 * _xscale / 100 + initx;
   if(count >= 10)
   {
      delete onEnterFrame;
      active = true;
   }
};
