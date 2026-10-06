this.stop();
control.setspecial(code.misato,true);
control.setspecial(code.touko,false);
if(control.miki)
{
   control.special.setstart();
   specialwait = true;
}
else
{
   this.play();
}
