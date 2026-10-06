function soundStop()
{
   bgm_sound.stop();
}
function soundStart(track)
{
   this.gotoAndStop(track + 1);
}
function soundRestart()
{
   bgm_sound.stop();
   bgm_sound.start();
}
this.stop();
this._visible = false;
var bgm_sound = new Sound(this);
this.onUnload = function()
{
   bgm_sound.stop();
};
