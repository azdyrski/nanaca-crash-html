on(release){
   if(this.openstatus)
   {
      this.openstatus = false;
      pauser_btn._visible = false;
      pauser_btn.enabled = false;
      title_btn._visible = false;
      title_btn.enabled = false;
      meter_btn._visible = false;
      meter_btn.enabled = false;
      againr_btn._visible = false;
      againr_btn.enabled = false;
      quality_btn._visible = false;
      quality_btn.enabled = false;
      sound_btn._visible = false;
      sound_btn.enabled = false;
   }
   else
   {
      this.viewbtn();
   }
}
