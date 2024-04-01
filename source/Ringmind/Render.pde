/**
 * RINGMIND Rendering system
 */

/* =================================================================================================
 * Render system global variables
 */

/**
 * Ringmind Renderer object
 */
Renderer renderer;

/**
 * Main rendering context
 */
PGraphics pg;

/**
 * Ringmind rendering context object
 */
RenderContext renderContext;

/**
 * Offscreen shader??
 */
PShader offscreenShader;

/**
 * Blends all rendered objects on top of each other.
 */
boolean useAdditiveBlend = false;

/**
 * Show traces of ring particles.
 */
boolean useTrace = false;

/**
 * Unknown??
 */
int traceAmount=70;

/**
 * Apply gaussian filters
 */
boolean useFilters = false;

/**
 * Unknown??
 */
boolean GhostMoon = false;

boolean renderType = false;

boolean renderType2 = false;

/** 
 * Method to setup rendering for Ringmind.  Setups up Rendering object, RenderContext object and our main drawing context.
 */
void renderSetup() {
  // Renderer Object
  renderer = new Renderer();
  renderer.withMoon = true;

  // PGraphics Object
  pg = createGraphics(1024, 1024, P3D);

  // RenderContext Object
  renderContext = new RenderContext();
  renderContext.pgfx = this;
  renderContext.shader = loadShader("texfrag.glsl", "texvert.glsl");
  renderContext.mat.spriteTexture = loadImage("partsmall.png");
  renderContext.mat.diffTexture = pg;
  renderContext.mat.strokeColor = 255;

  // PShader Object
  offscreenShader = loadShader("cloudy.glsl");

  // LOAD CUSTOM FILTERS
  loadFilters();
}

/**
 * Default overlay render without shader
 */
void renderOffScreenOnPGraphicsClean() {
  pg.beginDraw();
  pg.background(255, 255, 255); //no shader diffuse texture over the top
  pg.endDraw();
}

/**
 * Default overlay render using shader
 */
void renderOffScreenOnPGraphics() {
  pg.beginDraw();
  pg.shader(offscreenShader);
  offscreenShader.set("resolution", float(pg.width), float(pg.height));
  offscreenShader.set("time", float(millis()));
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
}

/**
 * A little keyhole example
 */
void renderOffScreenOnPGraphics2() {
  pg.beginDraw();
  pg.background(0, 0, 0);
  //pg.stroke(255);
  //pg.fill(255);
  //pg.strokeWeight(100);
  //pg. line(0,0,pg.wdith,pg.height);

  //pg.ellipse(mouseX, mouseY, 200, 200);
  pg.endDraw();
}

/**
 * Annulus Pshape
 * @author Chris Arridge
 */
void drawAnnulus(float cx, float cy, float cz, float inner, float outer, int N) {
  beginShape();
  for (int i=0; i<=N; i++) {
    vertex(outer*cos(i*2*PI/N), outer*sin(i*2*PI/N), 0.0);
  }

  for (int i=0; i<=N; i++) {
    vertex(inner*cos(i*2*PI/N), inner*sin(i*2*PI/N), 0.0);
  }
  endShape(CLOSE);
}

/**
 * Class Renderer
 * @author ashley james brown
 * @author Thomas Cann
 */
class Renderer {

	boolean withMoon = true;
	float scale=System.SCALE; 


	/**
	* Renders a given particle system.
	* @param s Particle System to render.
	* @param ctx Rendering context to use.
	* @param renderType Selects points or lines for the ResonantSystem rendering.
	*/
	void render(System s, RenderContext ctx, int renderType) {
		PGraphicsOpenGL pg = (PGraphicsOpenGL) ctx.pgfx.g;
    
		/* ---------------------------------------------
		 *
		 * Resonant System rendering
		 *
		 * ---------------------------------------------
		*/
		if (s instanceof ResonantSystem) {
			ResonantSystem Rs =  (ResonantSystem)s;
			RingSystem rs = Rs.rs;
			MoonSystem ms = Rs.ms;
			push();
			shader(ctx.shader, POINTS);

			Material mat = RingMat1;
			if (mat == null) {
				mat = ctx.mat;
			}
			stroke(mat.strokeColor, mat.partAlpha);
			strokeWeight(mat.strokeWeight);

			ctx.shader.set("weight", mat.partWeight);
			ctx.shader.set("sprite", mat.spriteTexture);
			ctx.shader.set("diffTex", mat.diffTexture);
			ctx.shader.set("view", pg.camera); //don't touch that :-)

  
			if (renderType==1) {
				beginShape(POINTS);
			} 
			else {
				beginShape(LINES);
			}
			for (int ringI = 0; ringI < rs.particles.size(); ringI++) {
				Particle p = rs.particles.get(ringI);
				vertex(scale*p.position.x, scale*p.position.y, scale*p.position.z);
			}
			endShape();

			pop();

			if (withMoon) {
				ellipseMode(CENTER);
				push();
				for (Particle p : ms.particles) {

					Moon m=(Moon)p;
					pushMatrix();
					//translate(width/2, height/2);
					fill(m.c);
					stroke(m.c);
					//strokeWeight(m.radius*scale);
					//strokeWeight(10);

					//beginShape(POINTS);
					translate(scale*m.position.x, scale*m.position.y, 0);
					sphere(m.radius*scale);
					//vertex(scale*m.position.x, scale*m.position.y, 2*m.radius*scale);
					//endShape();
					// circle(scale*position.x, scale*position.y, 2*radius*scale);
					popMatrix();
				}
			pop();
			}

    	} 
		/* ---------------------------------------------
		*
		* Ringmind System renderer
		*
		* ---------------------------------------------
		*/
		else if (s instanceof RingmindSystem) {
			RingmindSystem rms = (RingmindSystem)s;
			RingSystem rs = rms.rs;
			MoonSystem ms = rms.ms;
			push();
			shader(ctx.shader, POINTS);

			for (int i = 0; i < rs.rings.size(); i++) {
				Ring r = rs.rings.get(i);
				Material mat = r.material;
				if (mat == null) {
					mat = ctx.mat;
				}
				stroke(mat.strokeColor, mat.partAlpha);
				strokeWeight(mat.strokeWeight);

				ctx.shader.set("weight", mat.partWeight);
				ctx.shader.set("sprite", mat.spriteTexture);
				ctx.shader.set("diffTex", mat.diffTexture);
        
				ctx.shader.set("view", pg.camera); //don't touch that :-)


				if (renderType==1) {
					beginShape(POINTS);
				} 
				else {
					beginShape(LINES);
				}
				for (int ringI = 0; ringI < r.getMaxRenderedParticle(); ringI++) {
					RingParticle p = r.particles.get(ringI);
					vertex(scale*p.position.x, scale*p.position.y, scale*p.position.z);

					/*
					push();
					translate(scale*p.position.x, scale*p.position.y, scale*p.position.z);
					sphereDetail(6);
					sphere(2);      
					pop();	 */
				}
				endShape();
			}
			pop();

			if (withMoon) {
 

				ellipseMode(CENTER);

				for (Particle p : ms.particles) {

					Moon m=(Moon)p;
					push();
					//pushMatrix();
					//translate(width/2, height/2);
					fill(m.c);
					stroke(m.c);
					//strokeWeight(m.radius*scale);
					strokeWeight(1);

					//beginShape(POINTS);
					translate(scale*m.position.x, scale*m.position.y, 0);
					sphere(m.radius*scale);
					//vertex(scale*m.position.x, scale*m.position.y, 2*m.radius*scale);
					//endShape();
					// circle(scale*position.x, scale*position.y, 2*radius*scale);
					pop();
				}
				//pop();
			
				// for (Particle p : ms.particles) {



				/*
				switch(renderMode){


				case nub3D:
				//push();
				//    for (int PP = 0; PP < ms.particles.size(); PP++){
				//      Moon m=(Moon)ms.particles.get(PP);
				//        //print(m);
				//      nodeMoons.get(PP).changePosition(new Vector(scale*m.position.x,scale*m.position.y,0));
					
				//    }
				//pop();


					break;

				case nativeMode :

					
					//pop();
							
				break;


				} */

				//nodePlanets.get(0).changePosition(new Vector(0,0,0));
				push();
				translate(0, 0, 0);
				sphereDetail(30);
				sphere(20);      
				pop(); 

				//			}

			}
		}
		/* ---------------------------------------------
		 *
		 * Shearing box renderer
		 *
		 * ---------------------------------------------
		*/
		else if (s instanceof ShearSystem) {

			//println("TEST");
			ShearSystem ss = (ShearSystem)s;

			/*
			** Render a circle around the planet at this orbital dista-nce.
			*/
			push();

			float x0 = 1e3*height/ss.Lx;
			float y0 = 0*height/ss.Ly;
			float r_planet = 60268e3;
			float r_ring = 1.5*60268e3;

			stroke(255);
			fill(255,0,0);


			pop();

			hint(DISABLE_DEPTH_TEST);
			hint(ENABLE_DEPTH_TEST);

			//not sure if this actually does anythign
			push();
			shader(ctx.shader, POINTS);
			
			Material mat = ss.material;
			if (mat == null) {
				mat = ctx.mat;
			}

			stroke(mat.strokeColor, mat.partAlpha);
			strokeWeight(mat.strokeWeight);

			ctx.shader.set("weight", mat.partWeight);
			ctx.shader.set("sprite", mat.spriteTexture);
			ctx.shader.set("diffTex", mat.diffTexture);
			ctx.shader.set("view", pg.camera); //don't touch that :-)
			pop();



			/*
			* Render all the Trace Particles
			*/
			if(useTrace){
				Iterator it = traceParticles.iterator();
				strokeWeight(1);
				while(it.hasNext()){
					TraceParticle tp = (TraceParticle) it.next();
					stroke(tp.c);

					switch(renderMode){
						case nativeMode:
							if (Toggle3D) {
								line(-tp.lastPos.y*width/LY, -2*tp.lastPos.x*height/LY, tp.lastPos.z, 
									 -tp.position.y*width/LY, -2*tp.position.x*height/LY, tp.position.z
									);
							} else {
								line(-tp.lastPos.y*width/LY, -2*tp.lastPos.x*height/LY, 
									 -tp.position.y*width/LY, -2*tp.position.x*height/LY
									);
							}
							break;
					}
				}
				stroke(0);
				strokeWeight(0);
			}

			/*
			** Render all the particles
			*/
			for (int PP = 0; PP < ss.particles.size(); PP++) {

				ShearParticle sp = (ShearParticle)ss.particles.get(PP);
				color c = sp.c;
				//Assigns a colour to particles that origonate on each of these band along the x axis
				// fill() determines the colour by fill(Red,Green,Blue) 
				fill(c);//White
				stroke(c);

										//ellipse(-sp.position.y*width/ss.Ly, -sp.position.x*height/ss.Lx, 2*sp.radius*width/ss.Ly, 2*sp.radius*height/ss.Lx);      
				switch(renderMode){
					case nativeMode:
						if(Toggle3D){
							push();
							translate(-sp.position.y*width/ss.Ly, -2*sp.position.x*height/ss.Ly, sp.position.z);
							sphereDetail(3);
							sphere(sp.radius*SliderScale);      
							pop();
						} 
						else {
							ellipse(-sp.position.y*width/ss.Ly, -2*sp.position.x*height/ss.Ly, max(1, 2*sp.radius*width/ss.Ly), max(1, 4*sp.radius*height/ss.Ly));      
						}
						break;

					case nub3D:
						// nodeParticles.get(PP).changePosition(new Vector(-sp.position.y*width/ss.Ly, -sp.position.x*height/ss.Lx, sp.position.z));
						// nodeParticles.get(PP).changeColour(c);
						break;

					default :
						// ellipse(-sp.position.y*width/ss.Ly, -sp.position.x*height/ss.Lx, 2*sp.radius*width/ss.Ly, 2*sp.radius*height/ss.Lx);      
						break;

				}
				stroke(0);
				fill(0);
		
			}
			

			if (ss.Guides) {
				//Renders the velocities and accelerations for particles
				//Has not been updated to work in 3D
				for (int PP = 0; PP < ss.particles.size(); PP++) {
					ShearParticle sp = (ShearParticle)ss.particles.get(PP);
					//ss.displayPosition(sp.position, 1, color(255, 0, 0));
					push();
					translate(-sp.position.y*width/ss.Ly, -2*sp.position.x*height/ss.Ly, 0);
					//circle(0, 0, 2*scale*sp.radius*width/ss.Ly);
					ss.displayPVector(sp.velocity, 100, color(0, 255, 0)); //green
					ss.displayPVector(sp.acceleration, 1000000, color(0 , 0, 255)); //blue
					pop();
				}
			}
			//moonlet
			if (Moonlet) {
				fill(255);//Grey
				if(Toggle3D){
					//Renders 3D moonlet
					stroke(255);
					pushMatrix();
					lights();
					translate(-ss.moonlet.position.y*width/ss.Ly, -2*ss.moonlet.position.x*height/ss.Ly, ss.moonlet.position.z);
					sphereDetail(60);
					sphere((int) ss.moonlet.radius*width/ss.Ly);
					popMatrix();
					stroke(0);
				}
				else{
					//Renders 2D Moonlet
					ellipse(-ss.moonlet.position.y*width/ss.Ly, -2*ss.moonlet.position.x*height/ss.Ly, 2*ss.moonlet.radius*width/ss.Ly, 4*ss.moonlet.radius*height/ss.Ly);    
				}
			}


			//Adds a texture to the moonlet, slows things down a lot and doesn't look that good anyway 
			//pushMatrix();
			//fill(255);
			//sphereDetail(10);
			//PImage moonTexture;
			//PShape Moon;
			//moonTexture = loadImage("plutomap1k.jpg");
			//Moon = createShape(SPHERE, 200);
			//Moon.setTexture(moonTexture);
			//shape(Moon);
			//popMatrix();


		/* ---------------------------------------------
		*
		* Tilt system renderer
		*
		* ---------------------------------------------
		*/
		} 
		else if (s instanceof TiltSystem) {
      
			push();
			shader(ctx.shader, POINTS);
			//Ring r = rs.rings.get(0);
			// Ring r = rs.rings.get(i);
      		TiltSystem r = (TiltSystem) s;
  
			// Assuming centralCircleRadius is a float defined in your TiltSystem class
			//float centralCircleRadius = 50; // Example radius, adjust as needed
			
				
			// After this, you would typically display the PGraphics on the main canvas
			// image(pg, 0, 0);
			Material mat = r.material;
			if (mat == null) {
				mat = ctx.mat;
			}

			stroke(mat.strokeColor, mat.partAlpha);
			strokeWeight(mat.strokeWeight);

			ctx.shader.set("weight", mat.partWeight);
			ctx.shader.set("sprite", mat.spriteTexture);
			ctx.shader.set("diffTex", mat.diffTexture);
			ctx.shader.set("view", pg.camera); //don't touch that :-)

			beginShape(POINTS);
			for (int ringI = 0; ringI < r.particles.size(); ringI++) {
				TiltParticle tp = (TiltParticle)r.particles.get(ringI);
				PVector position1 = tp.displayRotate();
				vertex(scale*position1.x, scale*position1.y, scale*position1.z);
			}
			//add the sphere to the centre using the following...
			endShape();
			translate(0, 0, 0);
			sphereDetail(30);
			sphere(20);      
 
  
			pop();
		}



	}



  /**Render Method
   *@param s Particle System to render.
   *@param ctx 
   *@param renderType
   */
  void renderComms(System s, RenderContext ctx, int renderType) {
    PGraphicsOpenGL pg = (PGraphicsOpenGL) ctx.pgfx.g;
    RingmindSystem rms= (RingmindSystem)s;
    push();
    shader(ctx.shader, POINTS);

    Ring r = rms.rs.rings.get(0);
    // Ring r = rs.rings.get(i);

    Material mat = r.material;
    if (mat == null) {
      mat = ctx.mat;
    }

    stroke(mat.strokeColor, mat.partAlpha);
    strokeWeight(mat.strokeWeight);

    ctx.shader.set("weight", mat.partWeight);
    ctx.shader.set("sprite", mat.spriteTexture);
    ctx.shader.set("diffTex", mat.diffTexture);
    ctx.shader.set("view", pg.camera); //don't touch that :-)


    //now lets go through all those particles and see if they are near to another and draw lines between them

    //stroke(255);
    //strokeWeight(10);
     if (renderType==1) {
       beginShape(LINES);
      } else {
       beginShape(POINTS);
      }
    
    for (int i=0; i <1000; i++) {
      RingParticle rp = (RingParticle) r.particles.get(i);
      float distance=0;
      for (int j=0; j <1000; j++) {
        RingParticle rpj = (RingParticle) r.particles.get(j);
        distance = dist(scale*rp.position.x, scale*rp.position.y, scale*rpj.position.x, scale*rpj.position.y);
        if (distance < 20) {
          vertex(scale*rp.position.x, scale*rp.position.y);
          vertex(scale*rpj.position.x, scale*rpj.position.y);
        }
      }
    }
    endShape();

    pop();
  }
}

//----------------------------------------------------------------------------------------

/** Class RenderContext - what it is going to render (material and shader) and where (PApplet - sketch).
 * @author ashley james brown march-may.2019
 */
class RenderContext {
  RenderContext() {
    mat = new Material();
  }
  PShader shader;
  Material mat;
  PApplet pgfx;
}

//-----------------------------------------------------------------------------------------
/**
 *Custom Shaders for filter effects
 */
PShader gaussianBlur, metaBallThreshold;
/** Configures Filters
 */
void loadFilters() {

  // Load and configure the filters
  gaussianBlur = loadShader("gaussianBlur.glsl");
  gaussianBlur.set("kernelSize", 32); // How big is the sampling kernel?
  gaussianBlur.set("strength", 7.0); // How strong is the blur?

  //maybe? gives a kind of metaball effect but only at certain angles
  metaBallThreshold = loadShader("threshold.glsl");
  metaBallThreshold.set("threshold", 0.5);
  metaBallThreshold.set("antialiasing", 0.05); // values between 0.00 and 0.10 work best
}

/** Applies Filters
 */
void applyFilters() {
  // Vertical blur pass
  gaussianBlur.set("horizontalPass", 0);
  filter(gaussianBlur);

  // Horizontal blur pass
  gaussianBlur.set("horizontalPass", 1);
  filter(gaussianBlur);

  //remove this for just a blurry thing without going to black and white but when backgroudn trails work could be glorious overly bright for teh abstract part
  // filter(metaBallThreshold); //this desnt work too well with depth rendering.
}

//-----------------------------------------------------------------------------------------
/** Class Material - represents a Material used to texture particles
 * @author ashley james brown march-may.2019
 */
class Material {
  PImage diffTexture;
  PImage spriteTexture;
  color strokeColor = 255;
  float partWeight = 1;      //do not change or sprite texture wont show unless its 1.
  float partAlpha = 0;       //trick to fade out to black.
  float strokeWeight = 1;    //usually 1 so we can see our texture but if we turn off we can make a smaller particle point as long as the weight above is bigger than 1.
}

/** Ring Particle Materials
 */
Material RingMat1, RingMat2, RingMat3, RingMat4, RingMat5, RingMat6;

/** Shearing Particle Material
 */
Material ShearMat1;

/** Method that assigns material objects to all the Material variables. 
 *  
 */
void createMaterials() {

  //----------- Materials for RingSystem ---------------

  // first ring material is the deafult material fully showing
  RingMat1 =  new Material();
  RingMat1.strokeColor = color(255, 255, 255);
  RingMat1.spriteTexture = loadImage("partsmall.png");
  RingMat1.diffTexture = pg;
  RingMat1.strokeWeight = 1; //.1;
  RingMat1.partWeight = 10;
  RingMat1.partAlpha=255;

  //pink
  // second ring material to be different just as proof of concept
  RingMat2 =  new Material();
  RingMat2.strokeColor = color(203, 62, 117);
  RingMat2.spriteTexture = loadImage("partsmall.png");
  RingMat2.diffTexture = pg;
  RingMat2.strokeWeight = 2.1;//.1
  RingMat2.partWeight = 10;
  RingMat2.partAlpha=255;

  // second ring material to be different just as proof of concept
  //more blue
  RingMat3 =  new Material();
  RingMat3.strokeColor = color(54, 73, 232);
  RingMat3.spriteTexture = loadImage("partsmall.png");
  RingMat3.diffTexture = pg;
  RingMat3.strokeWeight = 2.1;//.1
  RingMat3.partWeight = 10;
  RingMat3.partAlpha=255;

  RingMat4 =  new Material();
  RingMat4.strokeColor = color(204, 206, 153);
  RingMat4.spriteTexture = loadImage("partsmall.png");
  RingMat4.diffTexture = pg;
  RingMat4.strokeWeight = 2.1;//.1
  RingMat4.partWeight = 10;
  RingMat4.partAlpha=255;

  RingMat5 =  new Material();
  RingMat5.strokeColor = color(153, 21, 245);
  RingMat5.spriteTexture = loadImage("partsmall.png");
  RingMat5.diffTexture = pg;
  RingMat5.strokeWeight = 2.1;//.1
  RingMat5.partWeight = 10;
  RingMat5.partAlpha=255;

  RingMat6 =  new Material();
  RingMat6.strokeColor = color(24, 229, 234);
  RingMat6.spriteTexture = loadImage("partsmall.png");
  RingMat6.diffTexture = pg;
  RingMat6.strokeWeight = 2.1;//.1
  RingMat6.partWeight = 10;
  RingMat6.partAlpha=255;

  //----------- Materials for ShearSystem ---------------

  ShearMat1 =  new Material();
  ShearMat1.strokeColor = color(255, 255, 255);
  ShearMat1.spriteTexture = loadImage("partsmall.png");
  ShearMat1.diffTexture = pg;
  ShearMat1.strokeWeight = 2.1;//.1
  ShearMat1.partWeight = 10;
  ShearMat1.partAlpha=255;
}

//----------Palette-----------------
//#FEB60A,#FF740A,#D62B00,#A30000,#640100,#FEB60A,#FF740A,#D62B00
//fire
//153,21,245
//----------------------------------


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/** Method to Output Debug Information to Window Title Bar.
 */
void titleText() {
  String txt_fps;
  try {
    txt_fps = String.format(getClass().getSimpleName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f] [Time Elapsed in Seconds %d] [Simulation Time Elapsed in Hours %d]", width, height, frameCount, frameRate, int(millis()/1000.0), int(s.totalSystemTime/3600.0) );
  }
  catch(Exception e) {
    txt_fps = "";
  }
  surface.setTitle(txt_fps);
}
