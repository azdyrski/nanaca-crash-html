this.stop();
targetdagger._visible = false;
targetdagger.gotoAndStop(1);
count = 0;
this.onEnterFrame = function()
{
   count++;
   _X = (- count) / 10 * 250 / 100 * _xscale + initx;
   if(count >= 10)
   {
      delete onEnterFrame;
      this.play();
   }
};
