function moveobj(ppx, scale)
{
   this._x = Math.floor(ppx / 300) % unitwidth;
   this._visible = scale < 40;
}
this.stop();
var unitwidth = 250;
