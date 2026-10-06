class GamePauseClip extends MovieClip
{
   var enterframesub;
   var nextclip;
   var pauseflag;
   var prevclip;
   var stopflag;
   var watch;
   static var masterpauseflag = false;
   static var rootclip = null;
   function GamePauseClip()
   {
      super();
      this.addlist();
      this.pauseflag = GamePauseClip.masterpauseflag;
      this.stopflag = false;
      this.watch("onEnterFrame",this.enterframeWatcher);
   }
   function onUnload()
   {
      this.removelist();
      new Sound(this).stop();
   }
   function addlist()
   {
      this.prevclip = null;
      this.nextclip = GamePauseClip.rootclip;
      if(GamePauseClip.rootclip != null)
      {
         GamePauseClip.rootclip.prevclip = this;
      }
      GamePauseClip.rootclip = this;
   }
   function removelist()
   {
      if(this.nextclip != null)
      {
         this.nextclip.prevclip = this.prevclip;
      }
      if(this.prevclip != null)
      {
         this.prevclip.nextclip = this.nextclip;
      }
      else
      {
         GamePauseClip.rootclip = this.nextclip;
      }
   }
   function countlist()
   {
      var _loc1_ = GamePauseClip.rootclip;
      var _loc2_ = 0;
      while(_loc1_ != null)
      {
         _loc2_ = _loc2_ + 1;
         _loc1_ = _loc1_.nextclip;
      }
      return _loc2_;
   }
   function enterframe()
   {
      if(!this.pauseflag)
      {
         this.enterframesub();
      }
   }
   function enterframeWatcher(prop, oldVal, newVal)
   {
      if(newVal != undefined && newVal != null)
      {
         this.enterframesub = newVal;
         return this.enterframe;
      }
      return newVal;
   }
   function pausetoggle()
   {
      if(this.pauseflag)
      {
         this.pauseplay();
      }
      else
      {
         this.pausestop();
      }
   }
   function pausestop()
   {
      this.pauseflag = true;
      super.stop();
   }
   function pauseplay()
   {
      this.pauseflag = false;
      if(!this.stopflag)
      {
         super.play();
      }
   }
   function allpausestop()
   {
      var _loc1_ = GamePauseClip.rootclip;
      GamePauseClip.masterpauseflag = true;
      while(_loc1_ != null)
      {
         _loc1_.pausestop();
         _loc1_ = _loc1_.nextclip;
      }
   }
   function allpauseplay()
   {
      var _loc1_ = GamePauseClip.rootclip;
      GamePauseClip.masterpauseflag = false;
      while(_loc1_ != null)
      {
         _loc1_.pauseplay();
         _loc1_ = _loc1_.nextclip;
      }
   }
   function allpausetoggle()
   {
      if(GamePauseClip.masterpauseflag)
      {
         this.allpauseplay();
      }
      else
      {
         this.allpausestop();
      }
      return GamePauseClip.masterpauseflag;
   }
   function prevFrame()
   {
      this.stopflag = true;
      super.prevFrame();
   }
   function nextFrame()
   {
      this.stopflag = true;
      super.nextFrame();
   }
   function gotoAndPlay(frame)
   {
      this.stopflag = false;
      if(!this.pauseflag)
      {
         super.gotoAndPlay(frame);
      }
      else
      {
         super.gotoAndStop(frame);
      }
   }
   function gotoAndStop(frame)
   {
      this.stopflag = true;
      super.gotoAndStop(frame);
   }
   function stop()
   {
      this.stopflag = true;
      super.stop();
   }
   function play()
   {
      this.stopflag = false;
      if(!this.pauseflag)
      {
         super.play();
      }
   }
}
