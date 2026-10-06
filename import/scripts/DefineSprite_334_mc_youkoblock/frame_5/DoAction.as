this.stop();
if(control.nanaka)
{
   control.special.setstart();
   this.onEnterFrame = this.special;
}
else
{
   this.play();
}
