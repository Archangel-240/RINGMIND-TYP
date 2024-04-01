
/**
  NodeSphere class extends Node
*/
class NodeSphere extends Node{
	
  // Public member variable to hold a Node reference

	public Node n;

	float radius ;
  int details;
	color colour;
  
  // Constructor for NodeSphere with basic parameters
	public NodeSphere(Vector intPosition,float radius, color _color) {
    setReference(node);
		this.radius = radius;
		setPosition(intPosition);
		colour = _color;
    details = 4;
	}

// Overloaded constructor for NodeSphere allowing to specify the detail level
  public NodeSphere(Vector intPosition,float radius,int detail, color _color) {
    setReference(node);
    this.radius = radius;
    setPosition(intPosition);
    colour = _color;
    details = detail;
  }
  
  // Override the graphics method to define how the NodeSphere is drawn
	@Override
	public void graphics(PGraphics pg) {
		pg.pushStyle(); // Save the current style settings
		//pg.strokeWeight(1);
		//pg.stroke(color(40, 255, 40));
		pg.noStroke();  // Disable stroke for the sphere
		pg.fill(colour); // Set the fill color for the sphere
    
    
    // Change styling if this node is the one under the mouse cursor
    if (scene.node("mouseMoved") == this) {
      pg.stroke(color(255, 255, 0));
      pg.fill(color(0, 0, 255));
    }
    if (this ==  nodePOV) {
     // pg.noStroke();
      pg.noFill();
    }
    

		pg.sphereDetail(details);
		pg.sphere(radius);
		pg.popStyle();
	}
  
  // Method to change the position of the NodeSphere
	public void changePosition(Vector v){

		setPosition(v); // Set the new position

	}


	// Method to change the color of the NodeSphere
	public void changeColour(color c){
		colour = c; // Set the new color
		
	}

}
