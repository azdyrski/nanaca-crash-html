this.stop();
var numberwatcher = function(prop, oldVal, newVal)
{
   numVal = Number(newVal);
   if(isNaN(numVal))
   {
      this._visible = false;
   }
   else
   {
      this._visible = true;
      this.gotoAndStop(numVal + 2);
   }
   return newVal;
};
this.watch("num",numberwatcher);
num = num;
