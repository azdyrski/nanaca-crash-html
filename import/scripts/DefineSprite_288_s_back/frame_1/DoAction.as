function moveobj(ppx, scale, scalechange)
{
   tree_mc.moveobj(ppx,0,scale,scalechange);
   rail_mc.moveobj(ppx,0,scale,scalechange);
   mount_mc.moveobj(ppx,scale,scalechange);
   cloud1_mc.moveobj(ppx);
   cloud2_mc.moveobj(ppx);
}
this.stop();
sscale = 7000;
escale = 100;
sx = -84.75 - 100 / (sscale / 100);
ex = -200;
sy = 300 + -200 / (sscale / 100);
ey = 0;
frames = 15;
tree_mc.moveobj(- sx,sy / 150,sscale,true);
rail_mc.moveobj(- sx,sy / 150,scale,true);
cloud1_mc.moveobj(- sx);
cloud2_mc.moveobj(- sx);
count = 0;
onEnterFrame = function()
{
   dt = count * count / frames / frames;
   px = (ex - sx) * dt + sx;
   py = (ey - sy) * dt + sy;
   scale = 1 / ((1 / escale - 1 / sscale) * dt + 1 / sscale);
   tree_mc.moveobj(- px,py / 150,scale,true);
   rail_mc.moveobj(- px,py / 150,scale,true);
   count += 1;
   if(count > frames)
   {
      delete this.onEnterFrame;
   }
};
