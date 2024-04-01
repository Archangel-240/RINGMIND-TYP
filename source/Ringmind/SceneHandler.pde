// Global variables for managing point of view (POV)

Node nodePOV; // Node representing the current point of view
Interpolator eyeInterpolator;  // Interpolator for animating the eye (camera) movement

/* 
 * Function to reset the scene's camera (eye) to its default state.
 * It resets the reference, looks at the center of the scene, and fits the view.
 */

void resetEye(){
  
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fit(1);  // Adjust the camera to fit the scene
  
}


/* 
 * Function to reset the view of the scene.
 * This function currently does the same as resetEye().
 */

void resetView(){
  
  scene.eye().resetReference();
  scene.lookAt(scene.center());


  // use quaternions to reset the orientation
  scene.eye().setOrientation(new Quaternion());
  
  scene.fit(1);  // Adjust the camera to fit the scene
  
}


/* 
 * Function to set the scene's camera (eye) to track a specific node (nodePOV).
 */
void nodeTrackPOV() {
  scene.eye().setReference(nodePOV);
  scene.fit(nodePOV, 1);
}


/* 
 * Function to update the nodePOV and adjust the camera accordingly.
 * If the nodePOV changes, the camera's reference is updated to track the new node.
 */
void updateNodePOV(Node node){
  if (node != nodePOV) {
    nodePOV = node;
    if (nodePOV != null)
      nodeTrackPOV();
    else if (scene.eye().reference() != null)
      resetEye();
  }  
  
  
  
  
}

/* 
 * Function to initialize keyframes for camera animation using an interpolator.
 * This sets up the interpolator and loads a path for the camera to follow.
 */
void initKeyFrames(){
	
	eyeInterpolator = new Interpolator(scene.eye());
	//eyeInterpolator.configHint(Interpolator.SPLINE, color(255, 0, 255));
	  eyeInterpolator.configHint(Interpolator.SPLINE, color(255, 255, 0));
loadPath();
	 eyeInterpolator.enableRecurrence();
}

/* 
 * Function to load a camera path from a file and set up keyframes in the interpolator.
 * The path is defined by position and rotation parameters for each keyframe.
 */

void loadPath(){
     String[] lines = loadStrings("cameraPath.path");  // Load the path file

  // Iterate over each line in the file, each representing a keyframe
  for (int i = 0 ; i < lines.length; i++) {
      String p = lines[i];
      Quaternion q ;
      Float[] v = new Float[8];  // Array to store the keyframe parameters
      
      // Extract and parse the parameters from the line
      for(int k = 0; k< 8;k++){
        Float px;
        if(k == 7){
          px = float(p);  // Parse the last parameter
        }else{
          px = float(p.substring(0,p.indexOf(",")));
        }
        p = p.substring(p.indexOf(",")+1);
        v[k] = px; // Store the parsed parameter
     // println(px);
    }
     // Add a keyframe to the interpolator with the parsed parameters

    eyeInterpolator.addKeyFrame(new Node(new Vector(v[0],v[1],v[2]),new Quaternion(new Vector(v[3],v[4],v[5]),v[6]),v[7]),i+1);
     
  
}
}
