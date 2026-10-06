function allenabled(enable)
{
   start_btn.enabled = enable;
   howto_btn.enabled = enable;
   quality_btn.enabled = enable;
   sound_btn.enabled = enable;
   clear_btn.enabled = enable;
}
function hop(base_mc)
{
   this.py = this._y;
   this.px = this._x;
   this.orgscale = this._yscale;
   this.rot = Math.random() * 20 + 5;
   this.startx = 225 + this.px / 4;
   this.starty = 100;
   frames = 40;
   this.peak = - Math.random() * ((base_mc._y + this.starty) / 2 + 200);
   this.a = (- this.peak) / (frames * frames) * 4;
   this.v0 = this.peak / frames * 4;
   count = frames;
   this.action = function()
   {
      this._x = (this.startx - base_mc._x - this.px) * count / frames + this.px;
      this._y = this.a * count * count + this.v0 * count + (this.starty - base_mc._y - this.py) * count / frames + this.py;
      this._xscale = this.orgscale * (1 - 0.5 * count / frames);
      this._yscale = this._xscale;
      this._rotation = this.rot * count;
      if(count == 0)
      {
         base_mc.enabled = true;
         delete this.onEnterFrame;
      }
   };
   this.onEnterFrame = this.action;
   this.action();
}
function hopset(targetmc, basemc)
{
   for(i in targetmc)
   {
      if(typeof targetmc[i] == "movieclip")
      {
         targetmc[i].hop = this.hop;
         targetmc[i].hop(basemc);
      }
   }
}
new Sound(this).setVolume(100);
this.allenabled(false);
hopset(clear_btn,clear_btn);
hopset(start_btn,start_btn);
hopset(title_mc,title_mc);
hopset(howto_btn,howto_btn);
hopset(quality_btn,quality_btn);
hopset(quality_mc.h_mc,quality_mc);
hopset(quality_mc.m_mc,quality_mc);
hopset(quality_mc.l_mc,quality_mc);
hopset(sound_btn,sound_btn);
hopset(sound_mc.on_mc,sound_mc);
hopset(sound_mc.off_mc,sound_mc);
hopset(best_mc,best_mc);
this.quality_mc.base_btn = quality_btn;
onEnterFrame = function()
{
   if(count == 0)
   {
      delete onEnterFrame;
      delete onMouseDown;
   }
   else
   {
      count--;
   }
};
onMouseDown = function()
{
   count = 0;
   this.gotoAndStop("introend");
};
