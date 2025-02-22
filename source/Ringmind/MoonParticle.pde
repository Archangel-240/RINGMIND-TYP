
//---------------------------------------------------------------------------------------------------------------------------------------------------//

/**Class Moon
 *
 * @author Thomas Cann
 * @author Sam Hinson
 */

class Moon extends Particle implements Alignable {

  float GM;
  float radius;
  color c ;
  final float moonSizeScale= 2;

  /**
   *  Class Constuctor - General Moon object with random angle. 
   */
  Moon(float Gm, float radius, float orb_radius, color c) {
    super(orb_radius);
    this.GM=Gm;
    this.radius=radius;
    this.c= c;
  }
  /**
   *  Class Constuctor - General Moon object with random angle. 
   */
  Moon(float Gm, float radius, float orb_radius) {
    super(orb_radius);
    this.GM=Gm;
    this.radius=radius;
    c= color(random(255), random(255), random(255));
  }
  /**
   *  Class Constuctor - Default Moon object with properties of Mima (loosely). 
   */
  Moon(PVector p, PVector v) {
    //Mima (Source: Nasa Saturn Factsheet)
    //GM - 2.529477495E9 [m^3 s^-2]
    //Radius - 2E5 [m]
    //Obital Radius - 185.52E6 [m]

    this(2.529477495e13, 400e3, 185.52e6);
    this.position.x = p.x;
    this.position.y = p.y;
    this.position.z = p.z;
    this.velocity.x = v.x;
    this.velocity.y = v.y;
    this.velocity.z = v.z;
  }
  Moon() {
    super();
    this.GM=0;
    this.radius=0;
    c= color(0, 0, 255);
  }

  /**
   *Display Method - Renders this object to screen displaying its position and colour.
   */
  @Deprecated void display() {
    push();
    translate(width/2, height/2);
    ellipseMode(CENTER);
    fill(c);
    stroke(c);
    circle(System.SCALE*position.x, System.SCALE*position.y, 2*moonSizeScale*radius*System.SCALE);
    pop();
  }  

  /**Calculates the acceleration on this particle (based on its current position) (Does not override value of acceleration of particle)
   * @param System Object
   * @return current acceleration of this moon due to rest of System [ms^(-2)] . 
   */
  PVector getAcceleration(RingmindSystem s) {

    // acceleration due planet in centre of the ring. 
    PVector a_grav = PVector.mult(position.copy().normalize(), -System.GMp/position.copy().magSq());

    // acceleration due the moons on this particle.
    for (Particle p : s.ms.particles) {
      if (p instanceof Moon) {
        Moon m = (Moon)p;
        if (m != this) {
          PVector dist = PVector.sub(m.position, position);
          PVector a = PVector.mult(dist, m.GM/pow(dist.mag(), 3));
          a_grav.add(a);
        }
      }
    }

    return a_grav;
  }

  /**Clone Method - Return New Object with same properties.
   * @return particle object a deep copy of this. 
   */
  @Override Particle clone() {
    Moon p = new Moon(); 
    p.position= this.position.copy();
    p.velocity = this.velocity.copy();
    p.GM = this.GM;
    p.radius = this.radius;
    p.c= this.c;
    return p;
  }

  /**Returns a boolean of true when 2 alignable object are within angular threshold
   * @param Object that implements Alignable.
   * @return Returns true when 2 alignable object are within angular threshold.
   */
  boolean isAligned(Alignable other) {
    boolean temp =false;
    Moon otherMoon = (Moon)other;
    float dAngle = this.position.heading() - otherMoon.position.heading();

    float angleThreshold = radians(1);
    if ( abs(dAngle) < angleThreshold) { //abs(dAngle) % PI could be used to have alignments on either side of the planet!
      temp =true;
    } 
    return temp;
  }

  /** Time taken for two Alignale objects to align. 
   * @param Object that implements Alignable.
   * @return time taken for two Alignale objects to align. 
   */
  float timeToAlignment(Alignable other) {
    Moon otherMoon = (Moon)other;
    float dAngle = this.position.heading() - otherMoon.position.heading();
    float dOmega = kepler_omega(this)-kepler_omega(otherMoon);
    return dAngle/(dOmega*s.simToRealTimeRatio);
  }

  /** Method to calculate the Keplerian orbital angular frequency (using Kepler's 3rd law).
   *@param r Radial position (semi-major axis) to calculate the period [m].
   *@return The angular frequency [radians/s].
   */
  float kepler_omega(Moon m) {
    return sqrt(System.GMp/(pow(m.position.mag(), 3.0)));
  }


  /**Method to get the angle in degrees of the moon
   * @param m Moon Object.
   * @return [degrees].
   */
  float moonAngle(Moon m) {
    PVector center = new PVector(0, 0, 0);
    PVector mm = new PVector(m.position.x, m.position.y, 0);
    return degrees(PVector.angleBetween(center, mm));
  }
}
