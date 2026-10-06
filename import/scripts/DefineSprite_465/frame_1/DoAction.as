function hidebtn()
{
   this.roll = this.menu_btn.roll || this.meter_btn.roll || this.pauser_btn.roll || this.title_btn.roll || this.againr_btn.roll || this.quality_btn.roll || this.sound_btn.roll;
   if(!roll && this.hideenable)
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
}
function viewbtn()
{
   this.roll = this.menu_btn.roll || this.meter_btn.roll || this.title_btn.roll || this.pauser_btn.roll || this.againr_btn.roll || this.quality_btn.roll || this.sound_btn.roll;
   openstatus = true;
   pauser_btn._visible = true;
   pauser_btn.enabled = true;
   title_btn._visible = true;
   title_btn.enabled = true;
   meter_btn._visible = true;
   meter_btn.enabled = true;
   againr_btn._visible = true;
   againr_btn.enabled = true;
   quality_btn._visible = true;
   quality_btn.enabled = true;
   sound_btn._visible = true;
   sound_btn.enabled = true;
}
function gamestart()
{
   again_btn.roll = false;
   againr_btn = again_btn;
   again_btn._visible = againd_btn._visible;
   again_btn.enabled = againd_btn.enabled;
   againd_btn._visible = false;
   againd_btn.enabled = false;
   pause_btn.roll = false;
   pauser_btn = pause_btn;
   pause_btn._visible = paused_btn._visible;
   pause_btn.enabled = paused_btn.enabled;
   paused_btn._visible = false;
   paused_btn.enabled = false;
}
function gameover()
{
   paused_btn.roll = false;
   pauser_btn = paused_btn;
   paused_btn._visible = pause_btn._visible;
   paused_btn.enabled = pause_btn.enabled;
   pause_btn._visible = false;
   pause_btn.enabled = false;
   this.hideenable = false;
   this.viewbtn();
}
function rollover()
{
   this.roll = true;
   this.viewsub();
   viewbtn();
}
function rollout()
{
   this.roll = false;
   hidebtn();
}
function qualitytext()
{
   switch(_quality)
   {
      case "HIGH":
         qtxt = "HIGH > MEDIUM";
         return;
      case "MEDIUM":
         qtxt = "MEDIUM > LOW";
         return;
      case "LOW":
         qtxt = "LOW > HIGH";
         return;
      default:
         qtxt = "> HIGH";
         return;
   }
}
function soundtext()
{
   if(control.globalsound.getVolume() == 0)
   {
      stxt = "OFF > ON";
   }
   else
   {
      stxt = "ON > OFF";
   }
}
this.stop();
var roll = false;
var openstatus;
var hideenable;
this.menu_btn.onRollOver = rollover;
this.menu_btn.onRollOut = rollout;
this.menu_btn.onReleaseOutside = rollout;
this.pause_btn.onRollOver = rollover;
this.pause_btn.onRollOut = rollout;
this.pause_btn.onReleaseOutside = rollout;
this.paused_btn.onRollOver = rollover;
this.paused_btn.onRollOut = rollout;
this.paused_btn.onReleaseOutside = rollout;
this.title_btn.onRollOver = rollover;
this.title_btn.onRollOut = rollout;
this.title_btn.onReleaseOutside = rollout;
this.meter_btn.onRollOver = rollover;
this.meter_btn.onRollOut = rollout;
this.meter_btn.onReleaseOutside = rollout;
this.again_btn.onRollOver = rollover;
this.again_btn.onRollOut = rollout;
this.again_btn.onReleaseOutside = rollout;
this.againd_btn.onRollOver = rollover;
this.againd_btn.onRollOut = rollout;
this.againd_btn.onReleaseOutside = rollout;
this.quality_btn.onRollOver = rollover;
this.quality_btn.onRollOut = rollout;
this.quality_btn.onReleaseOutside = rollout;
this.quality_btn.viewsub = qualitytext;
this.sound_btn.onRollOver = rollover;
this.sound_btn.onRollOut = rollout;
this.sound_btn.onReleaseOutside = rollout;
this.sound_btn.viewsub = soundtext;
hideenable = true;
againr_btn = againd_btn;
againd_btn.stop();
againd_btn.useHandCursor = false;
again_btn._visible = false;
again_btn.enabled = false;
pauser_btn = paused_btn;
paused_btn.stop();
paused_btn.useHandCursor = false;
pause_btn._visible = false;
pause_btn.enabled = false;
hidebtn();
