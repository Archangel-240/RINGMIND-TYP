
/*

  

// Button component for the control frame


  
public class Button{
  
  
 int x,y,w,h,id; 
 boolean counter = false;
 PShape rshape;
 
 
  Button(int x, int y, int w, int h, int id){
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.id = id;
    
    rshape = createShape(RECT,x,y,w,h);
    rshape.setFill(255);
  } 
  

  
  int isClicked(){
    if (mouseX >= this.x && mouseX <= this.x+width && 
        mouseY >= this.y && mouseY <= this.y+height && mousePressed) {
          push();
          if(mousePressed){
           if(counter){
             this.rshape.setFill(color(0,0,100));
            this.counter = !this.counter;
           }else{
            this.counter = !this.counter;
             this.rshape.setFill(color(0,255,0));
           }
           
          }
      pop();
          println(id);
      return id;
    } else {
      
      return 0;
    }
}
  
  
  
  
}

***/
