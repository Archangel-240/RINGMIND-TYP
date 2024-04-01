//---------------------------------------------------------------------------------------------------------------------------------------------------//
/**Class ResonantParticle - Removes Gravity interaction and used information in Resonance class to thin rings.  
 * @author Thomas Cann
 */
public class ResonantParticle extends RingParticle {

  /**
   * TODO
   */
  ResonantParticle(float inner, float outer) {
    super(inner, outer);
  }

  /**
   *  Calculates the acceleration on this particle (based on its current position) (Does not override value of acceleration of particle)
   */
  @Override PVector getAcceleration(System s) {

    ResonantSystem rs = (ResonantSystem)s;
    //// acceleration due to planet in centre of the ring. 
    PVector a_grav = PVector.mult(position.copy().normalize(), -System.GMp/position.copy().magSq());

    for (Particle mr : rs.ms.particles) {
      //for all resonances of the moon 
      ResonantMoon m = (ResonantMoon)mr;

      PVector dist = PVector.sub(m.position, position);
      PVector a = PVector.mult(dist, m.GM/pow(dist.mag(), 3));

      if (m.r != null) {
        for (Resonance R : m.r) {
          float x = position.mag()/60268e3;
          //Check if Particle >Rgap ?&& <Rmax
          //println(x+" "+R.rGap+ " "+ R.rMax);
          if (x>R.rGap && x<R.rMax) {
            //Calcuaculate and Apply if it is !
            //println(R.calcAccleration(x-R.rGap));
            a.mult(R.calcAccleration(x-R.rGap));
          }
        }
      } else {
        println("No Resonances ");
      }
      a_grav.add(a);
    }

    return a_grav;
  }
}




/**Class ResonantMoon - Removes Gravity interaction and used information in Resonance class to thin rings.  
 * @author Thomas Cann
 */
public class ResonantMoon extends Moon {

  ArrayList<Resonance> r;

  /**
   *  Class Constuctor - Create Resonant Moon object with empty arraylist to store Resonances. 
   */
  ResonantMoon(float Gm, float radius, float orb_radius) {
    super(Gm, radius, orb_radius);
    r = new ArrayList<Resonance>();
  }

  /**Method to add a Resonance to arraylsit.
   * @param Q ratio [t_moon/t_particle].
   */
  void addResonance(float Q) {
    r.add(new Resonance(Q, this));
  }
}

/**Class Resonance - Orbital Resonance / Limdblad Resonance information.  
 * @author Thomas Cann
 */
public class Resonance {

  float Q;                         //ratio [t_moon/t_particle]
  float rGap;                      //inner most radius of gap. [Planetary Radi](Hard Edge)
  float rMax;                      //outer most radius of gap. [Planetary Radi](Soft Edge)
  float bellMag = 1e5;             //Strength of Clearing Force [m.s^-2]
  float bellWidth = 0.001913069;   //Width of Clearing Force [Planetary Radi ^2]
  //float Effect;                  //Scale of strength Force based on Gravitational force due to moon at ring gap --> moonmass/(rmoon -rgap)^2 multiplied by a constant

  /**
   *  Class Constuctor - Calculates Resonance properties based of Q and Moon.
   */
  Resonance(float Q, Moon m) {
    this.Q = Q;
    calcRGap(m);
    //calcEffect(m);
    calcRmax();
  }

  /** Method to calculate inner radius at which gap should form.
   *  @param m Moon Object which resonance is based off.  
   */
  void calcRGap(Moon m) {
    rGap = (m.position.mag()*pow(Q, (-2.0/3.0)))/60268e3;
  }

  /** Method to calculate inner radius at which gap should form.
   *  @param x radius from centre planet[Planetary Radi]
   *  @return acceleration[m.s^-2]
   */
  float calcAccleration(float x) {
    return bellMag*exp( -sq(x) /(Q*bellWidth)) + 1; // a proportional to GM pow(Q, ?)
  }

  /**
   *  Method to calculate a radius at which stop applying gap force. Magnitude of force is 1/100 of max.
   *  Bell/Effect curve ==> f(0)= 1 ---> f(RMax)=0.01
   */
  void calcRmax() {
    //
    rMax = rGap + sqrt((-bellWidth*log(0.01/bellMag))/Q);
  }

  //TODO
  //void calcEffect(Moon m) {
  //  //Accleration at gap ( Gravitational force due to moon at ring gap --> moonmass/(rmoon -rgap)^2 multiplied by a constant
  //}
}
