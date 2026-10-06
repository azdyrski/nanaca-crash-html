count = 15;
onEnterFrame = function()
{
   count -= 1;
   for(i in mask_mc)
   {
      if(typeof mask_mc[i] == "movieclip")
      {
         mask_mc[i]._xscale = 0.05925925925925926 * count * count * count * count + 100;
         mask_mc[i]._yscale = mask_mc[i]._xscale;
         if(count == 0)
         {
            delete onEnterFrame;
            delete onMouseDown;
         }
      }
   }
};
onMouseDown = function()
{
   count = 1;
   this.gotoAndStop("hideend");
   onEnterFrame();
};
