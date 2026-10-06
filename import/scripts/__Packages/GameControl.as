class GameControl
{
   var aerial;
   var cffcount;
   var cffs;
   var chara_array;
   var charapos;
   var combo;
   var contact;
   var dataversion;
   var globalsound;
   var hitenabled;
   var i_angle;
   var i_power;
   var kiri;
   var lastchara;
   var main;
   var metermode;
   var miki;
   var misato;
   var nanaka;
   var nanakaobj;
   var nanakasub;
   var nogravity;
   var nolimit;
   var px;
   var py;
   var r;
   var scale;
   var slowcount;
   var slowinterval;
   var speed;
   var taichi;
   var tmpx;
   var tmpy;
   var toggleflag;
   var touko;
   var vx;
   var vy;
   var youko;
   static var commondata;
   static var savedata;
   var characode = {misato:1,touko:2,kiri:3,miki:4,youko:5,sakuraba:6,tomoki:7,nanaka:8};
   static var color_a = {ra:100,rb:0,ga:100,gb:128,ba:100,bb:0,aa:100,ab:0};
   static var color_b = {ra:100,rb:128,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0};
   static var color_c = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:128,aa:100,ab:0};
   static var color_d = {ra:100,rb:64,ga:100,gb:64,ba:100,bb:0,aa:100,ab:0};
   static var color_n = {ra:100,rb:0,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0};
   static var g = -9.8;
   static var ex = 0.8;
   static var ey = 0.8;
   static var interval = 0.03333333333333333;
   static var bestrecord = 0;
   function GameControl()
   {
   }
   function initialize()
   {
      this.vx = 0;
      this.vy = 0;
      this.px = 0;
      this.py = 0.5;
      this.r = 0;
      this.scale = 100;
      this.toggleflag = true;
      this.slowcount = 0;
      this.charapos = 0;
      this.chara_array = new Array();
      this.youko = false;
      this.nanaka = false;
      this.nanakasub = 0;
      this.misato = false;
      this.touko = false;
      this.combo = false;
      this.kiri = false;
      this.miki = false;
      this.lastchara = null;
      this.cffcount = 0;
      this.cffs = null;
      this.nogravity = false;
      this.nolimit = false;
      this.hitenabled = true;
   }
   function initvalue(val, init)
   {
      if(val == undefined || val == undefined)
      {
         return init;
      }
      return val;
   }
   function localload()
   {
      GameControl.savedata = SharedObject.getLocal("nanaca-crash/save","/");
      GameControl.commondata = SharedObject.getLocal("nanaca-crash/common","/");
      GameControl.bestrecord = this.initvalue(GameControl.savedata.data.datarecord,0);
      _quality = this.initvalue(GameControl.commondata.data.qualitysetting,"MEDIUM");
      this.metermode = this.initvalue(GameControl.commondata.data.metersetting,0);
      this.globalsound.setVolume(this.initvalue(GameControl.commondata.data.soundsetting,100));
   }
   function localclear()
   {
      GameControl.bestrecord = 0;
      this.localsave();
   }
   function localsave()
   {
      this.localset();
      GameControl.savedata.flush();
      GameControl.commondata.flush();
   }
   function localset()
   {
      GameControl.savedata.data.dataversion = this.dataversion;
      GameControl.savedata.data.datarecord = GameControl.bestrecord;
      GameControl.commondata.data.qualitysetting = _quality;
      GameControl.commondata.data.soundsetting = this.globalsound.getVolume();
      GameControl.commondata.data.metersetting = this.metermode;
   }
   function gamestart()
   {
      this.vx = 0.3 * this.i_power * Math.cos(this.i_angle * 3.141592653589793 / 180);
      this.vy = 0.3 * this.i_power * Math.sin(this.i_angle * 3.141592653589793 / 180);
      this.main.gotoAndPlay("start");
   }
   function get best()
   {
      return Math.floor(GameControl.bestrecord) + "." + Math.floor((Math.abs(GameControl.bestrecord) + 1) * 100).toString().substr(-2);
   }
   function speedblind(blind)
   {
      this.speed.blind(blind);
      this.speed.view(this.vx,this.vy);
   }
   function setspecial(chara, flag)
   {
      switch(chara)
      {
         case this.characode.misato:
            this.misato = flag;
            break;
         case this.characode.touko:
            this.touko = flag;
            break;
         case this.characode.kiri:
            this.kiri = flag;
            break;
         case this.characode.miki:
            this.miki = flag;
            break;
         case this.characode.youko:
            this.youko = flag;
            break;
         case this.characode.nanaka:
            this.nanaka = flag;
         default:
            return;
      }
   }
   function boost(power, angle)
   {
      var _loc2_ = this.docffboost(power);
      this.vx += _loc2_ * Math.cos(angle * 3.141592653589793 / 180);
      this.vy = Math.abs(this.vy) + _loc2_ * Math.sin(angle * 3.141592653589793 / 180);
   }
   function vpush()
   {
      this.tmpx = this.vx;
      this.tmpy = this.vy;
   }
   function vpop()
   {
      this.vx = this.tmpx;
      this.vy = this.tmpy;
   }
   function cffclear()
   {
      this.cffs = null;
      this.main.changecolor(GameControl.color_n);
      this.taichi.changecolor(GameControl.color_n,20);
   }
   function setcffa()
   {
      this.taichi.setcff(this.cffs,0,this.cffcount);
      this.cffs = 0;
      this.cffcount += 30;
      this.main.changecolor(GameControl.color_a);
      this.taichi.changecolor(GameControl.color_a,40);
   }
   function setcffb()
   {
      this.taichi.setcff(this.cffs,1,this.cffcount);
      this.cffs = 1;
      this.cffcount += 20;
      this.main.changecolor(GameControl.color_b);
      this.taichi.changecolor(GameControl.color_b,40);
   }
   function setcffc()
   {
      this.taichi.setcff(this.cffs,2,this.cffcount);
      this.cffs = 2;
      this.vpush();
      this.speedblind(true);
      this.vx = 10;
      this.vy = 20;
      this.nogravity = true;
      this.cffcount += 30;
      this.main.changecolor(GameControl.color_c);
      this.taichi.changecolor(GameControl.color_c,40);
   }
   function setcffd()
   {
      this.taichi.setcff(this.cffs,3,this.cffcount);
      this.cffs = 3;
      this.cffcount += 30;
      this.main.changecolor(GameControl.color_d);
      this.taichi.changecolor(GameControl.color_d,40);
   }
   function docffboost(b_power)
   {
      if(this.cffs == 0)
      {
         this.cffcount -= 10;
         if(this.cffcount <= 0)
         {
            this.cffcount = 0;
            this.cffclear();
         }
         this.taichi.cffa();
         return b_power * 2;
      }
      if(this.cffs == 1 && this.cffcount < 60)
      {
         this.cffcount = Math.min(this.cffcount + b_power * 0.2,60);
         this.taichi.cffbc();
         return b_power * 0.9;
      }
      return b_power;
   }
   function docffb()
   {
      if(this.vx < 2 && this.vy <= 0 && this.py < 5 && this.py <= (- this.vy) * this.vy / GameControl.g && this.hitenabled && this.slowcount == 0 && !this.nogravity)
      {
         this.cffclear();
         this.boost(this.cffcount,45);
         this.cffcount = 0;
         this.taichi.cffbd();
      }
   }
   function docffc()
   {
      if(this.py > 2.3)
      {
         this.slowcount = 0;
         this.nolimit = true;
         this.py = 2.3;
         this.vx = 55;
         this.vy = 0;
         this.taichi.cffc();
      }
      else
      {
         this.cffcount -= this.vx * GameControl.interval / 1000 * 30;
         if(this.cffcount <= 0)
         {
            this.vpop();
            this.speedblind(false);
            this.nogravity = false;
            this.nolimit = false;
            this.cffcount = 0;
            this.cffclear();
            this.taichi.cffcstop();
         }
         else
         {
            this.taichi.cffcview();
         }
      }
   }
   function docffd()
   {
      this.cffcount -= 6;
      if(this.cffcount <= 0)
      {
         this.cffcount = 0;
         this.cffclear();
      }
      this.taichi.cffd();
      this.vy = Math.sqrt(Math.max(this.vy * this.vy - 2 * GameControl.g * this.py,0)) * 1.1;
      this.vx *= 1.1;
   }
   function aerialcrash(upper)
   {
      this.nanakaobj.aerial(upper);
   }
   function aerialboost()
   {
      var _loc2_;
      _loc2_ = Math.atan2(this.vy,this.vx) * 0.9;
      this.vx += 10 * Math.cos(_loc2_);
      this.vy += 10 * Math.sin(_loc2_);
      this.vy = - this.vy;
   }
   function cff(charatype)
   {
      this.nanakaobj.cff(charatype);
   }
   function slow(frames, interval)
   {
      this.slowcount = frames;
      this.slowinterval = interval;
   }
   function slow2(frames, distance)
   {
      this.slowcount = frames;
      this.slowinterval = Math.min(GameControl.interval,distance / Math.sqrt(this.vx * this.vx + this.vy * this.vy) / frames);
   }
   function initchara(chara, code)
   {
      chara.charatype = code;
      chara.hittarget = this.taichi.taichi_mc;
      this.chara_array.splice(Math.floor(Math.random() * (this.chara_array.length + 1)),0,chara);
      chara.controll = this;
      chara.charaface = this.contact.getchara(code);
   }
   function setchara(chara)
   {
      this.chara_array.splice(Math.floor(Math.random() * (this.chara_array.length + 1)),0,chara);
   }
   function getchara(pos)
   {
      var _loc2_;
      _loc2_ = GameCharacter(this.chara_array.pop());
      _loc2_.setposition(pos);
      this.lastchara = _loc2_.charatype;
   }
   function backeffect(effect, param)
   {
      this.main.backeffect(effect,param);
   }
   function moveobj()
   {
      var _loc2_;
      var _loc3_;
      if(this.cffs == 1)
      {
         this.docffb();
      }
      else if(this.cffs == 2)
      {
         this.docffc();
      }
      if(this.py == 0 && this.slowcount == 0 && this.vx < 0.0001 && this.vy < 0.0001)
      {
         this.vx = 0;
         this.vy = 0;
         this.main.viewscore(this.px,this.py,GameControl.bestrecord == this.px,this.vx,this.vy);
         this.localset();
         this.main.gameover();
      }
      else
      {
         this.toggleflag = !this.toggleflag;
         if(this.slowcount > 0)
         {
            _loc2_ = Math.min(this.slowinterval,0.8533333333333334 / Math.max(this.vx,Math.abs(this.vy) - GameControl.g * this.slowinterval));
            this.slowcount = this.slowcount - 1;
         }
         else if(this.nolimit)
         {
            _loc2_ = GameControl.interval;
         }
         else
         {
            _loc2_ = Math.min(GameControl.interval,0.8533333333333334 * Math.max(1,-8.2 / this.py + 2.8) / Math.max(this.vx,Math.abs(this.vy) - GameControl.g * GameControl.interval));
         }
         this.px += this.vx * _loc2_;
         if(this.nogravity)
         {
            this.py += this.vy * _loc2_;
         }
         else
         {
            this.py += (GameControl.g * _loc2_ / 2 + this.vy) * _loc2_;
            this.vy += GameControl.g * _loc2_;
            if(this.py < 0)
            {
               if(this.cffs == 3)
               {
                  this.docffd();
               }
               else
               {
                  this.vy = Math.sqrt(Math.max(this.vy * this.vy - 2 * GameControl.g * this.py,0)) * GameControl.ey;
                  this.vx *= GameControl.ex;
                  this.taichi.bound(this.vx,this.vy);
               }
               this.py = 0;
               this.setspecial(this.characode.misato,false);
            }
         }
         _loc3_ = this.scale;
         this.scale = Math.floor(Math.min(Math.max(205.13 / this.py,20),Math.max(this.scale - 2,75)) / 0.1) * 0.1;
         this.r += Math.min(this.vx * _loc2_ * 30,30);
         if(this.px + 20 >= this.charapos)
         {
            this.charapos += 10;
            this.getchara(this.charapos);
         }
         GameControl.bestrecord = Math.max(GameControl.bestrecord,this.px);
         if(this.toggleflag)
         {
            this.main.viewscore(this.px,this.py,GameControl.bestrecord == this.px,this.vx,this.vy);
         }
         this.aerial.view(this.py <= 10 && this.py >= 3 && this.hitenabled,this.vy <= 0,_loc2_);
         this.main.moveobj(this.px,this.py,Math.round(this.r),this.scale,this.scale != _loc3_);
      }
   }
}
