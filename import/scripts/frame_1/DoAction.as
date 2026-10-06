stopAllSounds();
delete onMouseDown;
var init;
this.play();
if(init == undefined)
{
   init = true;
   var version = 1.08;
   Stage.scaleMode = "noScale";
   var playerString = getVersion();
   index1 = playerString.indexOf(" ",0);
   index2 = playerString.indexOf(",",0);
   player = Number(playerString.substr(index1 + 1,index2 - index1 - 1));
   playererror = isNaN(player) || player < 7;
   if(playererror)
   {
      load_mc._visible = false;
   }
}
load_mc.view(this.getBytesLoaded() / this.getBytesTotal());
