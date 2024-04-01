
/**Class ResonantSystem
 * @author Thomas Cann
 */
class ResonantSystem extends RingmindSystem {

  /**
   *  Default Constructor
   */
  ResonantSystem() {
    super(0, 0);
    for (int i = 0; i < n_particles; i++) {
      rs.particles.add(new ResonantParticle(R_MIN, R_MAX));
    }

    addResonanceMoon(1, ms.particles);
  }

  /**
   * Method to add specific ResonanceMoon object to an Arraylist.
   */
  void addResonanceMoon(int i, ArrayList<Particle> m) {
    //Source: Nasa Saturn Factsheet

    switch(i) {
    case 1: 
      // Mimas Mass 3.7e19 [kg] Radius 2.08e5 [m] Obital Radius 185.52e6 [m]
      ResonantMoon moon =new ResonantMoon(G*3.7e19, 2.08e5, 185.52e6);
      moon.addResonance(2.0);
      m.add(moon);
      break;
    }
  }
}