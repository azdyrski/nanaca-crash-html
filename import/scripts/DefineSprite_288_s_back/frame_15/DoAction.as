this.stop();
px = -200;
count = 0;
this.onEnterFrame = function()
{
   count++;
   px = -200 + 6.666666666666667 * count;
   tree_mc.moveobj(- px,0,scale,true);
   rail_mc.moveobj(- px,0,scale,true);
   if(control.i_power / 100 * 30 <= count)
   {
   }
   if(count == 30)
   {
      this.play();
      delete this.onEnterFrame;
   }
};
