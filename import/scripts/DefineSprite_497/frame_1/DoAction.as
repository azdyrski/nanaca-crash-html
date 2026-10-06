function view(score, breakscore)
{
   var _loc3_;
   if(val != score)
   {
      val = score;
      _loc3_ = String(Math.floor(score) + "." + Math.floor((Math.abs(score) + 1) * 100).toString().substr(-2));
      score_txt.text = _loc3_;
      if(breakscore)
      {
         if(!changed)
         {
            changed = true;
            this.nextFrame();
            new Color(this).setRGB(16711680);
         }
         return _loc3_;
      }
   }
   return null;
}
this.stop();
score_txt.autoSize = "right";
var changed = false;
var val = null;
view(0,false);
