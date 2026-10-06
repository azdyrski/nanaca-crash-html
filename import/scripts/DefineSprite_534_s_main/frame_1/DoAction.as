function backeffect(effect, param)
{
   this.effectparam = param;
   this.gotoAndPlay(effect);
}
function moveobj(px, py, r, scale, changescale)
{
   chara_mc.moveobj(px,py,r,scale,changescale);
   back_mc.moveobj((- px) * 150,scale,changescale);
   this.scale = scale;
}
function changecolor(color)
{
   new Color(this.out_mc.taichi_mc).setTransform(color);
}
function viewscore(px, py, breakscore, vx, vy)
{
   out_mc.view(py);
   highscore_mc.view(score_mc.view(px,breakscore));
   speed_mc.view(vx,vy);
   specialchara_mc.view();
}
function gameover()
{
   this.menu_mc.gameover();
   score_mc.count = 0;
   score_mc.onEnterFrame = function()
   {
      this.count = this.count + 1;
      this._xscale = 100 + 100 * this.count / 10;
      this._yscale = 100 + 100 * this.count / 10;
      this._x = -87.5 * this.count / 10 + 687.5;
      this._y = 159.4 * this.count / 10 + 25.6;
      if(this.count >= 10)
      {
         delete this.onEnterFrame;
      }
   };
   mysound = new Sound(this);
   this.onEnterFrame = function()
   {
      mysound.setVolume(Math.max(mysound.getVolume() - 1,0));
      if(mysound.getVolume() <= 0)
      {
         delete this.onEnterFrame;
      }
   };
}
this.stop();
this.allpauseplay();
var effectparam;
var scale;
this.chara_mc.gotoAndStop("stop");
this.back_mc.gotoAndStop("stop");
this.back_mc._visible = true;
delete this.onEnterFrame;
new Sound(this).setVolume(100);
