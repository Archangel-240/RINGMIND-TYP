//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//-----------GUI---------------------

Slider2D mm;
float SliderScale = 1;

public Textlabel LabelA;
public Textlabel LabelB;
public Slider SliderA;

class ControlFrame extends PApplet {
    Boolean keepRingGap = false;
    String N = Integer.toString(n_particles);

    boolean daphnisMode = false;


    int w, h;
    PApplet parent;
    float minDensity = 0;
    float maxDensity = 5000;
    float stepSize = 10; // The smallest increment value required for the slider
    
	//calculate the number of tick marks needed for the desired step size
    int tickMarks = (int)(maxDensity - minDensity / stepSize);
    
    public ControlFrame(PApplet _parent, int _w, int _h, String name) {
        super();
        parent = _parent;
        w = _w;
        h = _h;
        PApplet.runSketch(new String[] {
            this.getClass().getName()
        }, this);

    }

    public void settings() {
        size(270, 800);
    }
    
    public void addFineAdjustmentButtons(String sliderName, int sliderPosX, int sliderPosY, float increment) {
		// Position the increment button
		cp5.addButton("Increase" + sliderName)
			.setLabel("+")
			.setPosition(sliderPosX + 200, sliderPosY) // Position right next to the slider
			.setSize(20, 20)
			.onClick(new CallbackListener() {
				public void controlEvent(CallbackEvent event) {
					float currentValue = cp5.getController(sliderName).getValue();
					cp5.getController(sliderName).setValue(currentValue + increment);
				}
			});

		// Position the decrement button
		cp5.addButton("Decrease" + sliderName)
			.setLabel("-")
			.setPosition(sliderPosX + 225, sliderPosY) // Position right next to the increment button
			.setSize(20, 20)
			.onClick(new CallbackListener() {
				public void controlEvent(CallbackEvent event) {
					float currentValue = cp5.getController(sliderName).getValue();
					cp5.getController(sliderName).setValue(currentValue - increment);
				}
			});
	}
    
    public void setup() {
        surface.setLocation(0, 0);

        test();
    }

    void test() {
        PFont A = createFont("Verdana", 9);
        PFont B = createFont("Verdana", 12);
        PFont C = createFont("Verdana", 8);
        PFont D = createFont("Verdana", 11);

        ControlFont fontA = new ControlFont(A);
        ControlFont fontB = new ControlFont(B);
        ControlFont fontC = new ControlFont(C);
        ControlFont fontD = new ControlFont(D);
        cp5 = new ControlP5(this);
        cp5.setFont(fontA);
		

        cp5.getTab("default")
            //.setColorBackground(color(0, 160, 100))
			.setLabel("Shearing Box")
            .setColorLabel(color(255))
            .setColorActive(color(255, 128, 0))
			.activateEvent(true)
			.setId(0);
		
        cp5.addTab("Ring System")
            .setColorBackground(color(0, 160, 100))
            .setColorLabel(color(255))
            .setColorActive(color(255, 128, 0))
			.activateEvent(true)
			.setId(1);
			
        cp5.addTab("Tilt System")
            .setColorBackground(color(0, 160, 100))
            .setColorLabel(color(255))
            .setColorActive(color(255, 128, 0))
			.activateEvent(true)
			.setId(2);
			
        cp5.addTab("Resonance")
            .setColorBackground(color(0, 160, 100))
            .setColorLabel(color(255))
            .setColorActive(color(255, 128, 0))
			.activateEvent(true)
			.setId(3);


        //PLAY

        cp5.addTextlabel("PLAY")
            .setPosition(115, 300)
            .setText("PLAY")
            .setFont(fontB)
            .setColorValue(0xff000000);

        //Slider to vary the orbital hight of the shearing box
        cp5.addSlider("OrbitRadius")
            .setCaptionLabel("Orbit Radius")
            .setRange(50000000, 300000000)
            .setValue(136000000)
            .setPosition(10, 330)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        SliderA = cp5.addSlider("RingGapSize")
            .setCaptionLabel("Ring Gap")
            .setRange(0, LX*0.9)
            .setValue(LX/2)
            .setPosition(10, 360)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        //Slider to vary moonlet radius     
        cp5.addSlider("Moon Radius")
            //.plugTo(parent, "r0")
            .setRange(10, 500)
            .setValue(150)
            .setPosition(10, 390)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        //Slider to vary moonlet Density     
        cp5.addSlider("Moonlet Density")
            .setCaptionLabel("Moon Density")
            .setValue(1000)
            .setRange(10, 5000)
            .setPosition(10, 420)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        //Slider to vary particle size
        cp5.addSlider("ParticleSize")
            .setCaptionLabel("Particle Size")
            .setRange(1, 5)
            .setPosition(10, 450)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        // 2D slider that lets you pick of position on screen and for you to create a moonlet   
        mm = cp5.addSlider2D("MoonPosition")
            .setCaptionLabel("Moon Position")
            .setPosition(10, 480)
            .setSize(250, 125)
            .setMinMax(-LY/2, -LX/2, LY/2, LX/2)
            .setValue(0, 0)
            //.disableCrosshair()
            .setColorLabel(0xff000000)
            .setColorValue(0xff000000);

        //Turn moonlet on/off
        cp5.addButton("ToggleMoonlet")
            .setCaptionLabel("Toggle Moon")
            .setPosition(10, 640)
            .setSize(80, 50);

        //Creates a moonlet at position selected on the 2D slider; will remove old moonlet      
        cp5.addButton("CreateMoon")
            .setCaptionLabel("Create Moon")
            .setPosition(95, 640)
            .setSize(80, 50);

        //Resets the moonlet position and slider possition back to (0,0)       
        cp5.addButton("ResetMoon")
            .setCaptionLabel("Reset Moon")
            .setPosition(180, 640)
            .setSize(80, 50);
            
        cp5.addButton("PVelocityVector")
            .setCaptionLabel("View PVelocityVector")
            .setPosition(10,700)
            .setSize(80,50);
            
            
        // cp5.addButton("DisplayAxes")
        //     .setCaptionLabel("Display Axes")
        //     .setPosition(95, 700 ) 
        //     .setSize(80, 50);

        cp5.addButton("SetDaphnis")
            .setCaptionLabel("Toggle\nDaphnis")
            .setPosition(95, 700 ) 
            .setSize(80, 50);

         
            //toggle moonlet particle collisions
        cp5.addButton("ToggleCollision")
            .setCaptionLabel("Toggle\nMoonlet\nCollision")
            .setPosition(180, 700 ) 
            .setSize(80, 50);
        
        // SETUP
        cp5.addTextlabel("Setup")
            .setPosition(110, 10)
            .setText("SETUP")
            .setFont(fontB)
            .setColorValue(0xff000000);

		cp5.addButton("CustomSize")
			.setCaptionLabel("Custom\nZoom")
			.setPosition(10, 40)
			.setSize(55, 50);

        //  //Half the dimensions of the shearing box
        cp5.addButton("ZoomIn")
            .setCaptionLabel("Zoom In")
            .setPosition(75, 40)
            .setSize(55, 25);

        //Double the dimensions of the shearing box
        cp5.addButton("ZoomOut")
            .setCaptionLabel("Zoom Out")
            .setPosition(75, 65)
            .setSize(55, 25);

        //Resets all particles to new random start points
        cp5.addButton("Reset")
            .setPosition(140, 40)
            .setSize(55, 50)
			.moveTo("global");

        //Swaps between 2D and 3D (also calls Reset)
        cp5.addButton("Toggle3D")
            .setCaptionLabel("2D/3D")
            .setPosition(205, 40)
            .setSize(55, 50)
			.moveTo("global");

        //Adds 100 particles to the shearing box (also calls Reset)  
        cp5.addButton("MoreParticles")
            .setCaptionLabel("+ 100")
            .setPosition(70, 100)
            .setSize(50, 50);

        //Removes 100 particles from the shearing box (also calls Reset)  
        cp5.addButton("LessParticles")
            .setCaptionLabel("- 100")
            .setPosition(10, 100)
            .setSize(50, 50);

        //Label displaying number of particles on screen
        cp5.addTextlabel("#Particles")
            .setPosition(130, 100)
            .setText("PARTICLES:")
            .setFont(fontD)
            .setColorValue(0xff000000);

        LabelA = cp5.addTextlabel("ParticleN")
            .setPosition(220, 100)
            .setText(N)
            .setFont(fontD)
            .setColorValue(0xff000000);

        cp5.addTextlabel("#BoxSize")
            .setPosition(130, 125)
            .setText("Box\nDimensions:")
            .setFont(fontD)
            .setColorValue(0xFF000000);
        
        LabelB = cp5.addTextlabel("Dimensions")
            .setPosition(220, 125)
            .setText(Integer.toString(LY) + "/\n" + Integer.toString(LX))
            .setFont(fontD)
            .setColorValue(0xFF000000);

        //Turns on/off the ring gap (also calls Reset)
        cp5.addButton("RingGap")
            .setPosition(10, 160)
            .setSize(120, 50);

        //Turns on/off the top half of the ring (also calls Reset)      
        cp5.addButton("HalfRing")
            .setPosition(140, 160)
            .setSize(120, 50);

        cp5.addButton("ViewReset").setPosition(10, 240).setSize(120, 50);

        cp5.addButton("WakeMode").setPosition(140, 240).setSize(120, 50);
       
        

        cp5.addButton("Unstable")
            .setPosition(10, 160)
            .setSize(120, 50).moveTo("Ring System");

        //Turns on/off the top half of the ring (also calls Reset)      
        cp5.addButton("Connected")
            .setPosition(140, 160)
            .setSize(120, 50)
            .moveTo("Ring System");;

        cp5.addButton("Saturn").setPosition(10, 240).setSize(120, 50).moveTo("Ring System");;

        cp5.addButton("RingMind").setPosition(140, 240).setSize(120, 50).moveTo("Ring System");;

        controlsSetup = true;    }

    void test2() {

        PFont A = createFont("Verdana", 9);
        PFont B = createFont("Verdana", 12);
        PFont C = createFont("Verdana", 8);
        PFont D = createFont("Verdana", 11);

        ControlFont fontA = new ControlFont(A);
        ControlFont fontB = new ControlFont(B);
        ControlFont fontC = new ControlFont(C);
        ControlFont fontD = new ControlFont(D);

        // surface.setLocation(100, 100);
        cp5 = new ControlP5(this);
        cp5.setFont(fontA);

        //PLAY

        cp5.addTextlabel("PLAY")
            .setPosition(115, 300)
            .setText("PLAY")
            .setFont(fontB)
            .setColorValue(0xff000000);

        //Slider to vary the orbital hight of the shearing box
        cp5.addSlider("Orbit Radius")
        //adjusted the lower range to 1e7 meters 
            .setRange(10000000, 300000000)
            .setValue(100000000)
            .setPosition(10, 330)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        //Slider to vary moonlet radius     
        cp5.addSlider("Moon Radius")
            //.plugTo(parent, "r0")
            //reduced the upper range
            .setRange(10, 100)
            .setValue(100)
            .setPosition(10, 360)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        //Slider to vary moonlet Density     
        cp5.addSlider("Moonlet Density")
            .setCaptionLabel("Moon Density")
            .setValue(1000)
            .setRange(minDensity, maxDensity)
            .setPosition(10, 390)
            .setSize(180, 20)
            .setColorLabel(0xff000000)
            .setNumberOfTickMarks(tickMarks + 1); // +1 because it includes both ends of the slider

        //Slider to vary particle size
        cp5.addSlider("ParticleSize")
            .setCaptionLabel("Particle Size")
			//reduced the lower range
            .setRange(0.1, 5)
            .setPosition(10, 420)
            .setSize(180, 20)
            .setColorLabel(0xff000000);

        // 2D slider that lets you pick of position on screen and for you to create a moonlet   
        mm = cp5.addSlider2D("MoonPosition")
            .setCaptionLabel("Moon Position")
            .setPosition(10, 450)
            .setSize(250, 125)
            .setMinMax(-LY/2, -LX/2, LY/2, LX/2)
            .setValue(0, 0)
            //.disableCrosshair()
            .setColorLabel(0xff000000)
            .setColorValue(0xff000000);

        //Turn moonlet on/off
        cp5.addButton("ToggleMoonlet")
            .setCaptionLabel("Toggle Moon")
            .setPosition(10, 610)
            .setSize(80, 50);

        //Creates a moonlet at position selected on the 2D slider; will remove old moonlet      
        cp5.addButton("CreateMoon")
            .setCaptionLabel("Create Moon")
            .setPosition(95, 610)
            .setSize(80, 50);

        //Resets the moonlet position and slider possition back to (0,0)       
        cp5.addButton("ResetMoon")
            .setCaptionLabel("Reset Moon")
            .setPosition(180, 610)
            .setSize(80, 50);
       
        //toggle the particle velocity vector on and off
       cp5.addButton("PVelocityVector")
         .setCaptionLabel("View PVelocityVector")
         .setPosition(10, 700 ) 
         .setSize(80, 50);
         
          //toggle the particle velocity vector on and off
       cp5.addButton("DisplayAxes")
         .setCaptionLabel("Display Axes")
         .setPosition(95, 700 ) 
         .setSize(80, 50);
         
       


    }
    void draw() {
        background(190);
    }

	void exit(){
		parent.exit();
	}

	void stop() {

	}

    //These are all the methods corresponding to the buttons above so I won't commment them all again
	void controlEvent(ControlEvent theControlEvent) {
		
	
		
		if (theControlEvent.isTab()) {
			if(theControlEvent.getTab().getId() == 0){
				systemState= State.shearState;
				setupStates();
				
			}else if(theControlEvent.getTab().getId() == 1){
				//ringmindStableState
				systemState= State.ringmindState;
				setupStates();
				//setupNodeParticles(1);
				
			}else if(theControlEvent.getTab().getId() == 2){
				systemState= State.formingState;
				setupStates();
				
			}else if(theControlEvent.getTab().getId() == 3){
				
				systemState= State.resonanceState;
				setupStates();
				
			}
			
			println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
		}
	}
    void ToggleMoonlet() {
        Moonlet = !Moonlet;
    }

	void CustomSize() {
		sbcf = new SimBoxControlFrame(parent, "Sim Size Controls");
	}

    void ZoomIn() {
        if(gapSize > LX*0.45){
            return;
        }
        SliderScale *= 2;
        LX = LX / 2;
        LY = LY / 2;
        setupStates();
        LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));
        SliderA.setRange(0, LX*0.9);
        SliderA.setValue(gapSize);
		mm.setMinMax(-LY/2, -LX/2, LY/2, LX/2);

    }

    void ZoomOut() {
        SliderScale *= 0.5;
        LX = LX * 2;
        LY = LY * 2;
        setupStates();
        LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));
        SliderA.setRange(0, LX*0.9);
        SliderA.setValue(gapSize);
        mm.setMinMax(-LY/2, -LX/2, LY/2, LX/2);

		
    }

    void Reset() {
        setupStates();
        scene.fit();
    }

    void Toggle3D() {
		/*         
		if(renderMode != RenderState.native3D){
        	renderMode = RenderState.native2D;
            Toggle3D = !Toggle3D;
        	Reset();
        } else {
          renderMode = RenderState.native3D;
        	Toggle3D = !Toggle3D;
        	Reset();
		}
        */
        Toggle3D = !Toggle3D;

    }

    void RingGap() {
        RingGap = !RingGap;
        HalfRing = false;
        Reset();
    }

    void HalfRing() {
        HalfRing = !HalfRing;
        RingGap = false;
        Reset();
    }

    void MoreParticles() {
        n_particles += 100;
        N = Integer.toString(n_particles);
        LabelA.setText(N);
        Reset();
    }

    void LessParticles() {
        n_particles -= 100;
        N = Integer.toString(n_particles);
        LabelA.setText(N);
        println(N);
        Reset();
    }

    void ResetMoon() {
        ShearSystem ss = (ShearSystem) s;
        mm.setValue(0, 0);

        cp5.getController("Moon Radius").setValue(100);
        cp5.getController("Moonlet Density").setValue(999.99);

        ss.moonlet = new Moonlet();
    }

    void CreateMoon() {
        ShearSystem ss = (ShearSystem) s;
        Moonlet = true;

        ss.moonlet = new Moonlet();

        ss.moonlet.position.y = -mm.getArrayValue()[0];
        ss.moonlet.position.x = -mm.getArrayValue()[1];
        ss.moonlet.position.z = 0;
        ss.moonlet.velocity = new PVector();
        ss.moonlet.velocity.y = 1.5 * ss.Omega0 * ss.moonlet.position.x;

    }

    void ViewReset() {
        resetView();
    }

    void WakeMode() {
        ShearSystem ss = (ShearSystem) s;
        ss.wakeMode();
        LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));
        //renderType2 = !renderType2;
    }

    void SetDaphnis(){
        ShearSystem ss = (ShearSystem) s;
        ss.simDaphnis();
		LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));
	}
    
    void Unstable(){
		//Unstable Ringmind State
		systemState= State.ringmindUnstableState;
		setupStates();
    }
    
    void Connected(){
		systemState= State.connectedState;
    	setupStates();
    }
	
	void RingMind(){
		systemState= State.ringmindState;
		setupStates();  
	}

    void Saturn(){
		systemState= State.saturnState;
		setupStates();  
  	}
    void PVelocityVector (){
		// display the particle velocity vectors.
		ShearSystem ss = (ShearSystem)s;
		ss.Guides = !ss.Guides;
    }
    
    void DisplayAxes(){
    }

    void ToggleCollision(){
        MoonletCollisions = !MoonletCollisions;
    }
}

class SimBoxControlFrame extends PApplet {

	int w = 270;
	int h = 150;
    PApplet parent;
	ControlP5 cp5b;

	int lx = LX;
	int ly = LY;

	int lastlx = LX;
	int lastly = LY;

	Textfield LYBox;
	Textfield LXBox;

	CheckBox aspectRatio;

	Button multX;
	Button divX;

	Button multY;
	Button divY;

	Button cancel;
	Button save;

	SimBoxControlFrame(PApplet _parent, String name){
		
		super();
		parent = _parent;

		PApplet.runSketch(new String[] {
            this.getClass().getName()
        }, this);

	}

    void settings() {
        size(w, h);
    }

	void setup(){
        surface.setLocation(10, 10);

        PFont A = createFont("Verdana", 9);
        PFont B = createFont("Verdana", 12);
        PFont C = createFont("Verdana", 8);
        PFont D = createFont("Verdana", 11);

        ControlFont fontA = new ControlFont(A);
        ControlFont fontB = new ControlFont(B);
        ControlFont fontC = new ControlFont(C);
        ControlFont fontD = new ControlFont(D);

		cp5b = new ControlP5(this);
		cp5b.setFont(fontB);

		LYBox = cp5b.addTextfield("simwidth")
			.setCaptionLabel("Similation Width (LY)")
			.setPosition(5, 5)
			.setSize(150, 30)
			.setInputFilter(cp5b.FLOAT)
			.setText(Integer.toString(ly));
		
		// LYBox.addListener(new keyListener());

		LXBox = cp5b.addTextfield("simheight")
			.setCaptionLabel("Simulation Height (LX)")
			.setPosition(5, 55)
			.setSize(150, 30)
			.setInputFilter(cp5b.FLOAT)
			.setText(Integer.toString(lx));

		aspectRatio = cp5b.addCheckBox("Preserve Aspect Ratio")
			.setPosition(225, 5)
			.setSize(30, 30)
			.addItem("aspect", 1)
			.activate("aspect")
			.hideLabels();

		cp5b.addTextlabel("CheckboxLabel")
			.setPosition(210, 35)
			.setSize(60, 45)
			.setMultiline(true)
			.setText(" Preserve   Aspect      Ratio");

		
		multY = cp5b.addButton("MultY")
			.setPosition(155, 5)
			.setSize(30, 15)
			.setCaptionLabel("×2");

		divY = cp5b.addButton("DivY")
			.setPosition(155, 20)
			.setSize(30, 15)
			.setCaptionLabel("÷2");


		multX = cp5b.addButton("MultX")
			.setPosition(155, 55)
			.setSize(30, 15)
			.setCaptionLabel("×2");

		divX = cp5b.addButton("DivX")
			.setPosition(155, 70)
			.setSize(30, 15)
			.setCaptionLabel("÷2");

		cancel = cp5b.addButton("cancel")
			.setPosition(0, 120)
			.setSize(120, 30)
			.setCaptionLabel("Cancel");

		save = cp5b.addButton("save")
			.setPosition(150, 120)
			.setSize(120, 30)
			.setCaptionLabel("Save");

	}

	void draw(){
		background(190);

		if(keyPressed){
			if(key == ENTER || key == RETURN){
				LYBox.setText(Integer.toString(ly));
				LXBox.setText(Integer.toString(lx));
			}

			else if(key == BACKSPACE){
				if(LYBox.isFocus()){
					String text = LYBox.getText();
					if(text.length() > 0){
						ly = Integer.valueOf(text);
						synchronise(LYBox);
					} else {
						ly = 0;
						LYBox.setText("0");
						synchronise(LYBox);
					}
				}
				else if(LXBox.isFocus()){
					String text = LXBox.getText();
					if(text.length() > 0){
						lx = Integer.valueOf(LXBox.getText());
						synchronise(LXBox);
					} else {
						lx = 0;
						LXBox.setText("0");
						synchronise(LXBox);
					}
				}
			}

			else {
				if(LYBox.isFocus()){
					String text = LYBox.getText();
					if(text.length() > 0){
						ly = Integer.valueOf(text);
						LYBox.setText(Integer.toString(ly));
						synchronise(LYBox);
					} else {
						ly = 0;
						LYBox.setText("0");
						synchronise(LYBox);
					}
				}
				else if(LXBox.isFocus()){
					String text = LXBox.getText();
					if(text.length() > 0){
						lx = Integer.valueOf(LXBox.getText());
						LXBox.setText(Integer.toString(lx));
						synchronise(LXBox);
					} else {
						lx = 0;
						LXBox.setText("0");
						synchronise(LXBox);
					}
					
				}
			}

			
			
		}

		// println(ly + ", " + lx + " | " + LYBox.getText() + ", " + LXBox.getText());

	}

	void exit(){
	}

	void stop() {
		Frame frame = ( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame();
		frame.dispose();
	}

	void synchronise(Textfield activeBox){

		if(aspectRatio.getState("aspect")){

			if(activeBox == LYBox){

				if(ly == 0){
					lx = 0;
				} 
				else if(lastly == 0){
					lx = ly;
				} 
				else if(lastly > 0){
					lx = (int) ((((float) ly) / ((float) lastly)) * ((float) lx));
				}
				
				LXBox.setText(Integer.toString(lx));
			}
			else if(activeBox == LXBox){

				if(lx == 0){
					ly = 0;
				} 
				else if(lastlx == 0){
					ly = lx;
				} 
				else if(lastlx > 0){
					ly = (int) ((((float) lx) / ((float) lastlx)) * ((float) ly));
				}

				LYBox.setText(Integer.toString(ly));
			}

		}
		lastlx = lx;
		lastly = ly;

	}

	void MultX(){
		lx *= 2.0;
		LXBox.setText(Integer.toString(lx));
		synchronise(LXBox);
	}

	void MultY(){
		ly *= 2.0;
		LYBox.setText(Integer.toString(ly));
		synchronise(LYBox);
	}

	void DivX(){
		lx = (int) (((float) lx) / 2.0);
		LXBox.setText(Integer.toString(lx));
		synchronise(LXBox);
	}

	void DivY(){
		ly = (int) (((float) ly) / 2.0);
		LYBox.setText(Integer.toString(ly));
		synchronise(LYBox);
	}

	void cancel(){
		stop();
	}

	void save(){
		LY = ly;
		LX = lx;
		SliderScale = 2000.0/ (float) LY;
        LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));

		if(gapSize > LX*0.9){
			gapSize = (int) (LX*0.5);
		}

		SliderA.setRange(0, LX*0.9);
        SliderA.setValue(gapSize);
		mm.setMinMax(-LY/2, -LX/2, LY/2, LX/2);


		setupStates();
		stop();
	}

	// void keyPressed(){
	// 	if(key == ENTER || key == RETURN || key == BACKSPACE){
	// 		return;
	// 	}

	// 	if(LYBox.isFocus()){
	// 		String text = LYBox.getText();
	// 		println(text);
	// 		if(text == "0"){
	// 			LYBox.setText("");
	// 		}
	// 	}
	// 	else if(LXBox.isFocus()){
	// 		String text = LXBox.getText();
	// 		if(text == "0"){
	// 			LXBox.setText("");
	// 		}
	// 	}
	// }

	// void simwidth(String ev){
	// 	LYBox.setText(Integer.toString(ly));
	// }

}

public class keyListener implements ControlListener {

	public void controlEvent(ControlEvent ev){
		println(ev);
		println(ev.getController().getValue());
	}

}