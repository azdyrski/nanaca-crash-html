function view(loaded)
{
   mask_mc._y = inity - loaded * mask_mc._height;
   var _loc1_ = Math.floor(loaded * 100).toString();
   n1_mc.num = _loc1_.charAt(_loc1_.length - 1);
   n2_mc.num = _loc1_.charAt(_loc1_.length - 2);
   n3_mc.num = _loc1_.charAt(_loc1_.length - 3);
}
this.stop();
var inity = mask_mc._y;
