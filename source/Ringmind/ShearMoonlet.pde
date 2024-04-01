//-----------------------------------------MOONLET---------------------------------------------------------------


// Moonlet class extends ShearParticle,
class Moonlet extends ShearParticle {

	//Ring Moonlet Properties
//	float moonlet_r;         //Radius of the moonlet [m].
	double v;
	double m;

	// Declaring properties of the Moonlet
	// float moonlet_r=150; // Radius of the moonlet in meters
	// float d = 1000; //of the moonlet [kg/m^3]

	Moonlet() {
		position = new PVector(); // Position [x, y, z]
		velocity = new PVector(); // Velocity [x, y, z] [m/s]
		acceleration = new PVector(); // Acceleration [x, y, z] [m/s^2]
 		// Set moonlet radius based on a control panel value
		this.radius = cp5.getController("Moon Radius").getValue(); // Radius of moonlet [m]
		this.particle_rho = cp5.getController("Moonlet Density").getValue(); // Density of moonlet [kg/m^3]
		this.v = (4.0*PI/3.0)*pow(this.radius, 3.0); // Volume of moonlet [m^3]
		this.m = this.particle_rho*this.v; // Mass of moonlet [kg]
		
		position.x = 0;          // Change the starting position of the moonlet
		position.y = 0;
		position.z = 0;
	}
	

// Method to set the moonlet's properties to mimic Daphnis, a small moon of Saturn
	void setDaphnis(){
		this.v = 248000000000D;
		this.m = 68000000000000D;
		this.particle_rho = 276;
		this.radius = pow((float) ((3/(4*PI))*this.v), (1.0/3.0));
		println(this.radius);
	}

	void collisionUpdate(ShearParticle x){

		// this.radius = cp5.getController("Moon Radius").getValue(); // Radius of moonlet [m]
		// this.particle_rho = cp5.getController("Moonlet Density").getValue(); // Density of moonlet [kg/m^3]
		// this.v = (4.0*PI/3.0)*pow(this.radius, 3.0); // Volume of moonlet [m^3]
		// this.m = this.particle_rho*this.v; // Mass of moonlet [kg]

		// this.m += x.m;
		// this.v += (4.0*PI/3.0)*pow(x.radius, 3.0);
		// this.particle_rho = (float) (this.m / this.v);
		// this.radius = pow((float) ((3/(4*PI))*this.v), (1.0/3.0));

		// println("radius: "+this.radius);
		// println("mass: "+this.m);
		// println("volume: "+this.v);

	}
	
	// Makes the moonlet bob up and down based on simulation time
	PVector DynamicMoon(ShearSystem s) {
		
		float Hours = s.totalSystemTime/3600.0; // Convert total system time to hours
		position.x = 200*cos(Hours*PI/2);  // Update position.x based on a cosine function of time
		return position;
	}

	
	//Calculates the shear forces on the moonlet when it is moved off of its orbit
	PVector getShear(ShearSystem ss){
		
		PVector Shear = new PVector();
		if (ss.A) { // Check if the ShearSystem's A property is true (meaning shear force is active)
      // Calculate shear forces in the x and y directions
			Shear.x += -(2.0*ss.Omega0*ss.S0*position.x);
			Shear.x += -(2.0*ss.Omega0*velocity.y);
			Shear.y += (2.0*ss.Omega0*velocity.x);
		}
		return Shear;  // Return the calculated shear force
	}


}
