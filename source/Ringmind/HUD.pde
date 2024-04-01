/**

Heads-Up display.
Displays buttons for the different modes at the top of the screen/
/


public class HUD {
  int widthHUD = 4;
  public Button[] p = new Button[widthHUD];
  
  HUD(){
    
    for(int i = 0; i < widthHUD ; i++){
      
      p[i] =  new Button(i*(width/widthHUD),0,width/widthHUD,height/16,i+1);
      println(p[i].x);
      println(p[i].y);
      println(p[i].w);
      println(p[i].h);
    }
   
   
 }
  
  
  
}
