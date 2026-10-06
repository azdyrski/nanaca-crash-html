function clearevent()
{
   clearInterval(intervalid);
}
function meter1()
{
   time = getTimer() - starttime;
   val = Math.round(time * rate1 % 180);
   meter1_mc._rotation = - Math.min(val,180 - val);
   updateAfterEvent();
}
function meter2()
{
   time = getTimer() - starttime;
   val = Math.round(time * rate2 % 200);
   meter2_mc._xscale = Math.min(val,200 - val);
   meter2_mc._yscale = meter2_mc._xscale;
   updateAfterEvent();
}
this.stop();
onUnload = clearevent;
clearevent();
delete this.onMouseUp;
delete this.onMouseDown;
this.release_mc._visible = false;
meter2_mc._xscale = 0;
meter2_mc._yscale = 0;
var rate1 = 0.18;
var rate2 = 0.3;
starttime = getTimer();
intervalid = setInterval(meter1,1);
this.onMouseDown = function()
{
   if(!btn.roll)
   {
      clearInterval(intervalid);
      delete this.onMouseDown;
      release_mc._visible = true;
      press_mc._visible = false;
      starttime = getTimer();
      intervalid = setInterval(meter2,1);
      this.onMouseUp = function()
      {
         clearInterval(intervalid);
         delete this.onMouseDown;
         delete this.onMouseUp;
         control.i_angle = - meter1_mc._rotation;
         control.i_power = meter2_mc._xscale;
         control.gamestart();
         press_mc._visible = false;
         release_mc._visible = false;
         this.play();
      };
   }
};
