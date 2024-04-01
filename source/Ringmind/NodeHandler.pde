enum RenderState{
	
	nativeMode,
		
	nub3D //a 3D rendering mode or a custom rendering approach
	

};

// Variable to keep track of the current rendering mode
RenderState renderMode;

// ArrayLists to store different types of NodeSphere objects
ArrayList<NodeSphere> nodeParticles; // Stores particle nodes
ArrayList<NodeSphere> nodeMoons;     // Stores moon nodes
ArrayList<NodeSphere> nodePlanets;   // Stores planet nodes


// Function to setup node particles based on a specified type
void setupNodeParticles(int type){

	float scale=System.SCALE; 

  // If type is 0, set up particle nodes
  if(type == 0){
    	nodeParticles = new ArrayList();  // Initialize the particle node list
    	ShearSystem ss = (ShearSystem)s;  // Cast 's' to ShearSystem, assumed to be a global variable

    
    // Loop through all particles in the ShearSystem
    	for (int PP = 0; PP < ss.particles.size(); PP++) {
    		ShearParticle sp = (ShearParticle)ss.particles.get(PP);
    	
    		color c = color(0,0,0);
    		
    
        // Assign colors based on the initial X position of the particle	
     		if(sp.InitPosition.x > ss.Lx/3) {
    			c = color(225,0,255); //Purple
    		} 
    		else if(sp.InitPosition.x > ss.Lx/6 && sp.InitPosition.x <= ss.Lx/3) {
    			c = color(0,100,255); //Blue     
    		}
    		else if(sp.InitPosition.x > 0  && sp.InitPosition.x <= ss.Lx/6) {
    			c = color(0,255,0); //Green
    		}
    		else if(sp.InitPosition.x >= -ss.Lx/6 && sp.InitPosition.x < 0) {
    			c = color(255,255,0); //Yellow        
    		}
    		else if(sp.InitPosition.x >= -ss.Lx/3 && sp.InitPosition.x < -ss.Lx/6) {
    			c = color(255,128,0); //Orange
    		}
    		else if(sp.InitPosition.x < -ss.Lx/3) {
    			c = color(255,0,0); //Red
    		}	 
        // Add new NodeSphere objects to nodeParticles list
    		nodeParticles.add(new NodeSphere(new Vector(sp.position.x,sp.position.y,sp.position.z),sp.InitRadius,c));
    		
    }
	}
  else if(type == 1){
   // nodePlanets = new ArrayList();
   //nodePlanets.add(new NodeSphere(new Vector(0,0,0),40,20,color(255,200,0)));
    
    nodeMoons = new ArrayList();  // Initialize the moon node list
    RingmindSystem rms = (RingmindSystem)s;  // Cast 's' to RingmindSystem
    MoonSystem ms = rms.ms;  // Access the MoonSystem from RingmindSystem
    
    // Loop through all particles in MoonSystem
    for (Particle p : ms.particles) {
      
      Moon m = (Moon)p;  // Cast each Particle to Moon
     // nodeMoons.add(new NodeSphere(new Vector(scale*m.position.x,scale*m.position.y,0),m.radius*scale,m.c));

      
      
  }  



}
  
  
  
  
	
}
// Function to remove or clear node particles

void removeNodeParticles(){
  
  //for(Node n : nodeParticles){
  //  //scene.clearTree();
  //  n.detach();
  //nodePlanets = null;
   // Loop through nodePlanets and set each Node to null (clearing the list)
  for(Node n : nodePlanets){
    //scene.clearTree();
    // Remove reference to the Node
    n = null;
  }
 // nodeParticles = null;
}
