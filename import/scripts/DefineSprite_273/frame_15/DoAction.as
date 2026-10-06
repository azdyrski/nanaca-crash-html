this.stop();
start_mc.stop();
this.start_btn._visible = false;
this.quality_mc.viewstop();
this.sound_mc.viewstop();
this.allenabled(false);
this.frames = 20;
this.vy = (- this.start_mc._y) / frames;
this.count = 0;
this.pt = 47;
this.sx = this._x + this.start_mc._x + this.start_mc._xscale / 100 * this.pt;
this.ex = 350;
this.vs = 1.26;
changer.changescene("start",new Sound(this));
start_mc.onEnterFrame = function()
{
   count += 1;
   this._xscale *= vs;
   this._yscale *= vs;
   this._x = (ex - sx) * count * count / frames / frames + sx - _X - this._xscale / 100 * pt;
   this._y += vy;
   if(count >= frames)
   {
      delete this.onEnterFrame;
   }
};
