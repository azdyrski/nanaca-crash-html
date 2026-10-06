this.stop();
new Color(misato_mc.taichi_mc).setTransform(new Color(hittarget).getTransform());
control.slow(1000,0);
hittarget._visible = false;
control.setspecial(code.touko,false);
if(control.misato)
{
   control.special.setstart();
   specialwait = true;
}
else
{
   this.play();
}
