
/**Class ShearSystem
 *@author Thomas Cann
 */
  
 //These toggles need to be global for the Control P5 buttons to work
public Boolean Toggle3D = false;
public Boolean RingGap = false;
public Boolean HalfRing = false; 
public int LX = 1000;
public int LY = 2000;
public int gapSize = LX/2;
//public int Gapwidth = 2000;
public Boolean Moonlet = false; //Adds in the moonlet
public Boolean fixedMoonlet = false; //Adds in the moonlet
public Boolean daphnisMode = false;
Boolean wakeModeVar = false;
Boolean MoonletCollisions = true; // Particles can collide with the moonlet



class ShearSystem extends System {
  
  Boolean SelfGrav = true; // Toggle Self Gravity between particles
  Boolean ParticleCollisions = true; // Particles can collide with one another (no grid implentation yet, runs super slow)
  Boolean Output = false; //no idea
  Boolean A = true; // she ar forces that make this part of a sing and not just 1particles in a box
  Boolean Guides = true; // shows particle trajectories
  Boolean Reset = false; // leave this off
  Boolean DynamicMoon = false; // Moon oscillates up and down
  //Simulation dimensions [m]
  //int Lx = 1000;       //Extent of simulation box along planet-point line [m].
  //int Ly = 2000;       //Extent of simulation box along orbit [m].

  int Lx = LX; // round(1000*(1.0/SliderScale));
  int Ly = LY; // round(2000*(1.0/SliderScale));
  
  // gapSize = round(cp5.getController("RingGapSize").getValue());//35000;  //Width of the ring gap

  //Initialises Simulation Constants
  final float GM = 3.793e16;   //Shear Gravitational parameter for the central body, defaults to Saturn  GM = 3.793e16.
 //public float r0 = 100000000;   //Central position in the ring [m]. Defaults to 130000 km.
  
  //float r0 = 0.0;
  float r0 = 136500000;
  float Omega0 = sqrt(GM/(pow(r0, 3.0))); //The Keplerian orbital angular frequency (using Kepler's 3rd law). [radians/s]
  float S0 = -1.5*Omega0; //"The Keplerian shear. Equal to -(3/2)Omega for a Keplerian orbit or -rdOmega/dr. [radians/s]
  Moonlet moonlet;
  ShearGrid SG ;
  QuadTree QT;

  int rollingParticleId = 0;
  PrintWriter particleOutput;


  ShearSystem(boolean Guides) {
    this.Guides = Guides;
    SG = new ShearGrid(this);
    Rectangle Rect = new Rectangle(Lx/2, Ly/2, Lx, Ly);
    QT = new QuadTree(1, Rect);
    particles = new ArrayList<Particle>();
    traceParticles = new LinkedList<TraceParticle>();
    moonlet = new Moonlet();
    random_start();
    r0 = cp5.getController("OrbitRadius").getValue();

    if (particleExporting) setupParticleOutput(particleExportFilename);
  }

  /** Take a step using the Velocity Verlet (Leapfrog) ODE integration algorithm.
   * Additional Method to Check if particles have left simulation.
   */
  @Override void update() {
		//float r0;
	  //println("update ss");
	
		if(!fixedMoonlet){
			r0 = cp5.getController("OrbitRadius").getValue();
			moonlet.radius = cp5.getController("Moon Radius").getValue();
			moonlet.particle_rho = cp5.getController("Moonlet Density").getValue();
			gapSize = round(cp5.getController("RingGapSize").getValue()); ;//35000;  //Width of the ring gap
		}
    
	
    Omega0 = sqrt(GM/(pow(r0, 3.0))); //The Keplerian orbital angular frequency (using Kepler's 3rd law). [radians/s]
    S0 = -1.5*Omega0; //"The Keplerian shear. Equal to -(3/2)Omega for a Keplerian orbit or -rdOmega/dr. [radians/s]
    
    //Reads in the slider values 

    super.update();

    
    QT.ClearTree();
    
    


    for (Particle p : particles) { 
      ShearParticle x = (ShearParticle) p;

      // if(useTrace){
			traceParticles.addLast(new TraceParticle(x));
			if(traceParticles.size() > 1000000/n_particles * 100){
				traceParticles.removeFirst();
			}
      // } else {
      //   traceParticles.clear();
      // }

      //multiplies particle radii by slider value
      x.radius = x.InitRadius*cp5.getController("ParticleSize").getValue();

      if (SelfGrav) {
        //Fills the quadtree, splitting nodes where needed
        QT.Insert(x);
      }

      if (particle_outBox(x)) {
        //removes particles that are out of bounds
        x.Reset(this);
        x.setId(rollingParticleId);
        rollingParticleId++;
      }



      if (Moonlet) {
        if (MoonletCollisions) {
          if (Toggle3D) {
            //3D collisions
            x.MoonletCollision3D(this);
          } else {
            //2D collisions
            x.MoonletCollisionCheck(this);
          }
        }
        if (particle_inMoonlet(x)) {
          //Resets particles that accidentaly get stuck in the moonlet
          moonlet.collisionUpdate(x);
          cp5.getController("Moon Radius").setValue(moonlet.radius);
          cp5.getController("Moonlet Density").setValue(moonlet.particle_rho);
          x.Reset(this);
        }
      }
    }
    if (SelfGrav) {
      QT.TreeCofM();
    }
    if (ParticleCollisions) {
      //Fills the collision grid and checks for particle collisions
      SG.FillGrid(this);
      SG.CollisionCheck();
    }

    if (DynamicMoon) {
      moonlet.DynamicMoon(this);
    }
    
    // Moonlet obeys physics when moved outside of its standard orbit
    moonlet.updatePosition(s.dt);
    moonlet.updateVelocity(moonlet.getShear(this), s.dt);
    
    if (particleExporting) {
      writeParticles();
      writeMoonlet();
      particleOutput.flush();
    }

  }

  /** Method to boolean if Particle is out of ShearingBox.
   *@param x  A Particle to inject.
   *@return True if out of Shearing Box
   */
  boolean particle_outBox(ShearParticle x) {
    if ((x.position.x >Lx/2)||(x.position.x<-Lx/2)||(x.position.y<-Ly/2)||(x.position.y>Ly/2)||(x.position.z > 500)||(x.position.z < -500)) {
      return true;
    } else {
      return false;
    }
  }
  /** Method to boolean if Particle is out of ShearingBox.
   *@param x  A Particle to inject.
   *@return True if out of Shearing Box
   */
  boolean particle_inMoonlet(ShearParticle x) {
    PVector MoonVect = moonlet.position.copy();
    PVector Dist_Vector = MoonVect.sub(x.position);

    if ((Dist_Vector.mag() < moonlet.radius)) {
      return true;
    } else {
      return false;
    }
  }
  /** Method to inject a number of Particle object into Shearing Box.
   *@param n  Number of Particle to inject.
   */
  void random_inject(float n) {
    //particles.add(new Moonlet(this));
    for (int i = 0; i < n; i++) {
      ShearParticle p = new ShearParticle(this);
      p.setId(rollingParticleId);
      rollingParticleId++;
      //particles.add(new ShearParticle(this));
	  p.Index=i;
      particles.add(p);
      //p.Index=i;
    }
  }

  /** Method to Initialise the simulation with a random set of starting particles at the edges (in y).
   */
  void random_start() {
    random_inject(n_particles);
  }

  /** Method to calculate the Keplerian orbital period (using Kepler's 3rd law).
   *@param r  Radial position (semi-major axis) to calculate the period [m].
   *@return   The period [s].
   */
  float kepler_period(float r) {
    return 2.0*PI*sqrt((pow(r, 3.0))/GM);
  }

  /** Method to calculate the Keplerian orbital angular frequency (using Kepler's 3rd law).
   *@param r  Radial position (semi-major axis) to calculate the period [m].
   *@return   The angular frequency [radians/s].
   */
  float kepler_omega(float r) {
    return sqrt(GM/(pow(r, 3.0)));
  }

  /** Method to calculate the Keplerian orbital speed.
   *@param r  Radial position (semi-major axis) to calculate the period [m].
   *@return   The speed [m/s].
   */
  float kepler_speed(float r) {
    return sqrt(GM/r);
  }

  /** Method to calculate the Keplerian shear. Equal to -(3/2)Omega for a Keplerian orbit or -rdOmega/dr.
   *@param r Radial position (semi-major axis) to calculate the period [m]. 
   *@return Shear [radians/s].
   */
  float kepler_shear(float r) {
    return -1.5*kepler_omega(r);
  }


  void initTable() {
    addParticlesFromTable(this, "shearoutput.csv");
  }

  /**Display vector from the centre of screen to position that a particle is rendered
   * @param v vector to display from middle of screen.
   * @param scale multiple by magnitude.
   * @param c color of line.
   */
  void displayPosition(PVector v, float scale, color c) {
    stroke(c);
    line(0, 0, -v.y*scale*width/Ly, -v.x*scale*height/Lx);
  }

  /**Display vector from the centre of screen with length and direction of vector (no screen dimension scaling)
   * @param v vector to display from middle of screen.
   * @param scale multiple by magnitude.
   * @param c color of line.
   */
  void displayPVector(PVector v, float scale, color c) {
    stroke(c);
    line(0, 0, -v.y*scale, -v.x*scale);
  }
  
  public void wakeMode(){
    wakeModeVar = !wakeModeVar;
    if(wakeModeVar){
      n_particles = 2000;
      LX = 70000;
      LY = 800000;
      cp5.getController("OrbitRadius").setValue(136500000);
      cp5.getController("Moon Radius").setValue(3800);
      //cp5.getController("Moonlet Density").setValue(3800);
      
      systemState= State.shearState;
      setupStates();
      
      ShearSystem ss = (ShearSystem)s;
      gapSize = 35000;
      //ss.r0 = 136500000;
      Moonlet = true;
      HalfRing = false;
      RingGap = true;
      setupStates();
      ss.moonlet.position.y = 0;
      ss.moonlet.position.x = 0;
      ss.moonlet.position.z = 0;
      ss.moonlet.velocity = new PVector();
      ss.moonlet.velocity.y = 1.5 * ss.Omega0 * ss.moonlet.position.x;
      
      
      fixedMoonlet = true;
      setupStates();  
    }
    else {
      LX = round(1000*(1/SliderScale));
      LY = round(2000*(1/SliderScale));
      n_particles = 1000;

      cp5.getController("OrbitRadius")
        .setValue(134000000);
      cp5.getController("Moon Radius")
        .setValue(150);

      fixedMoonlet = false;

      setupStates();
    }

  }

  public void simDaphnis(){
    
    daphnisMode = !daphnisMode;

    if(daphnisMode){
      RingGap = true;
      HalfRing = false;
			Moonlet = true;

      fixedMoonlet = true;

      r0 = 136505000;
			cp5.getController("OrbitRadius")
    		.setValue(r0);

      gapSize = 42000;
      LX = gapSize*2;
      LY = LX*16;
			n_particles = 1000;

			moonlet = new Moonlet();
			moonlet.setDaphnis();

      SliderScale = 1000/LX;
      
			LabelA.setText(Integer.toString(n_particles));

      LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));

      ((Slider) cp5.getController("Moon Radius"))
				.setRange((float) moonlet.radius - 1, (float) moonlet.radius + 1)
				.setValue((float) moonlet.radius);

      ((Slider) cp5.getController("Moonlet Density"))
				.setRange((int) moonlet.particle_rho - 1, (int) moonlet.particle_rho + 1)
				.setValue((int) moonlet.particle_rho);

      ((Slider) cp5.getController("RingGapSize"))
				.setRange((int) gapSize - 1, (int) gapSize + 1)
				.setValue((int) gapSize);

    } 
    else {
			RingGap = false;
			HalfRing = false;
			Moonlet = false;

      fixedMoonlet = false;

			LX = 1000;
      LY = 2000;
			gapSize = LX/2;
      n_particles = 1000;
			
      SliderScale = 1000/LX;

			moonlet = new Moonlet();

      cp5.getController("OrbitRadius")
        .setValue(136000000);
      
			LabelA.setText(Integer.toString(n_particles));

      LabelB.setText(Integer.toString(LY) + "/\n" + Integer.toString(LX));

      ((Slider) cp5.getController("Moon Radius"))
				.setRange(0, 300)
				.setValue((int) moonlet.radius);

      ((Slider) cp5.getController("Moonlet Density"))
				.setRange(0, 5000)
				.setValue((int) moonlet.particle_rho);

      ((Slider) cp5.getController("RingGapSize"))
				.setRange(0, (int) LX*0.9)
				.setValue((int) gapSize);//35000;  //Width of the ring gap
		}

		
		setupStates();

  }

  public void resetView(){
  }

  /**Sets up ability to write out shearing box data to a file.
   * @param filename The filename to write to.
   */
   void setupParticleOutput(String filename) {
    particleOutput = createWriter(filename);
    particleOutput.println("time,particleId,x,y,z");
    particleOutput.flush();
  }
  
 /**Write all the particles to the file for this time step.
   */
  void writeParticles() {
    if (particleOutput!=null) {
      for (Particle p : particles) {
        particleOutput.println(totalSystemTime + "," + p.id + "," + p.position.x + "," + p.position.y + "," + p.position.z);
      }
    }
  }

/**Write the moonlet to the file for this time step.
   */
  void writeMoonlet() {
    if (particleOutput!=null) {
      particleOutput.println(totalSystemTime + ",-1," + moonlet.position.x + "," + moonlet.position.y + "," + moonlet.position.z);
    }
  }

/**On stop, flush the buffer and close the file.
   */
   @Override void onStop() {
    if (particleOutput!=null) {
      particleOutput.flush();
      particleOutput.close();
    }
  }

}
