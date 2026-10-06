class GameCharacter extends GamePauseClip
{
   var _visible;
   var _x;
   var _y;
   var active;
   var blockmaxx;
   var busy;
   var charaface;
   var charatype;
   var code;
   var combomaxx;
   var controll;
   var crashmaxx;
   var getBounds;
   var gotoAndPlay;
   var gotoAndStop;
   var hitmaxx;
   var hitmaxy;
   var hitminx;
   var hitx;
   var hity;
   var moveobjsub;
   var pass;
   var passact;
   var play;
   var px;
   var specialmaxx;
   var specialwait;
   var stand;
   var standmaxx;
   var standminx;
   var toggleflag;
   var viewmaxx;
   function GameCharacter()
   {
      super();
      this.toggleflag = false;
      this.pass = false;
      this._x = 5000;
      this._y = 0;
      this._visible = false;
      this.active = true;
      this.specialwait = false;
      this.standminx = this.getBounds(this).xMin;
      this.standmaxx = this.getBounds(this).xMax;
   }
   function setposition(position)
   {
      this.busy = true;
      this.active = true;
      this.pass = false;
      this.px = position;
      this.hitminx = position + this.hitx - 0.5;
      this.hitmaxx = position + this.hitx + 0.5;
      this.hitmaxy = this.hity + 0.5;
      this.viewmaxx = this.standmaxx;
      this.gotoAndStop("stand");
      this.stand();
   }
   function moveobj(posx, posy, scale, xmin, xmax)
   {
      this.toggleflag = !this.toggleflag;
      if(this.busy)
      {
         this._x = (this.px - posx) * 150;
         if(this.pass)
         {
            this.charaface._visible = false;
            if(this._x + this.viewmaxx > xmin)
            {
               this._visible = true;
               this.moveobjsub();
            }
            else
            {
               this._visible = false;
               if(this._x <= -1350)
               {
                  if(this.charatype != this.code.youko || !this.controll.youko)
                  {
                     this.busy = false;
                     this.controll.setchara(this);
                  }
               }
            }
         }
         else
         {
            if(this.toggleflag && this.px - posx < 29)
            {
               this.charaface.view(this._x,scale);
            }
            if(this._x + this.standminx < xmax)
            {
               this._visible = true;
               this.moveobjsub();
               if(this.px - posx < -1)
               {
                  this.pass = true;
                  this.controll.setspecial(this.code.nanaka,this.px % 100 == 90);
                  this.passact();
               }
               else if(this.specialwait)
               {
                  switch(this.controll.special.getstatus())
                  {
                     case 0:
                        this.specialwait = false;
                        this.play();
                        break;
                     case 1:
                        this.specialwait = false;
                        this.viewmaxx = this.specialmaxx;
                        this.gotoAndPlay("special");
                  }
               }
               else if(this.active && this.hitminx < posx && this.hitmaxx > posx && this.hitmaxy > posy && this.controll.hitenabled)
               {
                  this.active = false;
                  this.controll.slow(1000,0);
                  if(this.controll.combo)
                  {
                     this.controll.combo = false;
                     this.viewmaxx = this.combomaxx;
                     this.gotoAndPlay("combo");
                  }
                  else if(this.controll.youko)
                  {
                     this.viewmaxx = this.blockmaxx;
                     this.gotoAndPlay("block");
                  }
                  else
                  {
                     this.viewmaxx = this.crashmaxx;
                     this.gotoAndPlay("crash");
                  }
               }
            }
            else
            {
               this._visible = false;
            }
         }
      }
   }
}
