/**Class TiltSystem
 * @author Thomas Cann
 */
class TiltSystem extends System {

  float Max_Inclination=80; //Maximum Magnitude of Inclined Planes round x-axis[degrees]
  float Min_Inclination=1;  //Minimum Magnitude of Inclined Planes round x-axis[degrees]
  float Lambda= 8E-5;       //Exponential decay constant [milliseconds^-1] == 1/LAMBDA -> Mean Life Time[ milliseconds]
  //Example Ranges for Lambda ==> 8E-5 decays in about 30seconds // 3E-5 decays in 90 seconds;
  float Inner = 1.1;        //Inner Radius for Particles[Planetary Radi] 
  float Outer = 4.9;        //Outer Radius for Particles[Planetary Radi] 
 //x float centralCircleRadius = 50;

  /**
   *  Default Constructor
   */
  TiltSystem() {
    
    particles = new ArrayList<Particle>();
    g = new ArrayList<Grid>();
    
    //add(new NodeSphere(new Vector(100 / 2, 100 / 2, 0), 100, color(255, 0, 0)));
    for (int i = 0; i < n_particles; i++) {
      particles.add(new TiltParticle(Inner, Outer, Max_Inclination, Min_Inclination, Lambda));
    }
  }
  

}
