//------------------------------------- SHEAR PARTICLE -------------------------------------------------------

class ShearParticle extends Particle {

  //position.x;    //Position of Particle along planet-point line relative to moonlet [m].
  //position.y;    //Position of Particle along along orbit relative to moonlet [m].

  final float SG = 6.67408e-11; //Shear Gravitational Constant
  //ShearParticle Initialisation Properties
  public float particle_rho = 900;  //Density of a ring particle [kg/m^3].
  private float particle_a = 3.0;     //Minimum size of a ring particle [m].
  private float particle_b = 30.0;     //Maximum size of a ring particle [m].
  private float particle_lambda = 0.6;   //Power law index for the size distribution [dimensionless].
  private float particle_D =1.0/( exp(-particle_lambda*particle_a) -exp(-particle_lambda*particle_b));
  private float particle_C =particle_D * exp(-particle_lambda*particle_a);


  //ShearParticle Properties
  float InitRadius;
  float radius;

  // Modifies the minimum radius and range of radii each particle can have
  float m;

  boolean highlight= false;

  /**CONSTUCTOR Particle
   */
  ShearParticle(ShearSystem s) {
    //Initialise default Particle Object.
    position = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    //
    position.y = (random(1)-0.5)*s.Ly;  
    if(HalfRing){
       position.x = -(random(1))*s.Lx/2;
    }else{
      position.x = (random(1)-0.5)*s.Lx;
    }
    
    

    if (RingGap) {
      boolean InGap = true;
      do {
        if(HalfRing){
          position.x = -(random(1))*s.Lx/2;
        }else{
          position.x = (random(1)-0.5)*s.Lx;
        }
        position.y = (random(1)-0.5)*s.Ly;  


        if (position.x > -gapSize/2 && position.x < gapSize/2) {
          InGap = true;
        } else {
          InGap = false;
        }
      } while (InGap == true);
    }
    InitPosition = position.copy();

    if(InitPosition.x > s.Lx/3) {
      c = color(225,0,255); //Purple
    } 
    else if(InitPosition.x > s.Lx/6 && InitPosition.x <= s.Lx/3) {
      c = color(0,100,255); //Blue 
    }
    else if(InitPosition.x > 0  && InitPosition.x <= s.Lx/6) {
      c = color(0,255,0); //Green
    }
    else if(InitPosition.x >= -s.Lx/6 && InitPosition.x < 0) {
      c = color(255,255,0); //Yellow  
    }
    else if(InitPosition.x >= -s.Lx/3 && InitPosition.x < -s.Lx/6) {
      c = color(255,128,0); //Orange
    }
    else if(InitPosition.x < -s.Lx/3) {
      c = color(255,0,0); //Red
    }
    
    if(Toggle3D){
      position.z = random(30)-15;
    }
    
    velocity.x = 0;
    velocity.y = 1.5 * s.Omega0 * position.x;
    this.InitRadius = (-log((particle_C-random(1.0))/particle_D)/particle_lambda);
    this.radius = InitRadius;
    this.m = (4*PI/3)*pow(radius, 3)*particle_rho;
  }

  ShearParticle() {
    //
    position = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    //
    this.InitRadius = (-log((particle_C-random(1.0))/particle_D)/particle_lambda);
    this.radius = InitRadius;
    this.m = (4*PI/3)*pow(radius, 3)*particle_rho;
  }

  ShearParticle(ShearParticle sp) {

    position = sp.position;
    velocity = new PVector();
    acceleration = new PVector();
    InitPosition = sp.InitPosition;
    //
    this.InitRadius = sp.InitRadius;
    this.radius = sp.InitRadius;
    this.m = sp.m;

  }

  /**Calculates the acceleration on this particle (based on its current position) (Does not override value of acceleration of particle)
   * @param sb Shearing Box
   * @return accleration of this particles due to ShearingBox
   */
  @Override PVector getAcceleration(System s) {
    ShearSystem ss = (ShearSystem)s;
    // acceleration due planet in centre of the ring. 
    PVector a_grav = new PVector();
    //Shear forces on particles
    if (ss.A) {
      a_grav.x += -(2.0*ss.Omega0*ss.S0*position.x);
      a_grav.x += -(2.0*ss.Omega0*velocity.y);
      a_grav.y += (2.0*ss.Omega0*velocity.x);
    }
    //Gravitational attraction of the moonlet
    if (Moonlet) {
      PVector distanceVect = PVector.sub(position.copy(), ss.moonlet.position.copy());
      float distanceVectMag = distanceVect.mag();
      float moonMass = (4.0*PI/3.0)*pow(ss.moonlet.radius, 3.0)*ss.moonlet.particle_rho;

      //if (distanceVectMag > radius+ss.moonlet.radius) {
      if(distanceVectMag > radius + ss.moonlet.radius){  
        distanceVect = distanceVect.mult((SG*moonMass)/pow(distanceVectMag, 3));
        a_grav.x+= -distanceVect.x ;
        a_grav.y+= -distanceVect.y;
        a_grav.z+= -distanceVect.z;

      }
    }
        //aproximate forces acting ona particle due to other particles
    if (ss.SelfGrav) {
        PVector SGrav = new PVector();
        SGrav = ss.QT.SelfGrav(this);
        a_grav.x += SGrav.x;
        a_grav.y += SGrav.y;      
        a_grav.z += SGrav.z;
    }
    return a_grav;
  }

  /** Reset
   * @param s 
   */
  void Reset(ShearSystem s) {
    acceleration = new PVector();
    
    
    //This section below is for introducing particles acording to their velocites (introduce faster particles more often etc)
    // there is 100% a better way to do this but never had chance to improve it, it does work but it's not the fastest when resetting a high volume of particles
    
    // Splits each half (top/bottom) into k number of orbital heights
    int k=1000;

    boolean InGap = true;
    do {
      Random r = new Random();

      // First, generate a number from 1 to T_k
      int triangularK = k * (k + 1) / 2;

      int x = r.nextInt(triangularK) + 1;

      // Next, figure out which bucket x fits into, bounded by
      // triangular numbers by taking the triangular root    
      // We're dealing strictly with positive integers, so we can
      // safely ignore the - part of the +/- in the triangular root equation
      double triangularRoot = (Math.sqrt(8 * x + 1) - 1) / 2;

      int n = (int) Math.ceil(triangularRoot);  
      // n has a linear distubution from 0 to k , k being the most likely outcome
      // normanlise n --> k = 1
      float XWeight = float(n)/k;  

      if(HalfRing){
        position.x= (-XWeight*s.Lx/2);
        position.y = s.Ly/2;
      }else{
        //50/50 chance of particle spawning in top or bottom half
        int Coinflip = int(random(2));
        if (Coinflip == 0) {
          position.x = XWeight*s.Lx/2;
          position.y = -s.Ly/2;
        }
        if (Coinflip == 1) {
          position.x= (-XWeight*s.Lx/2);
          position.y = s.Ly/2;
        }
      }
        if (RingGap == true) {
          if (position.x > -gapSize/2 && position.x < gapSize/2) {
            InGap = true;
          } else {
            InGap = false;
          }
        } else {
          InGap =false;
        }
        
    } while (InGap == true);
    
    InitPosition = position.copy();

    if(InitPosition.x > s.Lx/3) {
      c = color(225,0,255); //Purple
    } 
    else if(InitPosition.x > s.Lx/6 && InitPosition.x <= s.Lx/3) {
      c = color(0,100,255); //Blue 
    }
    else if(InitPosition.x > 0  && InitPosition.x <= s.Lx/6) {
      c = color(0,255,0); //Green
    }
    else if(InitPosition.x >= -s.Lx/6 && InitPosition.x < 0) {
      c = color(255,255,0); //Yellow  
    }
    else if(InitPosition.x >= -s.Lx/3 && InitPosition.x < -s.Lx/6) {
      c = color(255,128,0); //Orange
    }
    else if(InitPosition.x < -s.Lx/3) {
      c = color(255,0,0); //Red
    }

    velocity.x = 0;
    velocity.y = 1.5 * s.Omega0 * position.x;
    
    if(Toggle3D){
      position.z = random(30)- 15;
      velocity.z = 0;
    }
    //
    this.InitRadius = (-log((particle_C-random(1.0))/particle_D)/particle_lambda);
    this.radius = InitRadius;
    this.m = (4*PI/3)*pow(radius, 3)*particle_rho;
  }

  /**Clone Method - Return New Object with same properties.
   * @return particle object a deep copy of this. 
   */
  Particle clone() {
    ShearParticle p = new ShearParticle(); 
    p.position= this.position.copy();
    p.velocity = this.velocity.copy();
    p.acceleration = this.acceleration.copy();
    return p;
  }

  // Checks if a particle has entered the moonlet radius in this timestep, if so the particle is pushed back outside the moonlet radius and deflected off.
  void MoonletCollisionCheck(ShearSystem ss) {
    float EM = 1;
    PVector distVect = PVector.sub(position.copy(), ss.moonlet.position.copy());
    PVector distVectNorm = (distVect.copy()).normalize();
    PVector Tangent = new PVector();
    float distVectMag = distVect.copy().mag();

    if (distVectMag < (ss.moonlet.radius + radius)) {
      float CorrectionMag = (ss.moonlet.radius+radius) - distVectMag;
      PVector CorrectionVect = (distVectNorm.copy()).mult(CorrectionMag);
      position.add(CorrectionVect);
      Tangent = (distVectNorm.copy()).rotate(PI/2);
      float Theta = PVector.angleBetween(Tangent, velocity);

      c = color(255, 255, 255);
      
      if (Theta > PI/2) {
        Theta = PI - Theta;
        velocity = (velocity.rotate(2*Theta)).mult(EM);     //Inelastic
      } else {
        velocity = (velocity.rotate(-2*Theta)).mult(EM);     //Inelastic
      }
    }
  }
  
  // Exactly the same as above but in 3D
  //There may be a simpler/faster way to do this in 3D but I had to split the caculations into XY, XZ, YZ planes
	void MoonletCollision3D(ShearSystem ss){
		
		float EM = 0.90;
		PVector distVect = PVector.sub(position.copy(), ss.moonlet.position.copy());
		PVector Norm = (distVect.copy()).normalize();
		float distVectMag = distVect.copy().mag();
		float moonRadius = ss.moonlet.radius;
		
		if (distVectMag < (moonRadius + radius+3)) {
			
			float CorrectionMag = (moonRadius+radius+5) - distVectMag;
			PVector CorrectionVect = (Norm.copy()).mult(CorrectionMag);
			position.add(CorrectionVect);
			PVector XYVelocity = new PVector();
			PVector XZVelocity = new PVector();
			PVector YZVelocity = new PVector();
			PVector XYNorm = new PVector();
			PVector XZNorm = new PVector();
			PVector YZNorm = new PVector();
			PVector TangentXY = new PVector();
			PVector TangentXZ = new PVector();      
			PVector TangentYZ = new PVector();      
			XYVelocity.set(velocity.x, velocity.y);
			XZVelocity.set(velocity.x, velocity.z);
			YZVelocity.set(velocity.y, velocity.z);
			XYNorm.set(Norm.x,Norm.y);
			XZNorm.set(Norm.x,Norm.z);
			YZNorm.set(Norm.y,Norm.z);

			TangentXY = (XYNorm.copy()).rotate(PI/2);
			TangentXZ = (XZNorm.copy()).rotate(PI/2);
			TangentYZ = (YZNorm.copy()).rotate(PI/2);


			float ThetaXY = PVector.angleBetween(TangentXY, XYVelocity);
			float ThetaXZ = PVector.angleBetween(TangentXZ, XZVelocity);
			float ThetaYZ = PVector.angleBetween(TangentYZ, YZVelocity);

      c = color(255, 255, 255);

			if (ThetaXY > PI/2) {
				ThetaXY = PI - ThetaXY;
				XYVelocity = (XYVelocity.rotate(2*ThetaXY)).mult(EM);   
			}
			else {
				XYVelocity = (XYVelocity.rotate(-2*ThetaXY)).mult(EM);  
			}

			if (ThetaXZ > PI/2) {
				ThetaXZ = PI - ThetaXZ;
				XZVelocity = (XZVelocity.rotate(2*ThetaXZ)).mult(EM);   
			}
			else {
				XZVelocity = (XZVelocity.rotate(-2*ThetaXZ)).mult(EM);  
			}

			if (ThetaYZ > PI/2) {
				ThetaYZ = PI - ThetaYZ;
				YZVelocity = (YZVelocity.rotate(2*ThetaYZ)).mult(EM);   
			}else {
				YZVelocity = (YZVelocity.rotate(-2*ThetaYZ)).mult(EM);  
			}

			float Vx = (XYVelocity.x + XZVelocity.x)/2;
			float Vy = (XYVelocity.y + YZVelocity.x)/2;
			float Vz = (XZVelocity.y + YZVelocity.y)/2;

			velocity.set(Vx, Vy, Vz);
		}
	}
  
  
   //Collisions detection for 2 particles using a combination of the moonlet method above and Chris Arridge's quadratic equation idea
   //Seems to work pretty well
void CollisionCheckB(ShearParticle B) {
    PVector distVect = PVector.sub(position.copy(), B.position.copy());
    PVector RelVelocity = PVector.sub(velocity.copy(), B.velocity.copy());

    if (distVect.mag() < radius + B.radius) {
    float CorrectionMag = ((radius + B.radius + 2) - distVect.mag())/2.0;
    PVector d = distVect.copy();
    PVector CorrectionVect = d.normalize().mult(CorrectionMag);
    position.add(CorrectionVect);
    B.position.sub(CorrectionVect);
    }else{
    
        float x_0 = distVect.x;
        float y_0 = distVect.y;
        float z_0 = distVect.z;
        float V_x = RelVelocity.x;
        float V_y = RelVelocity.y;
        float V_z = RelVelocity.z;
        float R = radius + B.radius;
    
        float Discriminant = sq(2*((x_0*V_x)+(y_0*V_y)+(z_0*V_z))) - 4*(sq(V_x) + sq(V_y) + sq(V_z))*(sq(x_0) + sq(y_0) + sq(z_0) - sq(R));
        if (Discriminant > 0) {   
          float T1 =   (-2*((x_0*V_x)+(y_0*V_y)+(z_0*V_z)) - sqrt(Discriminant))/(2*(sq(V_x) + sq(V_y) + sq(V_z)));
          float T2 =   (-2*((x_0*V_x)+(y_0*V_y)+(z_0*V_z)) + sqrt(Discriminant))/(2*(sq(V_x) + sq(V_y) + sq(V_z)));
          float Delta_T = 0;
    
          if (T1 < T2) {
            Delta_T = T1;
          }
          if (T2 < T1) {
            Delta_T = T2;
          }
          if (Delta_T < s.dt && Delta_T > 0) {    
            float M = m + B.m;
            //These are often above 1 and cause chaos
            //This needs an upper of 1
            float e1 = pow((velocity.mag()/B.velocity.mag()),-0.234);
            float e2 = pow((B.velocity.mag()/velocity.mag()),-0.234);
            if(e1 > 1){
              e1 = 1;
            }
            if(e2 > 1){
              e2 = 1;
            }
         
         
            float x1 = e1*(velocity.x*(m - B.m) + 2*B.m*B.velocity.x)/M;
            float y1 = e1*(velocity.y*(m - B.m) + 2*B.m*B.velocity.y)/M;
            float z1 = e1*(velocity.z*(m - B.m) + 2*B.m*B.velocity.z)/M;
            float x2 = e2*(B.velocity.x*(B.m - m) + 2*m*velocity.x)/M;
            float y2 = e2*(B.velocity.y*(B.m - m) + 2*m*velocity.y)/M;
            float z2 = e2*(B.velocity.z*(B.m - m) + 2*m*velocity.z)/M;

            velocity.set(x1, y1, z1);
            B.velocity.set(x2, y2, z2);
          }
        }
    }
   
  }
}
