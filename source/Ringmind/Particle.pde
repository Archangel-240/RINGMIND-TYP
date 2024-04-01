//<Particle Tab>// //<>// //<>// //<>// //<>//
//Contains:
//-Classes(Particle, RingParticle, Moon, ResonantParticle, ResonantMoon, Resonance, TiltParticle, ShearingParticle, Moonlet
//-Interfaces(Alignable)
//-Methods(Particle I/O)

/**Class Particle
 * @author Thomas Cann
 * @author Sam Hinson
 */
import java.util.Random; 

abstract class Particle {
  
  PVector position; // Position float x1, x2, x3; 
  PVector lastPos;
  PVector velocity; // Velocity float v1, v2, v3;
  PVector acceleration;  //Update all constructors!
  PVector InitPosition = new PVector();
  public color c;
  int Index = 0;
  int id=0;

  /**
   *  Class Constuctor - General need passing all the values. 
   */
  Particle(float x1_, float x2_, float x3_, float v1_, float v2_, float v3_, float a1_, float a2_, float a3_) {
    //default position
    this.position = new PVector(x1_, x2_, x3_);
    //default velocity
    this.velocity = new PVector(v1_, v2_, v3_);
    this.acceleration = new PVector(a1_, a2_, a3_);
  }

  /**
   *  Class Constuctor - passing in values of position and velocity. 
   */
  Particle(float x1_, float x2_, float x3_, float v1_, float v2_, float v3_) {
    //default position
    this.position = new PVector(x1_, x2_, x3_);
    //default velocity
    this.velocity = new PVector(v1_, v2_, v3_);
    this.acceleration = new PVector();
  }

  /**
   *  Class Constuctor -passing in PVectors of position and velocity. 
   */
  Particle(PVector position_, PVector velocity_) {
    //default position
    this.position = position_.copy();
    //default velocity
    this.velocity = velocity_.copy();
  }

  /**
   *  Class Constuctor - Initialises an Orboid object with a random position in the ring with correct orbital velocity. 
   */
  Particle(float r, float phi) {
    this(r*cos(phi), r*sin(phi), 0, sqrt(System.GMp/(r))*sin(phi), -sqrt(System.GMp/(r))*cos(phi), 0);
  }

  /**
   *  Class Constuctor - Initialises an RingParticle object with a random position in the ring with correct orbital velocity. 
   */
  Particle(float radius) {
    // Initialise ourRingParticle.
    this(radius, random(1)*2.0*PI); //random(1)
  }

  /**
   *  Class Constuctor - Initialises an Particle object with zero position and velocity. 
   */
  Particle() {
    this(0, 0, 0, 0, 0, 0);
  }

  /**Calculates the acceleration on this particle (based on its current position) (Does not override value of acceleration of particle)
   * @param rs
   * @return acceleration on the particle PVector[m.s^-2,m.s^-2,m.s^-2]
   */
  PVector getAcceleration(System s) {
    PVector a_grav = new PVector();

    // acceleration due planet in centre of the ring. 
    a_grav = PVector.mult(position.copy().normalize(), -System.GMp/position.copy().magSq());

    //Acceleration from the Grid Object
    if (s.g != null) {
      for (Grid x : s.g) {
        a_grav.add(x.gridAcceleration(this, s.dt));
      }
    }
    return a_grav;
  }

  /** Calculates the acceleration on this particle (based on its current position) (Overrides value of acceleration stored by particle)
   * @param rs
   */
  void set_getAcceleration(System s) {
    acceleration = getAcceleration(s);
  }

  /** 
   *  Update Position of particle based of Velocity and Acceleration. 
   */
  void updatePosition(float dt) {
    lastPos = position.copy();
    position.add(velocity.copy().mult(dt)).add(acceleration.copy().mult(0.5*sq(dt)));
  }

  /**
   * Updates the velocity of this Particle (Based on Velocity Verlet) using 2 accelerations. 
   * @param a current acceleration of particle
   */
  void updateVelocity(PVector a, float dt) {

    velocity.add(PVector.add(acceleration.copy(), a).mult(0.5 *dt));
  }

  /**
   * Set the id number of this particle.
   * @param a new id number
   */
  void setId(int newId) {
    id = newId;
  }

  abstract Particle clone();
}



//---------------------------------------------------------------------------------------------------------------------------------------------------//

/**Interface Alignable - template for checking if different objects types of objects align. 
 * @author Thomas Cann
 */
public interface Alignable {
  public boolean isAligned(Alignable other); //Alignment Threshold
  //public float timeToAlignment(Alignable other); //What units? [s]
}



//-----------------------------------------Particle I/O--------------------------------------------------------------

/** Method addParticlesFromTable
 * @param s
 * @param filename
 */
void addParticlesFromTable(System s, String filename) {
  Table table; 
  table = loadTable("./files/"+filename);  // Example Filenames  "output.csv" "input.csv"

  if (s instanceof RingSystem) {
    RingSystem rs=(RingSystem)s;
    for (int i = 0; i < table.getRowCount(); i++) {
      RingParticle temp = new RingParticle();
      temp.position.x= table.getFloat(i, 0);
      temp.position.y= table.getFloat(i, 1);
      temp.position.z= table.getFloat(i, 2);
      temp.velocity.x= table.getFloat(i, 3);
      temp.velocity.y= table.getFloat(i, 4);
      temp.velocity.z= table.getFloat(i, 5);
      temp.acceleration.x= table.getFloat(i, 6);
      temp.acceleration.y= table.getFloat(i, 7);
      temp.acceleration.z= table.getFloat(i, 8);
      rs.rings.get(0).addParticle(temp);              //TODO needed for added particles to be rendered. Streamline.98
      rs.particles.add(temp);                         //TODO needed for added particles to be updated.
    }
  } else if (s instanceof RingmindSystem) {
    if (s instanceof ResonantSystem) {
    } else {
      RingmindSystem rs=(RingmindSystem)s;

      addParticlesFromTable(rs.rs, filename);
    }
  } else if (s instanceof ShearSystem) {
    s.particles.clear();
    ShearSystem ss=(ShearSystem)s;

    for (int i = 0; i < table.getRowCount(); i++) {
      ShearParticle temp = new ShearParticle(ss);
      temp.position.x= table.getFloat(i, 0);
      temp.position.y= table.getFloat(i, 1);
      temp.position.z= table.getFloat(i, 2);
      temp.velocity.x= table.getFloat(i, 3);
      temp.velocity.y= table.getFloat(i, 4);
      temp.velocity.z= table.getFloat(i, 5);
      temp.acceleration.x= table.getFloat(i, 6);
      temp.acceleration.y= table.getFloat(i, 7);
      temp.acceleration.z= table.getFloat(i, 8);
      s.particles.add(temp);
    }
  }
}

/** Method importFromFileToGrid
 * @param s 
 * @param filename
 */
void importFromFileToGrid(System s, String filename) {

  Table table; 
  table = loadTable("./files/" + filename); //DEBUG println(table.getRowCount()+" "+ table.getColumnCount());

  //Check that there is a ArrayList of Grid objects and it is not empty.


  //If Statement to depending on System.
  if (s instanceof RingSystem) {

    //If Multiple Grids will always use Index 0. 
    int index =0;
    RingSystem rs = (RingSystem)s;
    if (rs.g != null && !rs.g.isEmpty()) {
      rs.rings.add(new Ring( 1, 3, 0));
      ArrayList<RingParticle> tempParticles = new ArrayList<RingParticle>();
      for (int i = 0; i < table.getRowCount(); i++) {
        for (int j = 0; j < table.getColumnCount(); j++) {
          for (int x=0; x<table.getInt(i, j); x++) {
            tempParticles.add(new RingParticle(rs.g.get(index).r_min+GRID_DELTA_R*i, GRID_DELTA_R, radians(GRID_DELTA_THETA*-j-180), radians(GRID_DELTA_THETA)));
          }
        }
      }
      rs.rings.get(0).particles=tempParticles;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------
