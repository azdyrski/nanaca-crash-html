function view()
{
   if(control.youko)
   {
      base_mc._visible = false;
      youko_mc._visible = true;
      misato_mc._visible = false;
      touko_mc._visible = false;
      kiri_mc._visible = false;
      miki_mc._visible = false;
      if(control.nanaka)
      {
         nanaka_mc._visible = true;
         misatod_mc._visible = false;
         toukod_mc._visible = false;
         kirid_mc._visible = false;
         mikid_mc._visible = false;
      }
      else
      {
         nanaka_mc._visible = false;
         misatod_mc._visible = true;
         toukod_mc._visible = true;
         kirid_mc._visible = true;
         mikid_mc._visible = true;
      }
   }
   else
   {
      youko_mc._visible = false;
      nanaka_mc._visible = false;
      base_mc._visible = true;
      misato_mc._visible = control.misato;
      touko_mc._visible = control.touko;
      kiri_mc._visible = control.kiri;
      miki_mc._visible = control.miki;
      misatod_mc._visible = !control.misato;
      toukod_mc._visible = !control.touko;
      kirid_mc._visible = !control.kiri;
      mikid_mc._visible = !control.miki;
   }
}
view();
