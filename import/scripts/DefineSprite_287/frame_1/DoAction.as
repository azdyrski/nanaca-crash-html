function moveobj(ppx, py, scale, scalechange)
{
   if(scalechange)
   {
      this._yscale = scale;
      this._xscale = scale;
   }
   this._x = ppx % unitwidth * scale / 100;
   this._y = py * 150 * scale / 100;
   var _loc3_ = (450 - this._x) * 100 / scale;
   var _loc4_ = (-250 - this._x) * 100 / scale - unitwidth;
   unit1_mc._visible = unit1_mc._x > _loc4_;
   unit2_mc._visible = unit2_mc._x > _loc4_;
   unit4_mc._visible = unit4_mc._x < _loc3_;
   unit5_mc._visible = unit5_mc._x < _loc3_;
   unit6_mc._visible = unit6_mc._x < _loc3_;
}
this.stop();
var unitwidth = unit2_mc._x - unit1_mc._x;
