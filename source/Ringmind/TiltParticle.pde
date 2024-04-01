
//---------------------------------------------------------------------------------------------------------------------------------------------------//

/** Class TiltParticle
 */
class TiltParticle extends RingParticle {

  float inclination;        //Rotation round x axis [degrees].
  float rotation;           //Rotation round z axis [degrees].
  float minInclination;     //minimum inclination of particle [degrees].
  float lambda;             //exponential decay constant [milliseconds^{-1}].
  float initialiseTime;     //time when particle is initialised [milliseconds].

  /** 
   * Class Constuctor - Initialises an TiltParticle object with a random position in the ring with correct orbital velocity. 
   */
  TiltParticle(float inner, float outer, float max_inclination, float min_inclination, float lambda) {
    super(inner, outer);
    this.inclination= randomGaussian()*max_inclination;
    this.rotation =random(360);
    this.minInclination = randomGaussian()* min_inclination;
    this.lambda= lambda;
    this.initialiseTime = millis();
  }

  /** Method to exponential decrease inclination with after since initialisation.
   *  @return  curretn angle to incline plane[degrees]
   */
  float inclination() {
    return inclination* exp(-lambda*(millis()-initialiseTime)) +minInclination ;
  }

  /**Method rotates a Tilt Particle Simulated Position. Around x-axis by inclination() the around z-axis by rotation.   
   *@param p TiltParticle object
   *@return RotatedPosition PVector[m,m,m]
   */
  PVector displayRotate(TiltParticle p) {
    PVector temp = p.position.copy();
    float angle = radians(p.inclination());
    float cosi = cos(angle);
    float sini = sin(angle);
    temp.y = cosi * p.position.y - sini * p.position.z;
    temp.z = cosi * p.position.z + sini * p.position.y;
    PVector temp1 = temp.copy();
    float cosa = cos(radians(p.rotation));
    float sina = sin(radians(p.rotation));
    temp.x = cosa * temp1.x - sina * temp1.y;
    temp.y = cosa * temp1.y + sina * temp1.x;
    return temp;
  }
  /**Method rotates this Tilt Particle Simulated Position. Around x-axis by inclination() the around z-axis by rotation. 
   *@return RotatedPosition PVector[m,m,m]
   */
  PVector displayRotate() {
    return displayRotate(this);
  }
}