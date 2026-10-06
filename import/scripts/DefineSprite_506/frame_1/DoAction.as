function blind(blindflag)
{
   blindmode = blindflag;
   modeset();
}
function modeset()
{
   switch(control.metermode)
   {
      case 0:
         blind_txt._visible = blindmode;
         score_txt._visible = false;
         hscore_txt._visible = !blindmode;
         vscore_txt._visible = false;
         rightarrow_mc._visible = true;
         uparrow_mc._visible = false;
         movearrow_mc._visible = false;
         break;
      case 1:
         blind_txt._visible = blindmode;
         score_txt._visible = false;
         hscore_txt._visible = false;
         vscore_txt._visible = !blindmode;
         rightarrow_mc._visible = false;
         uparrow_mc._visible = true;
         movearrow_mc._visible = false;
         break;
      case 2:
         blind_txt._visible = blindmode;
         score_txt._visible = !blindmode;
         hscore_txt._visible = false;
         vscore_txt._visible = false;
         rightarrow_mc._visible = false;
         uparrow_mc._visible = false;
         movearrow_mc._visible = !blindmode;
      default:
         return;
   }
}
function modechange()
{
   control.metermode = (control.metermode + 1) % 3;
   control.localset();
   modeset();
}
function view(horizonal, vertical)
{
   if(vval != vertical || hval != vertical)
   {
      movearrow_mc._rotation = Math.atan2(- vertical,horizonal) * 180 / 3.141592653589793;
      score = Math.sqrt(vertical * vertical + horizonal * horizonal);
      scorestr = String(Math.floor(score) + "." + Math.floor((Math.abs(score) + 1) * 100).toString().substr(-2));
      score_txt.text = scorestr;
   }
   if(vval != vertical)
   {
      if(vval < 0 && vertical >= 0)
      {
         uparrow_mc._rotation = -90;
      }
      else if(vval >= 0 && vertical < 0)
      {
         uparrow_mc._rotation = 90;
      }
      vval = vertical;
      score = Math.abs(vertical);
      scorestr = String(Math.floor(score) + "." + Math.floor((Math.abs(score) + 1) * 100).toString().substr(-2));
      vscore_txt.text = scorestr;
   }
   if(hval != horizonal)
   {
      hval = horizonal;
      scorestr = String(Math.floor(horizonal) + "." + Math.floor((Math.abs(horizonal) + 1) * 100).toString().substr(-2));
      hscore_txt.text = scorestr;
   }
}
this.stop();
score_txt.autoSize = "right";
var val = null;
var vval = null;
var hval = null;
hscore_txt._visible = false;
vscore_txt._visible = false;
var scorestr = null;
var blindmode = false;
modeset();
view(0,0);
