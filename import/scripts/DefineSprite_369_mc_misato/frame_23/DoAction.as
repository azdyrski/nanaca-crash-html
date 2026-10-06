control.slow(1000,0);
control.setspecial(code.misato,true);
new Color(misato_mc.taichi_mc).setTransform(new Color(hittarget).getTransform());
movecount = 0;
moveobjsub = function()
{
   taichi_mc._x += taichi_mc.dx;
   taichi_mc._y += taichi_mc.dy;
   taichi_mc._rotation += taichi_mc.dr;
   movecount++;
};
