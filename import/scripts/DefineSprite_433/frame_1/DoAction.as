function view(y)
{
   if(y > 14)
   {
      this._visible = true;
      if(val != y)
      {
         val = y;
         height_txt.text = String(Math.floor(y) + "." + Math.floor((Math.abs(y) + 1) * 100).toString().substr(-2));
      }
   }
   else
   {
      this._visible = false;
   }
}
this.stop();
height_txt.autoSize = "right";
var val = 0;
