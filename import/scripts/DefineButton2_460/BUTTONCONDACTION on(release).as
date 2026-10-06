on(release){
   if(control.globalsound.getVolume() == 0)
   {
      control.globalsound.setVolume(100);
      control.localset();
      _parent.bgm_mc.soundRestart();
   }
   else
   {
      control.globalsound.setVolume(0);
      control.localset();
      _parent.bgm_mc.soundStop();
   }
   this.soundtext();
}
