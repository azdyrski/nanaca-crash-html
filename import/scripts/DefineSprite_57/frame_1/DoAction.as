function changescene(scene, sound)
{
   slide_sound = sound;
   this.gotoAndPlay(scene);
   this.onEnterFrame = function()
   {
      slide_sound.setVolume(Math.max(slide_sound.getVolume() - 10,0));
   };
   this.onMouseDown = function()
   {
      this.gotoAndStop(scene + "skip");
   };
}
var slide_sound;
