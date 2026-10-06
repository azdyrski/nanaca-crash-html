control.localsave();
control.main = main_mc;
control.initialize();
this.main_mc.changer = changer_mc;
this.main_mc.gotoAndStop("stop");
wait = "wait3";
prevact = function()
{
   this.gotoAndStop("title");
};
nextact = function()
{
   this.gotoAndStop(wait);
};
delete onMouseDown;
this.gotoAndStop(wait);
