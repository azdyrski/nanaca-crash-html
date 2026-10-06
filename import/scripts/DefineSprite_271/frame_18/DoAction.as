mask_mc.gotoAndStop(1);
panel_mc.currentbtn_mc = panel_mc.aboutbtn_mc;
count = 0;
onEnterFrame = function()
{
   count += 1;
   for(i in mask_mc)
   {
      if(typeof mask_mc[i] == "movieclip")
      {
         mask_mc[i]._xscale = 0.05925925925925926 * count * count * count * count + 100;
         mask_mc[i]._yscale = mask_mc[i]._xscale;
         if(count == 15)
         {
            delete onEnterFrame;
            delete onMouseDown;
         }
      }
   }
};
onMouseDown = function()
{
   count = 14;
   this.gotoAndStop("startend");
   onEnterFrame();
};
