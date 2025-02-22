System s; //<>// //<>// //<>// //<>// //<>// //<>//
float G = 6.67408E-11;       // Gravitational Constant 6.67408E-11[m^3 kg^-1 s^-2]

public LinkedList<TraceParticle> traceParticles;

/**Class System
 */

int n_particles = 1000;

public abstract class System {

  //Timestep variables 
  float dt;                                      //Simulation Time step [s]
  float simToRealTimeRatio = 3600.0/1.0;         // 3600.0/1.0 --> 1hour/second
  float maxTimeStep = 20* simToRealTimeRatio / 30;
  float totalSystemTime =0.0;                    // Tracks length of time simulation has be running

  //int n_particles = 1000;                       //Used for system initialiations 
  ArrayList<Particle> particles;             //Used for particle tracing functionality
  ArrayList<Grid> g;  
  
	
  static final float GMp = 3.7931187e16;
  static final float Rp = 60268e3;                // Length scale (1 Saturn radius) [m]
  static final float SCALE = 100/Rp;              // Converts from [m] to [pixel] with planetary radius (in pixels) equal to the numerator. Size of a pixel represents approximately 600km.

  Material material = RingMat1;

  /**  Updates System for one time step of simulation taking into account the System.
   */
  void update() {

    update(this);

  }


  ///**  Updates System for one time step of simulation taking into account the System.
  // */

  void update(System s) {
    // Update the time step based on frameRate
    if (simToRealTimeRatio / frameRate < maxTimeStep) {
        s.dt = simToRealTimeRatio / frameRate;
    } else {
        s.dt = maxTimeStep;
        println("At Maximum Time Step");
    }

    // Update particles in a single loop
    for (Particle p : particles) {
        p.set_getAcceleration(s); // Set and get acceleration
        p.updatePosition(s.dt); // Update position
        p.updateVelocity(p.getAcceleration(s), s.dt); // Update velocity
    }

    // Update grid or shear system
    if (!(s instanceof ShearSystem)) {
        for (Grid x : g) {
            x.update(this);
        }
    } else {
        ShearSystem ss = (ShearSystem) s;
        ss.SG.Update(ss);
    }

    // Update the total system time
    s.totalSystemTime += s.dt;

  }

  void onStop() {}

}

//---------------------------------------------------------------------------------------------

/** Method addMoon - method to add specific moon to Arraylist of Particles.
 * @param i index of switch statement
 * @param m ArrayList if Particles
 */
void addMoon(int i, ArrayList<Particle> m) {

  //Source: Nasa Saturn Factsheet

  switch(i) {
  case 0:
    // Pan Mass 5e15 [kg] Radius 1.7e4 [m] Orbital Radius 133.583e6 [m]
    m.add(new Moon(G*5e15, 1.7e4, 133.5832e6));
    break;
  case 1:
    // Daphnis Mass 1e14 [kg] Radius 4.3e3 [m] Orbital Radius 136.5e6 [m]
    
    //mass = 7.7931e12
    //77,930,758,521,054
    //average orbital distance =136500000m
    //mean radiius  = 3800m
    //
    //m.add(new Moon(G*1e14, 4.3e3, 136.5e6));
    m.add(new Moon(G*7.7931e17, 3.8e5, 136.5e6));
    break;
  case 2:
    // Atlas Mass 7e15 [kg] Radius 2e4 [m] Orbital Radius 137.67e6 [m]
    m.add(new Moon(G*7e15, 2.4e4, 137.67e6));
    break;
  case 3:
    // Promethieus Mass 1.6e17 [kg] Radius 6.8e4 [m] Orbital Radius 139.353e6 [m]
    m.add(new Moon(G*1.6e17, 6.8e4, 139.353e6));
    break;
  case 4:
    // Pandora Mass 1.4e17 [kg] Radius 5.2e4 [m] Orbital Radius 141.7e6 [m]
    m.add(new Moon(G*1.4e17, 5.2e4, 141.7e6));
    break;
  case 5:
    // Epimetheus Mass 5.3e17 [kg] Radius 6.5e4 [m] Orbital Radius 151.422e6 [m]
    m.add(new Moon(G*5.3e17, 6.5e4, 151.422e6, color(0, 255, 0)));
    break;
  case 6:
    // Janus Mass 1.9e18 [kg] Radius 1.02e5 [m] Orbital Radius 151.472e6 [m]
    m.add(new Moon(G*1.9e18, 1.02e5, 151.472e6));
    break;
  case 7: 
    // Mimas Mass 3.7e19 [kg] Radius 2.08e5 [m] Obital Radius 185.52e6 [m]
    m.add(new Moon(G*3.7e19, 2.08e5, 185.52e6));
    break;
  case 8:
    // Enceladus Mass 1.08e20 [kg] Radius 2.57e5 [m] Obital Radius 238.02e6 [m]
    m.add(new Moon(G*1.08e20, 2.57e5, 238.02e6));
    break;
  case 9:
    // Tethys Mass 6.18e20 [kg] Radius 5.38e5 [m] Orbital Radius 294.66e6 [m]
    m.add(new Moon(G*6.18e20, 5.38e5, 294.66e6));
    break;
  case 10:
    // Calypso Mass 4e15 [kg] Radius 1.5e4 [m] Orbital Radius 294.66e6 [m]
    m.add(new Moon(G*4e15, 1.5e4, 294.66e6));
    break;
  case 11:
    // Telesto Mass 7e15 [kg] Radius 1.6e4 [m] Orbital Radius 294.66e6 [m]
    m.add(new Moon(G*7e15, 1.6e4, 294.66e6));
    break;
  case 12:
    // Dione Mass 1.1e21 [kg] Radius 5.63e5 [m] Orbital Radius 377.4e6 [m]
    m.add(new Moon(G*1.1e21, 5.63e5, 377.4e6));
    break;
  case 13:
    // Helele Mass 3e16 [kg] Radius 2.2e4 [m] Orbital Radius 377.4e6[m]
    m.add(new Moon(G*3e16, 2.2e4, 377.4e6));
    break;
  case 14:
    // Rhea Mass 2.31e21 [kg] Radius 7.65e5 [m] Orbital Radius 527.04e6 [m]
    m.add(new Moon(G*2.31e21, 7.65e5, 527.4e6));
    break;
  case 15:
    // Titan Mass 1.3455e23 [kg] Radius 2.575e6 [m] Orbital Radius 1221.83e6 [m]
    m.add(new Moon(G*1.34455e23, 2.57e6, 1221.83e6));
    break;
  case 16:
    // Hyperion Mass 5.6e18 [kg] Radius 1.8e5 [m] Orbital Radius 1481.1e6 [m]
    m.add(new Moon(G*5.6e18, 1.8e5, 1481.1e6));
    break;
  case 17:
    // Iapetus Mass 1.81e21 [kg] Radius 7.46e5 [m] Orbital Radius 3561.3e6 [m]
    m.add(new Moon(G*1.81e21, 7.46e5, 3561.3e6));
    break;
  case 18:
    // Pheobe Mass 8.3e18 [kg] Radius 1.09e5 [m] Orbital Radius 12944e6 [m] 
    m.add(new Moon(G*8.3e18, 1.09e5, 12994e6));
    break;
    // Inner smaller moons
  case 19:
    m.add(new Moon(G*3.7e18, 1.77e6, 1.373657091*System.Rp));    
    break;
  case 20:
    m.add(new Moon(G*1.5e20, 2.66e6, 2.180544711*System.Rp));
    break;
  case 21:
    m.add(new Moon(G*9.0e18, 9.90e5, 2.857321894*System.Rp));
    break;
  case 22:
    m.add(new Moon(G*3.7e19, 1.32e6, 3.226611418*System.Rp));
    break;
  case 23:
    m.add(new Moon(G*3.7e19, 4.08e6, 4.0165977*System.Rp));
    break;
    // Larger outer moons
  case 24:
    m.add(new Moon(G*2.31e21, 1.65e7, 8.75091259*System.Rp));
    break;
  case 25:
    m.add(new Moon( G*4.9e20, 6.85e7, 16.49*System.Rp));  
    break;
  case 26:
    m.add(new Moon( G*1.34455e23, 8.57e7, 20.27327*System.Rp));  
    break;
  case 27:
    m.add(new Moon( G*3.7e22, 2.08e8, 34.23*System.Rp));
    break;
  case 28:
    m.add(new Moon( G*1.81e21, 7.46e7, 49.09*System.Rp));
    break;
  }

}




//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
