function special()
{
   st = control.special.getstatus();
   if(st == 0)
   {
      delete this.onEnterFrame;
      this.play();
   }
   else if(st == 1)
   {
      delete this.onEnterFrame;
      control.cff(cfftype);
      this.gotoAndPlay("special");
   }
}
code = control.characode;
control.slow(1000,0);
