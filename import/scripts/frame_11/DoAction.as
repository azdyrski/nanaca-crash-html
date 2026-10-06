this.title_mc.changer = changer_mc;
control.localsave();
wait = "wait2";
prevact = function()
{
   this.gotoAndStop(1);
};
nextact = function()
{
   this.gotoAndStop("game");
};
delete onMouseDown;
this.gotoAndStop(wait);
