on(release){
   about_mc.stop();
   aerial_mc.stop();
   special_mc.stop();
   chara_mc.stop();
   delete about_mc.onEnterFrame;
   delete aerial_mc.onEnterFrame;
   delete special_mc.onEnterFrame;
   delete chara_mc.onEnterFrame;
   this._parent.gotoAndPlay("hide");
}
