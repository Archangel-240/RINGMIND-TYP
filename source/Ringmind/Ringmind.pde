
/**
* RINGMIND 
* A gravitational simulation in a Cartesian coordinate system.
*
* Physics Coding by Lancaster Uni  eyeInterpolator.configHint(Interpolator.SPLINE, color(255, 255, 0));versity Physics.
* @author Thom as Cann
* @author Sam Hinson
* @author Chris Lawson
* @author Chris Arridge
*
* Interaction design and audio visual system 
* @author Ashley James Brown march-may 2019 
*/


import controlP5.*;
import com.hamoid.*;
import nub.primitives.*;
import nub.core.*;
import nub.core.constraint.*;
import nub.processing.*;
import java.util.LinkedList;
import java.util.Iterator; 
import java.awt.Frame;
import processing.awt.PSurfaceAWT;
import processing.awt.PSurfaceAWT.SmoothCanvas;



ControlP5 cp5;
ControlFrame cf;
SimBoxControlFrame sbcf;
Boolean controlsSetup = false;

Scene scene;
Node node;

int videoExportTimerReset = 0;
Boolean videoExportRecording = false;
VideoExport videoExport;
String videoExportFilename = "myVideo.mp4";

Boolean particleExporting = false;
String particleExportFilename = "particles.csv";

Boolean Running= true;

PImage bg;

PShape square;

PrintWriter output; 


/**
* Settings for this sketch.  Just sets up the screen.
*/
void settings() {
  ///fullScreen();
  //fullScreen(P3D, 1);
  size (1600, 800, P3D);
  //surface.setResizable(true);
  smooth();//this is anti-aliasing (3x is the default)  
  //noSmooth();
}
boolean dev = false;

/**
* Setup the sketch
*/
void setup() {

  // Setup the CP5 interaction system.
  setupCP5();

  // Setup the location of our drawing surface on the screen.
  surface.setLocation(270, 0);

  while (!(controlsSetup)) {
    delay(10);
  }

  // Load a background image and resize to the dimensions of our display.  Then display.
  bg = loadImage("Background.png");
  bg.resize(1600,800);
  //background(bg);

  // Seed the random number generator.
  randomSeed(3);


  // Initialise via the state system - set to initial state and then call setup for
  // any initialisation.
  systemState = State.initState;
  setupStates();

  // We default to being in the shear state - so set that state and initialise.
  systemState = State.shearState;
  setupStates();

  // Setup video export.
  if (videoExportRecording) setupExport();
  
  setupNub();
  initKeyFrames();
  renderMode = RenderState.nativeMode ;
  
  //square = createShape(RECT, 0, 0, 80, 80);  

}


/**
* Sketch update/draw function.  Do any simulation updates and then render to the screen - or to video if
* we are saving a movie.
*/
void draw() {
  scene.openContext(); //nub
  if(dev){
    background(0);
    //renderOffScreenOnPGraphicsClean();
  } else {
    updateCurrentState(millis());  // Simulation update.  updateCurrentState Calls the render and anything specific to each scene state. 
  }
  scene.render();
  scene.closeContext();// nub

   


  
  scene.beginHUD();
  //square.setFill(color(150));
  //new Node(square);
  //translate(mouseX, mouseY);
  //shape(square);
  //Node n1 = new Node(square);
  //pushStyle();
  //beginShape();
  //  vertex(120, 80);
  //  vertex(340, 80);
  //  vertex(340, 300);
  //  vertex(120, 300);
  //  setill(153);
  //endShape(CLOSE);
  //popStyle();
  scene.endHUD();

  /*
  ** if we are exporting to video then we only save every 50 ms (at 20 fps)
  ** to create a smoother looking video.
  */
  if (videoExportRecording) {
    int timer = int(millis()) - videoExportTimerReset;
    if(timer >= 50) {
      videoExportTimerReset += 50;
      drawMovie();
    }
  }

}


/**
* Called on exit
*/
void stop() {
  print("exiting");
}


/**
* Setup the nub Scene
*/

void setupNub(){
  scene = new Scene(this, 375);//375 is the deafult
  node = new Node();
  
  //node.enableHint(Node.AXES);
  scene.enableHint(Scene.AXES);
  scene.fit();
  
}


void saveCameraPath(){

  output = createWriter("positions.txt");

}

/* =========================================================================================================================
*
* CP5 Interaction code
*
* ==========================================================================================================================
*/

/**
* Setup the CP5 controller
*/
void setupCP5(){
  cf = new ControlFrame(this, 400, 800, "Controls");
  // surface.setLocation(10,10);
  // background(0);
}



/**
* Respond to key down events.
*/
void keyPressed() {

  switch(key) {

    // Stop/start the simulation.
    case ' ':
      Running = !Running;
      
      
      
      
      
      
      break;
	
    // 
  }
  
    if (key == CODED) {
      //println(scene.eye().orientation());
      if (keyCode == UP)
        //scene.eye().orbit(scene.eye().worldDisplacement(Vector.plusI), 0.05, 0.85);
        scene.eye().rotate(Vector.plusI,-0.05,0.8);   
      else if (keyCode == DOWN)
        scene.eye().rotate(Vector.plusI,0.05,0.8);
      else if (keyCode == LEFT)
        scene.eye().rotate(Vector.plusJ,0.05,0.8);
      else if (keyCode == RIGHT)
         scene.eye().rotate(Vector.plusJ,-0.05,00.8);
    }
  
  
  
  //scene.focus("key");
  //NUMERICAL KEY
  if (key=='1') {//f
    n_particles = 2000;
    LX = 70000;
    LY = 800000;
    cp5.getController("Orbit Radius").setValue(136500000);
    cp5.getController("Moon Radius").setValue(3800);
    //cp5.getController("Moonlet Density").setValue(3800);

    systemState = State.shearState;
    // setupStates();
	
    ShearSystem ss = (ShearSystem) s;
	  gapSize = 35000;
	  //ss.r0 = 136500000;
    Moonlet = true;
    HalfRing = false;
    RingGap = true;
	  // setupStates();
    // ss.moonlet.position.y = 0;
    // ss.moonlet.position.x = 0;
    // ss.moonlet.position.z = 0;
    // ss.moonlet.velocity = new PVector();
    // ss.moonlet.velocity.y = 1.5 * ss.Omega0 * ss.moonlet.position.x;
	

	  // fixedMoonlet = true;
    setupStates();  
  } else if (key=='2') {
  //  dev = false;
  //	pg = createGraphics(1024, 1024, P3D);
	//pg = null;

	systemState= State.ringmindState;
    setupStates();
        setupNodeParticles(1);
  } else if (key=='3') {
    //setupNub();
    systemState= State.shearState;
    setupStates();
	  setupNodeParticles(0);
    renderMode = RenderState.nub3D;

	
	
  } else if (key=='4') {
	  //setupNub();
  if(renderMode != RenderState.nativeMode){
    removeNodeParticles();
    node = null;
     blendMode(NORMAL);
	  renderMode = RenderState.nativeMode; 
  }

  } else if (key=='5') {
    //ringmindStableState
    systemState= State.ringmindState;
    setupStates();
    setupNodeParticles(1);
  } else if (key=='%') {
    //Unstable Ringmind State
    systemState= State.ringmindUnstableState;
    setupStates();
        setupNodeParticles(1);
  } else if (key=='6') {
    //connectedState
    systemState= State.connectedState;
    setupStates();
        setupNodeParticles(1);
  } else if (key=='7') {
    //saturnState
    systemState= State.saturnState;
    setupStates();
    setupNodeParticles(1);
  } else if (key=='8') {
    //shearState
    systemState= State.shearState;
    setupStates();
  } else if (key=='*') {
    //Toggle Moonlet
    if (s instanceof ShearSystem) {
      ShearSystem ss = (ShearSystem) s;
      Moonlet = !Moonlet;
    }
  } else if (key=='9') {
    //TiltSystem
    systemState= State.formingState;
    setupStates();
  } else if (key=='0') {
    systemState= State.ringboarderState;
    setupStates();
  } else if (key==')') {
    systemState= State.addAlienLettersState;
    setupStates();
  } else if (key=='-') {
    systemState= State.threadingState;
    setupStates();
  } else if (key== '=') {
    systemState= State.resonanceState;
    setupStates();
  }

  //----------------------------TOP ROW QWERTYUIOP[]------------------------------------------------

  if (key=='q') {

  } else if (key=='Q') {
    resetView();
  } else if (key=='w') {
    if (scene.eye().reference() != null)
      resetEye();
    else if (nodePOV != null)
      nodeTrackPOV();
  } else if (key=='W') {
    //
  } else if (key=='e') {
    pg.clear();
    //removeNodeParticles();
    //Proscene -#sc
  } else if (key=='E') {
    //
  } else if (key=='r') {
    //Proscene - Show Camera Path
  } else if (key=='R') {
  
  } else if (key=='t') {

  } else if (key=='T') {
    eyeInterpolator.toggle();
  } else if (key=='Y') {
	//eyeInterpolator.addKeyFrame();
  } else if (key=='y') {
    
  } else if (key=='u') {

  } else if (key=='U') {
    eyeInterpolator.toggleHint(Interpolator.SPLINE | Interpolator.STEPS);
  } else if (key=='I') {
    
    
      output = createWriter("positions.txt");
    HashMap<Float, Node> k = eyeInterpolator.keyFrames();
    // for(int j = 0; j < k.size();j++){
    //  output.println(k.get(j).position().x()+","+k.get(j).position().y()+","+k.get(j).position().z()+","+k.get(j).orientation().axis().x()+","+k.get(j).orientation().axis().y()+","+k.get(j).orientation().axis().z()+","+k.get(j).orientation().angle());
      
    //}
    for (Float j : k.keySet()){
       //output.println(j.position().x()+","+j.position().y()+","+j.position().z()+","+j.orientation().axis().x()+","+j.orientation().axis().y()+","+j.orientation().axis().z()+","+j.orientation().angle());
      output.println(j+","+k.get(j).position().x()+","+k.get(j).position().y()+","+k.get(j).position().z()+","+k.get(j).orientation().axis().x()+","+k.get(j).orientation().axis().y()+","+k.get(j).orientation().axis().z()+","+k.get(j).orientation().angle()+","+k.get(j).magnitude());
    }
             output.flush();
    output.close(); 
      println(k);
    //  for (Node i : k.values()) {
    //  println(i);
    //  println(i.position());
    //}

      
  } else if (key=='i') {
    //
  } else if (key=='o') {

  } else if (key=='O') {
    
  /*     String[] lines = loadStrings("cameraPath.path");

  for (int i = 0 ; i < lines.length; i++) {
      String p = lines[i];
      Quaternion q ;
      Float[] v = new Float[8];
      for(int k = 0; k< 8;k++){
        Float px;
        if(k == 7){
          px = float(p);
        }else{
          px = float(p.substring(0,p.indexOf(",")));
        }
        p = p.substring(p.indexOf(",")+1);
        v[k] = px;
     // println(px);
    }
    eyeInterpolator.addKeyFrame(new Node(new Vector(v[0],v[1],v[2]),new Quaternion(new Vector(v[3],v[4],v[5]),v[6]),v[7]),i+1); */
    
    
  
    
    
    
  } else if (key=='p') {
    eyeInterpolator.toggle();

  } else if (key=='P') {
	  
	  eyeInterpolator.toggle();
	  
  /* 	      String[] lines = loadStrings("positions.txt");
      for (int i = 0 ; i < lines.length; i++) {
      String p = lines[i];
      Quaternion q ;
      Float[] v = new Float[9];
      for(int k = 0; k< 9;k++){
        Float px;
        if(k == 8){
          px = float(p);
        }else{
          px = float(p.substring(0,p.indexOf(",")));
        }
        p = p.substring(p.indexOf(",")+1);
        v[k] = px;
     // println(px);
    }
    eyeInterpolator.addKeyFrame(new Node(new Vector(v[1],v[2],v[3]),new Quaternion(new Vector(v[4],v[5],v[6]),v[7]),v[8]),v[0]); */
    
    
  
    
  
    
    
    
  } else if (key=='[') {

  } else if (key==']') {

  }

  //---------------------------SECOND ROW ASDFGHJKL--------------------------------------------

  if (key == 'a') {
    //Proscene - 3 Axis Markers
  } else if (key == 'A') {
    useAdditiveBlend = !useAdditiveBlend;
  } else if (key=='s') {
    //Proscene - Fill Screen
  } else if (key=='S') {
    //Release to Save Path to JSON
  } else if (key=='d') {
    scene.fit();
  } else if (key=='D') {
    //
  } else if (key=='f') {
    useFilters=!useFilters;
  } else if (key=='F') {
    //
  } else if (key=='g') {
    systemState= State.fadeup; //fade up all particles
    //Proscene - Grid Square
  } else if (key=='G') {
    //
  } else if (key=='h') {
    systemState= State.fadetoblack; //fadeout all particles from everything
  } else if (key=='H') {
    //
  } else if (key=='j') {
    useTrace = !useTrace;
  } else if (key=='J') {
    //
  } else if (key=='k') {
    videoExportRecording = !videoExportRecording;
    //
  } else if (key=='k') {
    
  } else if (key=='l') {
    //
  } else if (key=='L') {
    //
  }

  //---------------------------THIRD ROW ZXCVBNM--------------------------------------------

  if (key=='z') {
    //
  } else if (key=='Z') {
    //
  } else if (key=='x') {
    //
  } else if (key=='X') {
    //
  } else if (key=='c') {
    //oscRingDensity(Saturn);
    //oscRingRotationRate(Saturn);
  } else if (key=='C') {
    //
  } else if (key=='v') {
    saveFrame("./screenshots/ringmind_screen-###.jpg");
  } else if (key=='V') {
    //
  } else if (key=='b') {
    //
  } else if (key=='B') {
    //
  } else if (key=='n') {
    //
  } else if (key=='N') {
    
  } else if (key=='m') {
    ////turn on this alogorithm to send tony the data
    //MoonAlignment = !MoonAlignment;
  } else if (key=='M') {
    //
  } else if (key==',') {
    //
      scene.moveForward(-10, 0.8);
  } else if (key=='.') {
      scene.moveForward(10, 0.8);
  }
  
  

}

//-------------------------------
public void keyReleased() {
  //if you edit the camera pathways be sure to save them !!!!
  if (key=='S') {

    println("camera pathways saved");
  }
}

//---------------------------- MOUSE -----------------------------------------------------------------------

public void mouseReleased() {
  //lets debug print all the camera stuff to help figure out what data we need for each scene
  //println("****** camera debug info ******");
  //println();
  //println("camera orientation");
  //Rotation r = scene.camera().frame().orientation();
  //r.print();
  //println();
  //println("camera position");
  //println(scene.camera().position());
  //println();
  //println("view direction");
  //println(scene.camera().viewDirection());
  println("Released");
}

public void mousePressed(){
	
	println("Pressed");

}

void mouseClicked(){
 
  
  updateNodePOV(scene.updateMouseTag("mouseClicked")); 
  
  
  
}

void mouseDragged() {
  if (scene.eye().reference() == null){
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.mouseSpin();
    else if (mouseButton == RIGHT)
      //scene.translate(scene.eye());
      scene.mouseTranslate();

  }
}

void mouseMoved(MouseEvent event){
  scene.updateMouseTag();
  scene.mouseTag("mouseMoved");
  if (scene.eye().reference() != null)
  // press shift to move the mouse without looking around
  if (!event.isShiftDown())
    scene.mouseLookAround();
  
}
void mouseWheel(MouseEvent event) {
  
  //if (scene.is3D())
    scene.moveForward(event.getCount() * 20);
  //else
  //  scene.scaleEye(event.getCount() * 20);
  //  //scene.zoom(, scene.mouseDX());
  //scene.scaleEye(event.getCount() * 20);
}





/* =========================================================================================================================
*
* Video export code
*
* =========================================================================================================================
*/

/**
* Sets up the VideoExport object to record a movie to disc.
*/
void setupExport() {
  videoExport = new VideoExport(this, videoExportFilename);
  videoExport.setFrameRate(20);
  videoExport.startMovie();
}
/**
* Save a video frame to the file.
*/
void drawMovie(){
  videoExport.saveFrame();
}
