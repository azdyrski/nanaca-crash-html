if(this._framesloaded >= 3 && playererror)
{
   this.gotoAndPlay(3);
}
else if(this._framesloaded < this._totalframes)
{
   this.gotoAndPlay(1);
}
else
{
   this.gotoAndPlay(7);
}
