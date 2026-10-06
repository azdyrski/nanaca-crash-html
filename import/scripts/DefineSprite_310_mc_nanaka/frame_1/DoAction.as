function aerial(upper)
{
   control.hitenabled = false;
   control.slow(1000,0);
   movecount = 0;
   moveobjsub = function()
   {
      movecount++;
      this._xscale = (1 - movecount / 10) * 100;
      this._yscale = movecount / 10 * 200 + 100;
      if(movecount >= 10)
      {
         this._xscale = 100;
         this._yscale = 100;
         _rotation = 0;
         px = control.px;
         _X = 0;
         _Y = (- control.py) * 150;
         delete moveobjsub;
         maxx = 0;
         if(upper)
         {
            this.gotoAndPlay("aerialu");
         }
         else
         {
            this.gotoAndPlay("aeriald");
         }
      }
   };
}
function cff(typecode)
{
   hittarget = control.taichi;
   _rotation = 0;
   px = control.px;
   _X = 0;
   _Y = 0;
   cfftype = typecode;
   maxx = 401.1;
   this.gotoAndPlay("special");
}
function moveobj(px, xMin)
{
   this._x = (this.px - px) * 150;
   this._visible = this._x + maxx > xMin;
   moveobjsub();
}
this.stop();
var maxx = 103;
code = control.characode;
charatype = code.nanaka;
px = -0.6666666666666666;
