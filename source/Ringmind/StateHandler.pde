/**
* Various states for Ringmind - different values equal different states
*
* State when the programme is initialising everything.
* {@#initState}
*
* Main programme states:
* {@#introState}
* {@#ringmindState}
* {@#ringmindUnstableState}
* {@#formingState}
* {@#shearState}
* {@#tuningState}
* {@#connectedState}
* {@#threadingState}
* {@#saturnState}
* {@#ringboarderState}
* {@#addAlienLettersState}
* {@#resonanceState}
*
* Outro states:
* {#outroState}
*
* Display states:
* {#fadetoblack}
* {#fadeup}
* {#nocamlock}
*/
enum State {
  /**
  * State when the programme is initialising everything.
  */
  initState, 

  /**
  * In an intro sequence state
  */
  introState, 

  /**
  * Running Ringmind
  */
  ringmindState, 

  /**
  * Running Ringmind unstable state
  */
  ringmindUnstableState, 

  /**
  * Running Ringmind ring formation state when particles are not in a plane and collapsing down to a ring
  */
  formingState, 

  /**
  * Running Ringmind shearing box simulation
  */
  shearState, 

  /**
  * Running Ringmind tuning state - the ring sound focusing on a ring.
  */
  tuningState, 

  /**
  * Unknown
  */
  connectedState, 

  /**
  * Unknown
  */
  threadingState, 

  /**
  * Unknown
  */
  saturnState, 

  /**
  * Unknown
  */
  ringboarderState, 

  /**
  * Unknown
  */
  addAlienLettersState, 

  /**
  * Unknown
  */
  resonanceState, 

  /**
  * Outro let's us return back to the beginning.
  */
  outroState, 

  /**
  * Specific display state: fade screen to black.
  */
  fadetoblack, 

  /**
  * Specific display state: fading up
  */
  fadeup, 

  /**
  * Specific display state: Unknown
  */
  nocamlock,
  
  /**
  * development
  */
  development
  
};





State systemState;




/**
* Does setup for each state when we switch to it.  Called to initialise the new state.
*/
void setupStates() {
  switch(systemState) {
    case initState:
      renderSetup();
      //initScene();   //setup proscene camera and eye viewports etc
      createMaterials();       //extra materials we can apply to the rings

      //init with = rings 10,  moons 4, rendering normal =true (titl would be false);
      s = new RingmindSystem(1, 0);  

      break;


  case introState:
    //initCamera();
    G=6.67408E-11;
    s = new RingmindSystem(2, 2); 
    break;

  case ringmindState:
    useAdditiveBlend=true;
    //closerCamera();
    G=6.67408E-11;
    s = new RingmindSystem(10, 4);
    break;

  case ringmindUnstableState:
    //closerCamera();
    useAdditiveBlend=true;
    G=6.67408E-9;
    s = new RingmindSystem(11, 4);
    break;

  case connectedState:
    useAdditiveBlend=true;
    //Connecting=true; 
    //simToRealTimeRatio = 360.0/1.0; //slow it down
    //zoomedCamera();
    s = new RingmindSystem(1, 2);
    break;

  case saturnState:
    G=6.67408E-11;
    s = new RingmindSystem(2, 4);
    break;

  case ringboarderState:
    //zoomedCamera();
    //initCamera();
    s = new RingmindSystem(13, 0);
    break;

  case addAlienLettersState:
    addParticlesFromTable(s, "outputParticles.csv");
    break;

  case formingState:
    useAdditiveBlend=true;
    s = new TiltSystem();
    break;

  case shearState:
    useAdditiveBlend=true;
    //camera4();
    s = new ShearSystem(false);
    s.simToRealTimeRatio = 2000.0/1.0;
    break;
    
   case resonanceState:
    s = new ResonantSystem();
    break;
	
	case development:
	
	s = null;
	break;
	
	
    default:
  }
}


/**
* Update State Method - separate update method for each state. 
* depending on which scenario do different things and render differently etc
*
* @param t 
*/
void updateCurrentState(int t) {

  if (Running) {
    if (s != null) {
      s.update();
    }
  }

                                                                                        
  background(0);


  // Display all of the objects to screen using the renderer.
  if (useAdditiveBlend) {
    blendMode(ADD);
  } else {
    blendMode(NORMAL);
  }

  renderOffScreenOnPGraphicsClean();

  switch(systemState) {
    case connectedState:
      renderer.renderComms(s, renderContext, 1);
      break;

    default:
      renderer.render(s, renderContext, 1);
      break;
  }

  if (useFilters) {
    applyFilters();
  }

  titleText();
}
