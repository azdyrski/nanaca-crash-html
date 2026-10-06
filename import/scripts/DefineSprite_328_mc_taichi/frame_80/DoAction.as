control.slow(14,0);
control.hitenabled = true;
var count = 0;
this._xscale = 100;
this._yscale = 100;
this.boost_mc._xscale = 70;
this.boost_mc._yscale = 70;
this.boost_mc._x = -80;
this.boost_mc._y = -50;
this.onEnterFrame = function()
{
   if(count < 20)
   {
      count += 1;
      this._xscale = 100 + 50 * Math.sin(0.3141592653589793 * count);
      this._yscale = 100 - 50 * Math.sin(0.3141592653589793 * count);
      this.boost_mc._xscale = 100 / this._xscale * 70;
      this.boost_mc._yscale = 100 / this._yscale * 70;
      this.boost_mc._x = 100 / this._xscale * -80;
      this.boost_mc._y = 100 / this._yscale * -50 - count * 5;
   }
   else
   {
      count = null;
      delete this.onEnterFrame;
   }
};
