public class Hud { //class Hud
 //variables
 private PMatrix3D hud;
 
 //constructor
 Hud() {
   this.hud = g.getMatrix((PMatrix3D) null); //should be constructed just after P3D size() or fullScreen()
 }
 
 //methods
 private void begin() {
   g.noLights(); //disable all lighting
   g.pushMatrix(); //save the current coordinate system to the stack
   g.hint(PConstants.DISABLE_DEPTH_TEST); //disable the zbuffer allowing you to draw on top of everything at will
   g.resetMatrix(); //replace the current matrix with the identity matrix
   g.applyMatrix(this.hud); //replace the current matrix by the one specifie through the parameters
 }
 
 private void end() {
   g.hint(PConstants.ENABLE_DEPTH_TEST); //enable primitive z-sorting of triangles and lines in P3D
   g.popMatrix(); //pops the current transformation matrix of the matrix stack
 }
 
 private void displayFPS() {
   //bottom left area
   noStroke(); //disables drawing the stroke (outline)
   fill(96); //sets the color to gray to fill the rectangle
   rectMode(CORNER); 
   //rect(x,y,width,heigth,edge_round_up_left,edge_round_up_right,edge_round_down_right,edge_round_down_left)
   rect(10, height-30, 60, 20, 5, 5, 5, 5); 
   //values
   fill(0xF0); //sets fill to white
   textMode(SHAPE); //draws text using the glyph outlines of individual characters rather than as textures
   textSize(14); //sets the curront font size to 14
   textAlign(CENTER, CENTER); //sets the current alignment for drawing text (x=CENTER,y=CENTER)
   text(String.valueOf((int)frameRate) + " fps", 40, height-20); //text(char,x,y)
 }
 
 private void displayCamera(Camera camera){
   //top right area
   noStroke(); //disables drawing the stroke (outline)
   fill(96); //sets the color to gray to fill the rectangle
   rectMode(CORNER);
   //rect(x,y,width,heigth,edge_round_up_left,edge_round_up_right,edge_round_down_right,edge_round_down_left)
   rect(10,10,160,90,5,5,5,5);
   //values
   fill(0xF0); //sets fill to white
   textMode(SHAPE); //draws text using the glyph outlines of individual characters rather than as textures
   textSize(14); //sets the curront font size to 14
   textAlign(CENTER, CENTER); //sets the current alignment for drawing text (x=CENTER,y=CENTER)
   text("Paris Saclay", 85, 30); //text(char,x,y)  
   text("Longitude"+"           "+String.valueOf((int)(180*camera.longitude/PI)+"°"), 90, 55); //text(char,x,y)
   text("Colatitude"+"             "+String.valueOf((int)(180*camera.colatitude/PI)+"°"), 90, 70); //text(char,x,y)
   text("Radius"+"               "+String.valueOf((int)(camera.radius)+"°"), 90, 85); //text(char,x,y)
 }
  
 public void update(){
   this.begin();
   this.displayFPS();
   this.displayCamera(camera);
   this.end();
 }
}
