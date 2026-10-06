this.stop();
control.setspecial(code.misato,true);
control.setspecial(code.touko,false);
if(control.kiri)
{
   control.special.setstart();
   specialwait = true;
}
else
{
   this.play();
}
