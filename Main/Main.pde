WorkSpace workspace; //WorkSpace object 
Camera camera; //Camera object
Hud hud; //Hud object
Map3D map; //Map3D object
Land land; //Land object
Gpx gpx; //Gpx object
Railways railways; //Railways object
Roads roads; //Roads object
Buildings buildings; //Buildings object

//variables
float epsilon = 10.0E-6; //lower boundary for the colatitude
float delta = PI/36; //delta of 5 degrees in radians for the longitude and colatitude
float offset = 100; //delta of 100 meters for the radius

void setup(){
  fullScreen(P3D); //runs full screen using the P3D renderer
  smooth(8); //8x anti-aliasing
  frameRate(30); //displays 60 frames per second
  background(0x40); //sets the color used for the background
  hint(ENABLE_KEY_REPEAT); //makes the camera move easier
  this.workspace = new WorkSpace(100); //creates the objects gizmo and grid
  this.camera = new Camera(500*sqrt(29),-PI/2,0.38*PI); //creates the object camera
  this.hud = new Hud(); //loads the object hud
  this.map = new Map3D("paris_saclay.data"); //creates height map
  this.land = new Land(this.map,"paris_saclay.jpg"); //creates the objects shadow,wireFrame and satellite
  this.gpx = new Gpx(this.map,"trail.geojson");
  this.railways = new Railways(this.map,"railways.geojson");
  this.roads = new Roads(this.map,"roads.geojson");
  this.buildings = new Buildings(this.map);
  this.buildings.add("buildings_city.geojson",0xFFaaaaaa);
  this.buildings.add("buildings_IPP.geojson",0xFFCB9837);
  this.buildings.add("buildings_EDF_Danone.geojson",0xFF3030FF);
  this.buildings.add("buildings_CEA_algorithmes.geojson",0xFF30FF30);
  this.buildings.add("buildings_Thales.geojson",0xFFFF3030);
  this.buildings.add("buildings_Paris_Saclay.geojson",0xFFee00dd);
}

void draw(){
  //sets the position of the camera through setting the eye position, the center of the scene, and which axis is facing upward
  //camera(eyeX,eyeY,eyeZ,centerX,centerY,centerZ,upX,upY,upZ)
  camera(0, 2500, 1000, 0, 0, 0, 0, 0, -1);
  background(0x40); //sets the color used for the background
  this.camera.update(); 
  this.workspace.update(); //draws the object
  this.hud.update();
  this.land.update();
  this.gpx.update();
  this.railways.update();
  this.roads.update();
  this.buildings.update();
} 

void keyPressed() { //called once every time a key is pressed
  //works like and if else structure 
  switch (key){ //key contains the most recent key that was used on the keyboard
    case 'w': //denotes the different labels to be evaluated in the switch structure
    case 'W':
      this.workspace.toggle(); //hides-shows the gizmo and the grid
      break; //ends the execution and jumps to the next statement
    case 'l': //denotes the different labels to be evaluated in the switch structure
    case 'L':
      this.camera.toggle(); //hides-shows the gizmo and the grid
      break; //ends the execution and jumps to the next statement
    case 'a': //denotes the different labels to be evaluated in the switch structure
    case 'A':
      this.land.toggle(); //hides-shows the gizmo and the grid
      break; //ends the execution and jumps to the next statement   
    case 'r':
    case 'R':
      this.railways.toggle();
      this.roads.toggle();
      break;
    case 'x':
    case 'X':
      this.gpx.toggle();
      break;
    case 'b':
    case 'B':
      this.buildings.toggle();
      break;
  }
  
  if (key == CODED) { //checks if the key is coded
    //keyCode detects special keys such as the arrow keys 
    switch (keyCode) { //works like and if else structure 
    case UP: //if the user uses the UP key on his keyboard he decreases the colatitude
      this.camera.adjustColatitude(-delta);
      break;
    case DOWN: //if the user uses the DOWN key on his keyboard he increases the colatitude
      this.camera.adjustColatitude(delta);
      break;
    case LEFT: //if the user uses the LEFT key on his keyboard he moves the camera to the left
      this.camera.adjustLongitude(-delta);
      break;
    case RIGHT: //if the user uses the RIGHT key on his keyboard he moves the camera to the right
      this.camera.adjustLongitude(delta);
      break;
    }
  } else {
     switch (key) {
     case '+': //if the user uses the + key on his keyboard he decreases the radius
       this.camera.adjustRadius(-offset);
       break;
     case '-': //if the user uses the - key on his keyboard he increases the radius
       this.camera.adjustRadius(+offset);
       break;
     }
  }
}

void mouseWheel(MouseEvent event) { //called once every time the mouse wheel is moved
 float ec = event.getCount(); //returns positive values when the mouse wheel is rotated down (toward the user)
 this.camera.adjustRadius(offset*ec); //if ec is positive the radius increases else decreases
}

void mouseDragged() { //called once every time the mouse moves while a mouse button is pressed
 if (mouseButton == CENTER) { //when a mouse button is pressed the value of mouseButton is set to LEFT, RIGHT or CENTER
 // Camera Horizontal
 //mouseX contains the current horizontal coordinate of the mouse
 //pmouseX contains the horizontal position of the mouse in the frame previous to the current frame
 float dx = mouseX - pmouseX;
 this.camera.adjustLongitude(dx*delta/100);
 // Camera Vertical
 //mouseY contains the current vertical coordinate of the mouse
 //pmouseY contains the horizontal vertical of the mouse in the frame previous to the current frame
 float dy = mouseY - pmouseY;
 this.camera.adjustColatitude(dy*delta/100);
 }
}

void mousePressed(){
  if(mouseButton == LEFT){
    this.gpx.clic(mouseX,mouseY);
  }
}
