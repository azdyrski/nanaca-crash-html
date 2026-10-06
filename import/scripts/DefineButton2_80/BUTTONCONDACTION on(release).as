on(release){
   if(control.globalsound.getVolume() == 0)
   {
      control.globalsound.setVolume(100);
      bgm_mc.soundRestart();
      control.localset();
   }
   else
   {
      control.globalsound.setVolume(0);
      bgm_mc.soundStop();
      control.localset();
   }
}
