function hop(x, y)
{
   if(this.px == null || this.px == undefined)
   {
      this.py = this._y;
      this.px = this._x;
   }
   this.ex = 575 - x - this.px * 50 / 100;
   this.ey = 300 - y - this.py * 50 / 100;
   this.rot = Math.floor(Math.random() * 4) - 1;
   this.peakx = Math.random() * 450 - 450;
   this.peaky = Math.random() * 300 - 300;
   this.offset = Math.floor((this.px + 150) / 40);
   this.frames = 20;
   this.count = this.frames;
   this.offset2 = Math.floor(Math.random() * 15);
   this.frames2 = 50 - this.offset2;
   this.count2 = this.frames2;
   this.action = function()
   {
      if(this.count > -10)
      {
         this._x = this.px;
         this._y = -100 * Math.max(0,Math.sin(3.141592653589793 * (this.offset + this.count) / this.frames)) + this.py;
         this._xscale = 100 * Math.cos(6.283185307179586 * Math.min(Math.max(this.offset + this.count,0),this.frames) / this.frames);
         this._yscale = 100;
         this.count -= 1;
         this._rotation = 0;
      }
      else if(this.offset2 > 0)
      {
         this.offset2 -= 1;
      }
      else
      {
         this._x = this.peakx * Math.sin(3.141592653589793 * (1 - this.count2 / this.frames2)) + this.ex * (1 - this.count2 / this.frames2) + this.px;
         this._y = this.peaky * Math.sin(3.141592653589793 * (1 - this.count2 / this.frames2)) + this.ey * (1 - this.count2 / this.frames2) + this.py;
         this._xscale = (99 * this.count2 / this.frames2 + 50 - 49) * Math.sin(6.283185307179586 * (1 - this.count2 / this.frames2)) + 50 * this.count2 / this.frames2 + 50;
         this._yscale = this._xscale;
         this._rotation = -360 * this.rot * this.count2 / this.frames2;
         this.count2 -= 1;
         if(this.count2 < -1)
         {
            delete this.onEnterFrame;
            gotoAndStop("title");
         }
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
         targetmc[i].hop(basemc._x,basemc._y);
      }
   }
}
_global.control = new GameControl();
control.globalsound = new Sound();
control.dataversion = version;
control.localload();
hopset(load2_mc,load2_mc);
wait = "wait1";
prevact = function()
{
   this.gotoAndStop(1);
};
nextact = function()
{
   this.gotoAndStop("title");
};
onMouseDown = function()
{
   this.gotoAndStop("title");
};
this.gotoAndStop(wait);
