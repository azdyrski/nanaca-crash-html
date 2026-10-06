function moveobj(px, py, r, scale, changescale)
{
   var _loc2_ = -25000 / scale;
   var _loc3_ = 45000 / scale;
   taichi_mc.moveobj(py,r,scale);
   if(changescale)
   {
      _xscale = scale;
      _yscale = scale;
   }
   nanaka_mc.moveobj(px,_loc2_);
   youko_mc.moveobj(px,py,scale,_loc2_,_loc3_);
   miki_mc.moveobj(px,py,scale,_loc2_,_loc3_);
   kiri_mc.moveobj(px,py,scale,_loc2_,_loc3_);
   touko_mc.moveobj(px,py,scale,_loc2_,_loc3_);
   tomoki_mc.moveobj(px,py,scale,_loc2_,_loc3_);
   misato_mc.moveobj(px,py,scale,_loc2_,_loc3_);
   sakuraba_mc.moveobj(px,py,scale,_loc2_,_loc3_);
}
this.stop();
sscale = 7000;
escale = 100;
sx = -84.75;
ex = -100;
sy = -300;
ey = -200;
frames = 15;
this._xscale = sscale;
this._yscale = sscale;
this._x = 350 - sx * sscale / 100;
this._y = 200 - sy * sscale / 100;
count = 0;
onEnterFrame = function()
{
   dt = count * count / frames / frames;
   scale = 1 / ((1 / escale - 1 / sscale) * dt + 1 / sscale);
   px = (ex - sx) * dt + sx;
   py = (ey - sy) * dt + sy;
   this._xscale = scale;
   this._yscale = scale;
   this._x = 350 - px * scale / 100;
   this._y = 200 - py * scale / 100;
   count += 1;
   if(count > frames)
   {
      delete this.onEnterFrame;
      control.main.gotoAndPlay("standby");
   }
};
