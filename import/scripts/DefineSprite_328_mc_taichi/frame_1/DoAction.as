function bound(vx, vy)
{
   se1_mc.soundplay(Math.min(vx * 30,100));
   se2_mc.soundplay(Math.min(vy * 30,100));
}
function moveobj(py, rot, scale)
{
   if(this.taichi_mc._rotation != rot)
   {
      this.taichi_mc._rotation = rot;
   }
   if(py > 14)
   {
      this._visible = false;
   }
   else
   {
      if(py > 2.735042735042735 && py < 10.256410256410257)
      {
         this._y = -100 / scale * 400 / 1.3;
      }
      else
      {
         this._y = (- py) * 150;
      }
      this._visible = true;
   }
}
function changecolor(newcolor, frame)
{
   var count = 0;
   mycolor = new Color(this.taichi_mc);
   nowcolor = new Object();
   oldcolor = mycolor.getTransform();
   taichi_mc.onEnterFrame = function()
   {
      if(frame > count)
      {
         count += 1;
         nowcolor.ra = newcolor.ra * count / frame + oldcolor.ra * (1 - count / frame);
         nowcolor.rb = newcolor.rb * count / frame + oldcolor.rb * (1 - count / frame);
         nowcolor.ga = newcolor.ga * count / frame + oldcolor.ga * (1 - count / frame);
         nowcolor.gb = newcolor.gb * count / frame + oldcolor.gb * (1 - count / frame);
         nowcolor.ba = newcolor.ba * count / frame + oldcolor.ba * (1 - count / frame);
         nowcolor.bb = newcolor.bb * count / frame + oldcolor.bb * (1 - count / frame);
         nowcolor.aa = newcolor.aa * count / frame + oldcolor.aa * (1 - count / frame);
         nowcolor.ab = newcolor.ab * count / frame + oldcolor.ab * (1 - count / frame);
         mycolor.setTransform(nowcolor);
      }
      else
      {
         delete taichi_mc.onEnterFrame;
      }
   };
}
function setcff(oldtype, newtype, power)
{
   this.gotoAndPlay("cff");
   if(oldtype == null)
   {
      this.rv = false;
      this.cv = false;
   }
   else
   {
      this.rv = true;
      this.cv = oldtype != newtype;
   }
}
function cffa()
{
   this.gotoAndPlay("cffa");
}
function cffbc()
{
   this.gotoAndPlay("cffbc");
}
function cffbd()
{
   control.hitenabled = false;
   control.slow(1000,0);
   this.gotoAndPlay("cffbd");
}
function cffc()
{
   count = 0;
   this.gotoAndPlay("cffc");
}
function cffd()
{
   control.hitenabled = false;
   this.gotoAndPlay("cffd");
}
function cffcstop()
{
   count = null;
   taichi_mc._y = 0;
   this.gotoAndStop("normal");
}
function cffcview()
{
   if(count != null && count != undefined)
   {
      count++;
      taichi_mc._y = 60 * Math.sin(6.283185307179586 * count / 20);
      count_txt.text = Math.round(control.cffcount / 30 * 100);
      light1_mc._x -= 20;
      if(light1_mc._x <= -150)
      {
         light1_mc._x = 0;
         light1_mc._y = taichi_mc._y - 50 + Math.random() * 100;
      }
      light2_mc._x -= 10;
      if(light2_mc._x <= -100)
      {
         light2_mc._x = 0;
         light2_mc._y = taichi_mc._y - 50 + Math.random() * 100;
      }
      light3_mc._x -= 30;
      if(light3_mc._x <= -200)
      {
         light3_mc._x = 0;
         light3_mc._y = taichi_mc._y - 50 + Math.random() * 100;
      }
   }
}
