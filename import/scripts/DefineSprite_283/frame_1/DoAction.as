function moveobj(ppx, py, mainscale, scalechange)
{
   if(scalechange)
   {
      this.scale = 100 / (100 / mainscale + z) / size;
      this._yscale = this.scale;
      this._xscale = this.scale;
   }
   this._x = ppx / (1 + z) % unitwidth / 100 * this.scale;
   this._y = py * size * 150 * (this.scale / 100);
   var _loc2_ = (450 - this._x) * 100 / scale;
   var _loc3_ = (-250 - this._x) * 100 / scale - mcwidth;
   unit1_mc._visible = unit1_mc._x > _loc3_;
   unit2_mc._visible = unit2_mc._x > _loc3_;
   unit3_mc._visible = true;
   unit4_mc._visible = unit4_mc._x < _loc2_;
   unit5_mc._visible = unit5_mc._x < _loc2_;
   unit6_mc._visible = unit6_mc._x < _loc2_;
}
this.stop();
var size = 0.5;
var z = 1;
var unitwidth = unit2_mc._x - unit1_mc._x;
var mcwidth = unit1_mc._width;
var scale;
