control.vx = 0;
control.vy = 0;
control.py = 0;
control.slow(0,0.03333333333333333);
if(control.cffs == 1)
{
   hittarget._visible = true;
   stop_mc._visible = false;
   this.gotoAndPlay("cffb");
}
