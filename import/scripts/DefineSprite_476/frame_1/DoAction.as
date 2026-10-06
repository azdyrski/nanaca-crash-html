function getchara(charatype)
{
   switch(charatype)
   {
      case code.misato:
         return misato_mc;
      case code.touko:
         return touko_mc;
      case code.kiri:
         return kiri_mc;
      case code.miki:
         return miki_mc;
      case code.youko:
         return youko_mc;
      case code.sakuraba:
         return sakuraba_mc;
      case code.tomoki:
         return tomoki_mc;
      default:
         return null;
   }
}
this.stop();
var code = control.characode;
