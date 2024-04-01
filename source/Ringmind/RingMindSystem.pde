/* 
 * RingmindSystem class extends System
 * Manages and update the states of both a ring system and a moon system.
 */

class RingmindSystem extends System {
  
  // Member variables for ring and moon systems
  RingSystem rs;
  MoonSystem ms;


   /* 
     * Constructor for RingmindSystem with specific indices for the ring and moon systems.
     * This allows for initializing the system with specific configurations.
     */
  RingmindSystem(int ring_index, int moon_index) {
    rs = new RingSystem(ring_index); // Initialize the ring system with given index
    ms = new MoonSystem(moon_index); // Initialize the moon system with given index
  }
  
   // Default constructor for RingmindSystem
  RingmindSystem() {
  }
  
  
 @Override
    void update() {
        // Update the time step
        if (simToRealTimeRatio / frameRate < maxTimeStep) {
            rs.dt = simToRealTimeRatio / frameRate;
        } else {
            rs.dt = maxTimeStep;
            println("At Maximum Time Step");  // Print a message when at max time step
        }

         /* 
         * Update particles in the ring system.
         * Each particle's acceleration, position, and velocity are updated based on the time step.
         */
         
        for (Particle p : rs.particles) {
            p.set_getAcceleration(this); // Update the particle's acceleration
            p.updatePosition(rs.dt);     // Update the particle's position
            p.updateVelocity(p.getAcceleration(this), rs.dt); // Update the particle's velocity
        }
          
        /* 
         * Update grids within the ring system.
         * Each grid is updated based on the state of the ring system.
         */
   
        for (Grid x : rs.g) {
            x.update(rs);
        }

        // Update the total system time
        totalSystemTime += rs.dt;

   
        ms.update(); // system or process that needs updating
    }
}
