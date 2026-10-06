angle = (Math.abs(Math.atan2(control.vy,control.vx)) / 0.017453292519943295 + 45) % 90 * 70 / 90 + 10;
v = Math.sqrt(control.vx * control.vx + control.vy * control.vy);
control.vx = v * Math.cos(angle * 3.141592653589793 / 180);
control.vy = v * Math.sin(angle * 3.141592653589793 / 180);
if(angle >= 45)
{
   up_mc._visible = true;
   down_mc._visible = false;
}
else
{
   up_mc._visible = false;
   down_mc._visible = true;
}
control.slow2(30,1);
control.setspecial(code.youko,false);
movecount = 0;
x1a = 300 + 100 * Math.random();
x1b = 50 + 300 * Math.random();
x2 = 100 + 100 * Math.random();
moveobjsub = function()
{
   movecount++;
   curry1a_mc._x = movecount / 30 * x1a;
   curry1a_mc._y = (movecount - 10) * (movecount - 10) / 20 / 20 * 200 - 200;
   curry1a_mc._rotation += 5;
   curry1b_mc._x = movecount / 30 * x1b;
   curry1b_mc._y = (movecount - 10) * (movecount - 10) / 20 / 20 * 200 - 200;
   curry1b_mc._rotation += 10;
   curry2_mc._x = movecount / 30 * x2;
   curry2_mc._y = (movecount - 10) * (movecount - 10) / 20 / 20 * 200 - 200;
   curry2_mc._rotation += 15;
   if(movecount == 30)
   {
      delete moveobjsub;
   }
};
