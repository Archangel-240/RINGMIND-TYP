# RINGMIND.

[Ringmind](http://ringmind.org/) is an arts-humanities-science research project on the self-organising powers of planetary rings.  This repository contains a set of simulations of [planetary rings](https://en.wikipedia.org/wiki/Ring_system) created in [Processing](https://processing.org/).  The project has received funding from Arts Council England and Lancaster University.

The project is led by [Bronislaw Szerszynski](https://www.lancaster.ac.uk/sociology/about-us/people/bronislaw-szerszynski) with co-investigators:
* [Leandro Soriano Marcolino](http://www.lancaster.ac.uk/scc/about-us/people/leandro-soriano-marcolino)
* [Chris Arridge](http://www.lancaster.ac.uk/physics/about-us/people/chris-arridge)
* [Tony Doyle](http://www.tony-doyle.com/)
* [Ashley James Brown](http://ashleyjamesbrown.com/)

Research assistants have contributed to the development of the code:
* [Thomas Cann](https://github.com/t-cann)
* [Isabella Hatch](http://github.com/i-hatch)
* [Sam Hinson](https://github.com/sam-hinson)
* [Chris Lawson](https://github.com/ChrisLaw254)
* [Atiya Mahboob](https://github.com/atiya16384)
* [Aaron Patel](http://github.com/apatel245)

## Installation/Running Ringmind
The code requires the following libraries:
* [video_export_processing](https://github.com/hamoid/video_export_processing) along with [FFmpeg](http://ffmpeg.org/) installed on your system.
* [Controlp5](https://github.com/sojamo/controlp5)
* [Nub](https://github.com/VisualComputing/nub/) - note you must use **0.7.0 or 0.7.90** and these must be installed by downloading the [release](https://github.com/VisualComputing/nub/releases/tag/0.7.90) from GitHub and installing in your `/libraries` folder in your Processing sketchbook folder.


Open ``/source/Ringmind/Ringmind.pde`` in Processing and run.  You may be asked to located your FFmpeg executable.

## Current keybindings (needs updating)

### Number row
* 1: `Camera route 1`
* 2: `Camera route 2`
* 3: `Camera route 3`
* 4: Switch to `intro` state
* 5: Switch to `stable Ringmind`
* %: Switch to `unstable Ringmind`
* 6: Switch to `Connected State`
* 7: Switch to `Saturn State`
* 8: Switch to `Shearing State`
* *: `Add Moonlet`
* 9: Switch to `Cloud System`
* 0: `Select ring border`

### 1st row
* q: Switch to `Camera 1 (fixed distant)`
* w: Switch to `Camera 2 (fixed)`
* e: Switch to `Camera 3 (fixed)`
* r: `Toggle display of camera route` / coordinate grid display (???)
* R: `Shear out` ???
* t: Switch to `Close camera position`
* y: Switch to `Camera 6`
* u: Switch to `Closer camera position`
* i: Switch to `Toptilt camera position`
* o: Switch to `Camera 9`
* p: Switch to `Camera 10`
* [: Switch to `initial camera position`
* ]: Switch to `slow fit to screen camera position`

### 2nd row
* a: `Toggle display of x, y and z axes`
* A: `Toggle additive blend` where particles overlap with lighter colours
* s: Zooms out a distance ??
* S: `Save camera path` ??  Does it work?? How does it work??
* d: Trace 190??
* f: `Toggle blurring effect`
* g: `Fade up` (?? actually appears to toggle grid vertices)
* h: `Fade to black (??? doesn't appear to do anything)
* j: `Toggle tracing` 

### 3rd row
* ': seems to rotate camera to the left 
* z 
* x 
* c: Ring density??
* v: `Save frame` - pauses simulation slightly and saves `JPG` to `./screenshots` folder.
* b 
* n 
* m: Moon alignment?? 

 
