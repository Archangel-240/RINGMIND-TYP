 class RingSystem extends System {

  // What are the minimum and maximum extents in r for initialisation


  ArrayList<Ring> rings;

  RingSystem(int ring_index) {
    particles = new ArrayList<Particle>();
    g = new ArrayList<Grid>();

    rings = new ArrayList<Ring>();
    applyBasicMaterials();

    switch(ring_index) {
    case 1:
      rings.add(new Ring( 1.1, 4.9, n_particles)); //Generic Disc of Particles
      rings.get(0).material = RingMat2;
      break;
    case 2:
      //Saturn Ring Data (Source: Nasa Saturn Factsheet) [in Saturn radii]
      rings.add(new Ring( 1.110, 1.236, n_particles/10)); // D Ring: Inner 1.110 Outer 1.236
      rings.add(new Ring( 1.239, 1.527, n_particles/10)); // C Ring: Inner 1.239 Outer 1.527
      rings.add(new Ring( 1.527, 1.951, n_particles/10)); // B Ring: Inner 1.527 Outer 1.951
      rings.add(new Ring( 2.027, 2.269, n_particles/2));  // A Ring: Inner 2.027 Outer 2.269
      rings.add(new Ring( 2.320, 2.321, n_particles/10)); // F Ring: Inner 2.320 Outer *
      rings.add(new Ring( 2.754, 2.874, n_particles/10)); // G Ring: Inner 2.754 Outer 2.874
      //rings.add(new Ring(2.987, 7.964, 1000)); // E Ring: Inner 2.987 Outer 7.964
      //Gaps/Ringlet Data  // Titan Ringlet 1.292 // Maxwell Gap 1.452 // Encke Gap 2.26 // Keeler Gap 2.265
      applyBasicMaterials();
      break;

    case 3:
      importFromFileToGrid(this, "output.csv");
      break;

    case 4:
      rings.add(new Ring( 1, 3, 0));
      //rings.get(0).particles.add(new RingParticle(2, 0, 0, 0));
      break;

    case 5:
      //2 Discs of Particles
      rings.add(new Ring( 1.1, 2.9, n_particles/2));
      rings.add(new Ring( 4.5, 4.7, n_particles/2));
      break;

    case 6:
      //Square
      importFromFileToGrid(this, "Square.csv");
      break;  

    case 10:
      // main RINGMIND
      g.add(new Grid(1.0, 3.4, 1E-8, 1E4));
      g.add(new Grid(3.4, 5.0, 1E-8, 1E4)); //switch 1E-8 and go to 2E-7
      //g.add(new Grid(3.4, 5.0, 2E7, 1E4)); //switch 1E-8 and go to 2E-7
      rings.add(new Ring( 1.110, 1.236, n_particles/12)); //inner ring
      rings.add(new Ring( 1.611, 2.175, n_particles/4)); //propeller ring
      rings.add(new Ring( 2.185, 2.6, n_particles/4));  //propeller ring
      rings.add(new Ring( 2.794, 2.795, n_particles/6)); //narrow ring
      rings.add(new Ring( 2.920, 2.921, n_particles/6)); //narrow ring
      rings.add(new Ring( 3.5, 3.8, n_particles/3)); //clumping ring

      for (Ring r : rings) {
        r.material = RingMat3;
      }
      rings.get(0).material = RingMat4;
      rings.get(1).material = RingMat2;
      rings.get(2).material = RingMat2;
      rings.get(3).material = RingMat6;
      rings.get(4).material = RingMat6;
      rings.get(5).material = RingMat5;

      break;
      
    case 11:
      //// main RINGMIND
      ////g.add(new Grid(1.9, 2.5, 1E-8, 1E4));

      ////rings.add(new Ring( 1.110, 1.236, n_particles)); //inner ring
      //rings.add(new Ring( 1.90, 2.175, n_particles*2)); //propeller ring%
      //rings.add(new Ring(  2.300, 2.5, n_particles*2)); //propeller ring

      //for (Ring r : rings) {
      //  r.material = RingMat3;
      //}
      //rings.get(0).material = RingMat4;
      //rings.get(1).material = RingMat2;
      //break;
    //"unstable mode code"
    //case 11:
    //  // main RINGMIND
      g.add(new Grid(1.0, 3.4, 1E-8, 1E4));
      g.add(new Grid(3.4, 5.0, 9E-7, 1E4)); //switch 1E-8 and go to 2E-7
      //g.add(new Grid(3.4, 5.0, 2E7, 1E4)); //switch 1E-8 and go to 2E-7
      rings.add(new Ring( 1.110, 1.236, n_particles/12)); //inner ring
      rings.add(new Ring( 1.611, 2.175, n_particles/4)); //propeller ring  
      rings.add(new Ring( 2.185, 2.6, n_particles/4));  //propeller ring
      rings.add(new Ring( 2.794, 2.795, n_particles/6)); //narrow ring
      rings.add(new Ring( 2.920, 2.921, n_particles/6)); //narrow ring
      rings.add(new Ring( 3.5, 3.8, n_particles/3)); //clumping ring   

      for (Ring r : rings) {
        r.material = RingMat3;
      }
      rings.get(0).material = RingMat4;
      rings.get(1).material = RingMat2;
      rings.get(2).material = RingMat2;
      rings.get(3).material = RingMat6;
      rings.get(4).material = RingMat6;
      rings.get(5).material = RingMat5;

      break;

    case 13:
      rings.add(new Ring( 5.0, 5.2, 22500));
      //// rings.get(0).particles.clear();
      ////addParticlesFromTable("outputParticles.csv");
      //// rings.add(new Ring(1,5.0,5.2,1000));

      for (Ring r : rings) {
        r.material = RingMat5;
      }
      break;
    case 14:

    
      break;

    default:
      break;
    }

    for (Ring r : rings) {
      for (Particle p : r.particles) {
        particles.add(p);
      }
    }
    calcDensity();
  }

  /** Calculated relative densities to inner most ring.
   */
  void calcDensity() {
    for (int i =0; i<rings.size(); i++) {
      rings.get(i).density = rings.get(i).density()/rings.get(0).density();
    }
  }
  void applyBasicMaterials() {
    for (Ring r : rings) {
      r.material = RingMat1;
    }
  }
}
