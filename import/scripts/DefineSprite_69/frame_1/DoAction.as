function init()
{
   if(control.globalsound.getVolume() == 0)
   {
      on_mc._visible = false;
      off_mc._visible = true;
      currentmode = false;
   }
   else
   {
      on_mc._visible = true;
      off_mc._visible = false;
      currentmode = true;
   }
}
function viewin(target_mc)
{
   target_mc._visible = true;
}
function viewout(target_mc)
{
   depth = (depth + 1) % 100;
   copy_mc = target_mc.duplicateMovieClip(getTimer(),depth);
   target_mc._visible = false;
   for(i in copy_mc)
   {
      if(typeof copy_mc[i] == "movieclip")
      {
         if(copy_mc[i].px == null || copy_mc[i].py == undefined)
         {
            copy_mc[i].px = copy_mc[i]._x;
            copy_mc[i].py = copy_mc[i]._y;
         }
         copy_mc[i]._rotation = 0;
         copy_mc[i].r = Math.random() * 20;
         copy_mc[i]._x = copy_mc[i].px;
         copy_mc[i]._y = copy_mc[i].py;
         copy_mc[i].orgscale = copy_mc[i]._yscale;
         copy_mc[i].count = 0;
         copy_mc[i].onEnterFrame = function()
         {
            this.count += 1;
            this._x = this.px + this.px * this.count / 30;
            this._y = this.py + this.count * this.count / 3;
            this._rotation = this.r * this.count;
            this._xscale = (1 + this.count / 30) * this.orgscale;
            this._yscale = this._xscale;
            if(this._y >= 200)
            {
               this._xscale = 100;
               this._yscale = 100;
               this._rotation = 0;
               this._x = this.px;
               this._y = this.py;
               delete this.onEnterFrame;
               this._parent.removeMovieClip();
            }
         };
      }
   }
}
function viewstart()
{
   this.onEnterFrame = function()
   {
      if(control.globalsound.getVolume() != 0 != currentmode)
      {
         currentmode = !currentmode;
         this.gotoAndPlay("change");
         if(currentmode)
         {
            viewout(off_mc);
            viewin(on_mc);
         }
         else
         {
            viewout(on_mc);
            viewin(off_mc);
         }
      }
   };
}
function viewstop()
{
   delete this.onEnterFrame;
}
this.stop();
depth = 0;
init();
viewstart();
