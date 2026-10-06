function view(aerialstatus, fall, intervaltime)
{
   if(aerialstatus)
   {
      downercount = Math.min(100,downercount + intervaltime * 100 / 3);
   }
   var _loc2_ = Math.floor(downercount);
   if(downerint < _loc2_)
   {
      downerint = _loc2_;
      downer_txt.text = downerint + "%";
      if(downerint == 100)
      {
         db_mc._visible = true;
         new Color(downer_txt).setRGB(255);
      }
   }
   else if(downerint > _loc2_)
   {
      downerint = _loc2_;
      downer_txt.text = downerint + "%";
      new Color(downer_txt).setRGB(5592405);
   }
   aerialenabled = aerialstatus && active && (fall && uppercount > 0 || !fall && downerint == 100);
   textd_mc._visible = !aerialenabled;
   if(aerialenabled)
   {
      this.upper = fall;
      textr_mc._visible = fall;
      textb_mc._visible = !fall;
   }
   else
   {
      textr_mc._visible = false;
      textb_mc._visible = false;
   }
}
this.stop();
var count;
var initx = _X;
var targetdagger;
var upper = false;
var uppercount = 3;
var downercount = 100;
var downerint = 0;
var aerialenabled = false;
text_mc._visible = false;
dr1_mc.stop();
dr2_mc.stop();
dr3_mc.stop();
db_mc.stop();
var active = true;
this.onMouseDown = function()
{
   if(aerialenabled && !btn.roll && !this.pauseflag)
   {
      aerialenabled = false;
      if(upper)
      {
         switch(uppercount--)
         {
            case 1:
               targetdagger = dr1_mc;
               break;
            case 2:
               targetdagger = dr2_mc;
               break;
            case 3:
               targetdagger = dr3_mc;
         }
      }
      else
      {
         downercount = 0;
         targetdagger = db_mc;
      }
      active = false;
      this.gotoAndPlay("aerial");
      control.aerialcrash(upper);
   }
};
view(false,false,0);
