function viewslide(target_mc)
{
   max = 10;
   frames = 5;
   if(target_mc.pos == frames || target_mc.pos == - frames)
   {
      target_mc._visible = false;
      target_mc.gotoAndStop(1);
   }
   else
   {
      target_mc._visible = true;
      target_mc._x = target_mc.pos * max / frames - 350;
      colorobj.ra = 100 * (1 - Math.abs(target_mc.pos) / frames);
      colorobj.rb = 255 * Math.abs(target_mc.pos) / frames;
      colorobj.ga = colorobj.ra;
      colorobj.gb = colorobj.rb;
      colorobj.ba = colorobj.ra;
      colorobj.bb = colorobj.rb;
      target_mc.mycolor.setTransform(colorobj);
   }
}
function inslide(target_mc)
{
   in_mc = target_mc;
   if(out_mc == target_mc)
   {
      out_mc = null;
   }
   target_mc.onEnterFrame = function()
   {
      if(out_mc == null)
      {
         if(this.pos > 0)
         {
            this.pos -= 1;
         }
         else if(this.pos < 0)
         {
            this.pos += 1;
         }
         else
         {
            in_mc = null;
            this.play();
            delete this.onEnterFrame;
         }
         viewslide(this);
      }
   };
}
function outslide(target_mc)
{
   delete in_mc.onEnterFrame;
   if(out_mc == null)
   {
      target_mc.stop();
      out_mc = target_mc;
      target_mc.onEnterFrame = function()
      {
         if(this.pos >= 0 && this.pos < frames)
         {
            this.pos += 1;
         }
         else if(this.pos < 0 && this.pos > - frames)
         {
            this.pos -= 1;
         }
         else
         {
            out_mc = null;
            in_mc.pos = - this.pos;
            delete this.onEnterFrame;
         }
         viewslide(this);
      };
   }
}
this.stop();
colorobj = new Object();
colorobj.aa = 100;
colorobj.ab = 0;
init = function(targetslide_mc)
{
   this.useHandCursor = false;
   this.targetslide_mc = targetslide_mc;
   if(this == currentbtn_mc)
   {
      this.gotoAndStop(2);
      this.targetslide_mc.mycolor = new Color(this.targetslide_mc);
      this.targetslide_mc.pos = 0;
      viewslide(this.targetslide_mc);
   }
   else
   {
      targetslide_mc._visible = false;
      this.gotoAndStop(1);
      this.targetslide_mc.mycolor = new Color(this.targetslide_mc);
      this.targetslide_mc.pos = - frames;
      viewslide(this.targetslide_mc);
      this.targetslide_mc.stop();
   }
   this.onRollOver = function()
   {
      if(this != currentbtn_mc)
      {
         this.gotoAndStop(2);
         outslide(currentbtn_mc.targetslide_mc);
         currentbtn_mc.gotoAndStop(1);
         currentbtn_mc = this;
         inslide(currentbtn_mc.targetslide_mc);
      }
   };
};
out_mc = null;
in_mc = null;
currentbtn_mc = aboutbtn_mc;
aboutbtn_mc.init = init;
aerialbtn_mc.init = init;
specialbtn_mc.init = init;
charabtn_mc.init = init;
aboutbtn_mc.init(this.about_mc);
aerialbtn_mc.init(this.aerial_mc);
specialbtn_mc.init(this.special_mc);
charabtn_mc.init(this.chara_mc);
