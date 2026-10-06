on(release){
   switch(_quality)
   {
      case "HIGH":
         _quality = "MEDIUM";
         break;
      case "MEDIUM":
         _quality = "LOW";
         break;
      case "LOW":
         _quality = "HIGH";
         break;
      default:
         _quality = "HIGH";
   }
   control.localset();
}
