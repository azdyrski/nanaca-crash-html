this.stop();
typea_mc._visible = false;
typeb_mc._visible = false;
typec_mc._visible = false;
typed_mc._visible = false;
switch(cfftype)
{
   case control.characode.misato:
      typea_mc._visible = true;
      break;
   case control.characode.touko:
      typeb_mc._visible = true;
      break;
   case control.characode.kiri:
      typec_mc._visible = true;
      break;
   case control.characode.miki:
      typed_mc._visible = true;
}
