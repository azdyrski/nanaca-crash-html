function moveobj(ppx)
{
   this._x = Math.floor(ppx / 300) % unitwidth;
   var _loc2_ = 450 - this._x;
   var _loc3_ = -250 - this._x - mcwidth;
   unit1_mc._visible = unit1_mc._x > _loc3_;
   unit2_mc._visible = unit2_mc._x < _loc2_;
}
this.stop();
var unitwidth = unit2_mc._x - unit1_mc._x;
var mcwidth = unit1_mc._width;
