function setstart()
{
   specialstatus = -1;
   _visible = true;
   timer = getTimer();
   onEnterFrame = function()
   {
      if(getTimer() - timer > 700)
      {
         delete onEnterFrame;
         delete onMouseDown;
         _visible = true;
         this.gotoAndPlay("ng");
      }
   };
   onMouseDown = function()
   {
      if(!btn.roll && !this.pauseflag)
      {
         _visible = true;
         delete onEnterFrame;
         delete onMouseDown;
         this.gotoAndPlay("ok");
      }
   };
   this.gotoAndPlay("wait");
}
function getstatus()
{
   return specialstatus;
}
this.stop();
_visible = false;
var specialstatus = 0;
var timer;
