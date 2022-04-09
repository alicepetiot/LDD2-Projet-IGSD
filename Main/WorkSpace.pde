public class WorkSpace { //java class
  //variables
  private PShape gizmo; //the PShape object gizmo
  private int size_gizmo = height/2; // size of the gizmo
  private PShape grid; //the PShape object grid
  private int size_slab = 250; // size of the square in the grid
    
  //constructor
  WorkSpace(int size){ 
    // Gizmo
    this.gizmo = createShape(); //loads the shape gizmo
    this.gizmo.beginShape(LINES); //begins recording vertices for the shape of type LINES
    this.gizmo.noFill(); //disables filling inside the shape
    this.gizmo.strokeWeight(3.0f); //sets the width of the stroke used for lines
    //Red X
    this.gizmo.stroke(0xAAFF3F7F); //sets the color to red 
    this.gizmo.vertex(0,0,0); //draws a line between the two vertices
    this.gizmo.vertex(size_gizmo,0,0);
    //Green Y
    this.gizmo.stroke(0xAA3FFF7F); //sets the color to green
    this.gizmo.vertex(0,0,0); //draws a line between the two vertices
    this.gizmo.vertex(0,size_gizmo,0);
    //Blue Z
    this.gizmo.stroke(0xAA3F7FFF); //sets the color to blue
    this.gizmo.vertex(0,0,0); //draws a line between the two vertices
    this.gizmo.vertex(0,0,size_gizmo);
    this.gizmo.strokeWeight(0.8f); //sets the width of the stroke used for lines
    //Green thin Y
    this.gizmo.stroke(0xAA3FFF7F); //sets the color to green
    this.gizmo.vertex(0,-size_slab*(size/2),0);
    this.gizmo.vertex(0,size_slab*(size/2),0);
    //Red thin X
    this.gizmo.stroke(0xAAFF3F7F); //sets the color to red 
    this.gizmo.vertex(-size_slab*(size/2),0,0); //draws a line between the two vertices
    this.gizmo.vertex(size_slab*(size/2),0,0);
    this.gizmo.endShape(); //stops drawing the shape    
    // Grid
    this.grid = createShape(); //loads the shape grid
    this.grid.beginShape(QUADS); //begins recording vertices for the shape of type QUADS
    this.grid.noFill(); //disables filling inside the shape
    this.grid.stroke(0x77836C3D); //sets the color to orange
    this.grid.strokeWeight(0.5f); //sets the width of the stroke used for lines
    // creates a square grid of size*size units centered on the origin (0,0,0) where
    // each slab represents a square of 250 meters side
    for(int i = -size/2; i<=size/2;i++){
      for(int j = -size/2;j <=size/2;j++) {
        int x1 = size_slab*j;
        int y1 = size_slab*i;
        int x2 = size_slab*(j+1);
        int y2 = size_slab*(i+1);
        this.grid.vertex(x1,y1,0); //vertice 1 (x,y,z)
        this.grid.vertex(x1,y2,0); //vertice 2 (x,y+1,z)
        this.grid.vertex(x2,y2,0); //vertice 3 (x+1,y+1,z)
        this.grid.vertex(x2,y1,0); //vertice 4 (x+1,y,z)
      }
    }
    // Shapes initial visibility 
    this.grid.endShape(); //stops drawing the shape  
    this.gizmo.setVisible(true);
    this.grid.setVisible(true);
  }
  
  //methods
  public void update(){  
    shape(this.gizmo); // draws shapes to the display window 
    shape(this.grid);
  }
 
  
  public void toggle() { //displays or not the shapes of this class
    //isVisible() returns a boolean value "true" if the image is set to be visible
    //setVisible() sets the shape to be visible or invisible in function of isVisible
    //"false" makes the shape invisible and "true" makes it visible
    this.gizmo.setVisible(!this.gizmo.isVisible());
    this.grid.setVisible(!this.grid.isVisible());
  }
}
