bgm_sound.attachSound("bgm2");
bgm_sound.setVolume(50);
bgm_sound.onSoundComplete = function()
{
   this.start(6.4,1);
};
bgm_sound.start();
