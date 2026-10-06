function view()
{
   if(control == undefined || control == null)
   {
      best = "0.00";
   }
   else
   {
      best = control.best;
   }
   n1_mc.num = best.charAt(best.length - 1);
   n2_mc.num = best.charAt(best.length - 2);
   n4_mc.num = best.charAt(best.length - 4);
   n5_mc.num = best.charAt(best.length - 5);
   n6_mc.num = best.charAt(best.length - 6);
   n7_mc.num = best.charAt(best.length - 7);
   n8_mc.num = best.charAt(best.length - 8);
   n9_mc.num = best.charAt(best.length - 9);
   n10_mc.num = best.charAt(best.length - 10);
}
this.stop();
this.view();
