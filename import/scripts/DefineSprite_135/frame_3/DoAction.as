bgm_sound.attachSound("bgm1");
bgm_sound.setVolume(25);
bgm_sound.onSoundComplete = function()
{
   this.start(24,1);
};
bgm_sound.start();
