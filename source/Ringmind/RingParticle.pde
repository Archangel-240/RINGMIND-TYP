//---------------------------------------------------------------------------------------------------------------------------------------------------//

/**Class RingParticle
 * @author Thomas Cann
 * @author Sam Hinson
 * @version 1.0
 */
class RingParticle extends Particle {
  
  /**
   *  Class Constuctor - Initialises an RingParticle object with a random position in the ring with correct orbital velocity. 
   */
  RingParticle(float r, float dr, float theta, float dtheta) {
    // Initialise our Orboids.
    super((random(1)*(dr) + r)*System.Rp, theta + random(1)*dtheta);
  }
  /**
   *  Class Constuctor - Initialises an RingParticle object with a random position in the ring with correct orbital velocity. 
   */
  RingParticle(float inner, float outer) {
    // Initialise our Orboids.
    super((random(1)*(outer-inner) + inner)*System.Rp, random(1)*2.0*PI);
  }

  /**
   *  Class Constuctor - Initialises an RingParticle object with a random position in the ring with correct orbital velocity. 
   */
  RingParticle(float radius) {
    // Initialise ourRingParticle.
    super(radius, random(1)*2.0*PI);
  }

  RingParticle() {
    super();
  }

  ///**Calculates the acceleration on this particle (based on its current position) (Does not override value of acceleration of particle)
  // * @param s RingmindSystem
  // * @return PVector [ms^(-2)] 
  // */
  //PVector getAcceleration(RingmindSystem s) {

  //  // acceleration due planet in centre of the ring. 
  //  PVector a_grav = PVector.mult(position.copy().normalize(), -System.GMp/position.copy().magSq());

  //  //Acceleration from the Grid Object
  //  for (Grid x : s.rs.g) {
  //    a_grav.add(x.gridAcceleration(this, s.dt));
  //  }
  //  for (Particle p : s.ms.particles) {
  //    Moon m =(Moon)p;
  //    PVector dist = PVector.sub(m.position, position);
  //    PVector a = PVector.mult(dist, m.GM/pow(dist.mag(), 3));
  //    a_grav.add(a);
  //  }
  //  return a_grav;
  //}

  /**Calculates the acceleration on this particle (based on its current position) (Does not override value of acceleration of particle)
   * @param s System
   * @return PVector [ms^(-2)] 
   */
  @Override PVector getAcceleration(System s) {

    PVector a_grav;
    if (s instanceof RingmindSystem) {
      //println("test");
      RingmindSystem rms = (RingmindSystem)s;
      // acceleration due planet in centre of the ring. 
      a_grav = PVector.mult(position.copy().normalize(), -System.GMp/position.copy().magSq());

      //Acceleration from the Grid Object
      for (Grid x : rms.rs.g) {
        a_grav.add(x.gridAcceleration(this, s.dt));
      }

      for (Particle p : rms.ms.particles) {
        if (p instanceof Moon) {
          Moon m = (Moon)p;
          PVector dist = PVector.sub(m.position, position);
          PVector a = PVector.mult(dist, m.GM/pow(dist.mag(), 3));
          a_grav.add(a);
        }
      }
    } else {
      a_grav =super.getAcceleration(s);
    }

    return a_grav;
  }

  /**
   *  Clone Method - Return New Object with same properties.
   * @return particle object a deep copy of this. 
   */
  @Override Particle clone() {
    Particle p = new RingParticle(); 
    p.position= this.position.copy();
    p.velocity = this.velocity.copy();
    return p;
  }
}
