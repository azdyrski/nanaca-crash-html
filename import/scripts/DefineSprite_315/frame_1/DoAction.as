function soundplay(vol)
{
   se_sound.setVolume(vol);
   if(vol >= 1)
   {
      this.gotoAndPlay("soundplay");
   }
}
this.stop();
_visible = false;
var se_sound = new Sound(this);
this.onUnload = function()
{
   se_sound.stop();
};
