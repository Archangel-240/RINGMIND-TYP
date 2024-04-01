/** Class MoonSystem - represents moons in the ring system
 *
 */
class MoonSystem extends System {


  MoonSystem(int moon_index) {

    particles = new ArrayList<Particle>();
    g = new ArrayList<Grid>();
  
  

    switch(moon_index) {

      case(1):
      //no moons
      break;

      case(2):
      //Adding All 18 of Saturn Moons
      for (int i = 0; i < 18; i++) {
        addMoon(i, particles);
      }
      break;

      case(3):
      // Adding Specific Moons ( e.g. Mima, Enceladus, Tethys, ... )
      addMoon(5, particles); //add the first 5 moons
      //addMoon(7, moons);
      //addMoon(9, moons);
      //addMoon(12, moons);
      //addMoon(14, moons);
      break;

      case(4):
      // Inner smaller moons
      addMoon(19, particles);
      addMoon(20, particles);
      addMoon(21, particles);
      addMoon(22, particles);
      addMoon(23, particles);
      // Larger outer moons
      addMoon(24, particles);
      addMoon(25, particles);
      addMoon(26, particles);
      addMoon(27, particles);
      addMoon(28, particles);
      break;
      
      case(5):
        addMoon(1,particles);
      break;

    default:
      break;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


class AlignableMoonSystem extends MoonSystem {
  AlignableMoonSystem(int moon_index) {
    super(moon_index);
  }
}
