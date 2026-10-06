class GameCharaFace extends MovieClip
{
   var arrow_mc;
   var basex;
   var pointy;
   var point = new Object();
   function GameCharaFace()
   {
      super();
      this._visible = false;
      this.stop();
      this.arrow_mc.stop();
      this.basex = this._parent._x;
      this.pointy = 370 - this._parent._y;
   }
   function view(px, scale)
   {
      var _loc2_;
      var _loc3_;
      this._x = Math.floor((px / 150 + 1) / 10) * 31.25;
      if(this._x >= 0)
      {
         this._visible = true;
         _loc2_ = px * scale / 100 + 250 - this._x - this.basex;
         _loc3_ = this.pointy / Math.sqrt(this.pointy * this.pointy + _loc2_ * _loc2_);
         this.arrow_mc._xscale = 100 / _loc3_;
         this.arrow_mc._yscale = 100 * _loc3_;
         this.arrow_mc._rotation = Math.atan2(this.pointy,_loc2_) * 180 / 3.141592653589793;
      }
      else
      {
         this._visible = false;
      }
   }
}
