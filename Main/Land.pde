 /**
 * Returns a Land object.
 * Prepares land shadow, wireframe and textured shape
 * @param map Land associated elevation Map3D object 
 * @return Land object
 */
public class Land { //java class Land
  //variables
  private PShape shadow; //the Pshape object shadow which permits to visualize the shadow of the land
  private PShape wireFrame; //the PShape object wireFrame which permits to materialize the 3D mesh of the terrain in wireframe
  private PShape satellite; //the PShape object satellite 
  private Map3D map; //Map3D object 
  private float w = (float)Map3D.width; //width of  the area we are going to represent - 5000 meters
  private float h = (float)Map3D.height; //height of the area we are going to represent - 3000 meters
  private final float tileSize = 25.0f; //size of the grid squares
  private int z_shadow = -20; //coordinates z of the shadow 
  private float nbTileWidth = w/tileSize; //number of tiles in the land on the horizontal
  private float nbTileHeight = h/tileSize; //number of tiles in the land on the vertica
  
  //constructor
  public Land(Map3D map, String fileName) {
    //check the presence of the jpg image of the satellite view of the land
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()) {
     println("ERROR: Land texture file " + fileName + " not found.");
     exitActual();
    }
    //loads the texture file 
    PImage uvmap = loadImage(fileName);
    float uvmapSizeTile = uvmap.width/nbTileWidth;
    
    this.map = map;
    // Shadow shape
    this.shadow = createShape(); //loads the shape shadow
    this.shadow.beginShape(QUADS); //begins recording vertices for the shape of type QUADS
    this.shadow.fill(0x992F2F2F); //sets the color to dark grey
    this.shadow.noStroke(); //disables drawing the stroke (outline) 
    //creates a rectangle of size 5000*3000 located at -20 meters below the grid centered on the origin
    this.shadow.vertex(-w/2,+h/2,z_shadow); //vertice 1 (x   , y   , z )
    this.shadow.vertex(-w/2,-h/2,z_shadow); //vertice 2 (x   , y+1 , z )
    this.shadow.vertex(+w/2,-h/2,z_shadow); //vertice 3 (x+1 , y+1 , z )
    this.shadow.vertex(+w/2,+h/2,z_shadow); //vertice 4 (x+1 , y   , z )
    this.shadow.endShape(); //stops drawing the shape 
     
    // Wireframe shape
    this.wireFrame = createShape(); //loads the shape wireFrame
    this.wireFrame.beginShape(QUADS); //begins recording vertices for the shape of type QUADS
    this.wireFrame.noFill(); //disables filling geometry
    this.wireFrame.stroke(#888888); //sets the color to draw lines and borders around shapes
    this.wireFrame.strokeWeight(0.5f); //sets the width of the stroke 
    // creates the 3D grid of the terrain in wireframe centered on the origin of size w*h in the processing frame
    // each tile represents a square of 25 meters side
    for(float i = -nbTileHeight/2; i < nbTileHeight/2; i++){
      for(float j = -nbTileWidth/2; j < nbTileWidth/2; j++) {
        float x1 = tileSize*j;
        float y1 = tileSize*i;
        float x2 = tileSize*(j+1);
        float y2 = tileSize*(i+1);
        //creates four processing coordinates points which permits the retrieval of the elevation (z) 
        Map3D.ObjectPoint p1 = this.map.new ObjectPoint(x1,y1); 
        Map3D.ObjectPoint p2 = this.map.new ObjectPoint(x1,y2);
        Map3D.ObjectPoint p3 = this.map.new ObjectPoint(x2,y2);
        Map3D.ObjectPoint p4 = this.map.new ObjectPoint(x2,y1);
        this.wireFrame.vertex(p1.x,p1.y,p1.z); //vertice 1 ( x   , y   , z )
        this.wireFrame.vertex(p2.x,p2.y,p2.z); //vertice 2 ( x   , y+1 , z )
        this.wireFrame.vertex(p3.x,p3.y,p3.z); //vertice 3 ( x+1 , y+1 , z )
        this.wireFrame.vertex(p4.x,p4.y,p4.z); //vertice 4 ( x+1 , y   , z )
      }
    }
    this.wireFrame.endShape(); //stops drawing the shape
     
    //Satellite shape (copy of wireframe)
    this.satellite = createShape(); //loads the shape wireFrame
    this.satellite.beginShape(QUADS); //begins recording vertices for the shape of type QUADS
    this.satellite.noFill(); //disables filling geometry
    this.satellite.strokeWeight(0.5f); //sets the width of the stroke 
    this.satellite.texture(uvmap); //sets a texture to be applied to vertex points
    this.satellite.emissive(0xD0); //sets the emissive color of the material used for drawing shapes drawn to the screen
    this.satellite.noStroke(); //disables drawing the outlines of the wireFrame
    for (float i=0; i< nbTileHeight; i++){
       for (float j=0; j< nbTileWidth; j++){
         
          //variables coordinates for the wireframe
          float x1 = tileSize*j;
          float y1 = tileSize*i;
          float x2 = tileSize*(j+1);
          float y2 = tileSize*(i+1); 
          //variables coordinates for the texture map
          float u1 = uvmapSizeTile*j;
          float v1 = uvmapSizeTile*i;
          float u2 = uvmapSizeTile*(j+1);
          float v2 = uvmapSizeTile*(i+1);
          
          //creates four processing coordinates points which permits the retrieval of the elevation (z)
          Map3D.ObjectPoint p1 = this.map.new ObjectPoint(-w/2+x1, -h/2+y1);
          Map3D.ObjectPoint p2 = this.map.new ObjectPoint(-w/2+x1, -h/2+y2);
          Map3D.ObjectPoint p3 = this.map.new ObjectPoint(-w/2+x2, -h/2+y2);
          Map3D.ObjectPoint p4 = this.map.new ObjectPoint(-w/2+x2, -h/2+y1);

          //manages the lighting
          //normizaled coordinates of the object as a PVector
          PVector n1 = p1.toNormal(); 
          PVector n2 = p2.toNormal(); 
          PVector n3 = p3.toNormal(); 
          PVector n4 = p4.toNormal();      
          //specifies a vector perpandicular to a shape's surface which in turn determines how lighting affects it
          this.satellite.normal(n1.x,n1.y,n1.z);
          this.satellite.normal(n2.x,n2.y,n2.z);
          this.satellite.normal(n3.x,n3.y,n3.z);
          this.satellite.normal(n4.x,n4.y,n4.z);
          
          //associates the points of coordinates (u,v) of the texture to the points of coordinates (x,y,z) of the wireframe
          this.satellite.vertex(p1.x, p1.y, p1.z, u1, v1); //vertice 1 ( x1   , y1   , z1 , x2   , y2   )
          this.satellite.vertex(p2.x, p2.y, p2.z, u1, v2); //vertice 2 ( x1   , y1+1 , z1 , x2   , y2+1 )
          this.satellite.vertex(p3.x, p3.y, p3.z, u2, v2); //vertice 3 ( x1+1 , y1+1 , z1 , x2+1 , y2+1 )
          this.satellite.vertex(p4.x, p4.y, p4.z, u2, v1); //vertice 4 ( x1+1 , y1   , z1 , x2+1 , y2   )
       }
    }   
    this.satellite.endShape(); //stops drawing the shape
    
    // Shapes initial visibility
    this.shadow.setVisible(true);
    this.satellite.setVisible(true);
    this.wireFrame.setVisible(false);
     
    //Converts the Lambert83 coordinates into WGS 84 and Processing coordinates
    //North West
    Map3D.MapPoint nw = this.map.new MapPoint(Map3D.xllCorner,Map3D.yllCorner+Map3D.height); //creates the coordinates of the bounding box at north west in the Lambert83 system
    println("North West:",nw," \n=> ", this.map.new GeoPoint(nw),  //converts the coordinates Lambert83 at north west into WGS 84 coordinates
            " \n=> ", this.map.new ObjectPoint(nw)); //converts the coordinates Lambert83 at north west into Processing coordinates
    //North East    
    Map3D.MapPoint ne = this.map.new MapPoint(Map3D.xllCorner+Map3D.width,Map3D.yllCorner+Map3D.height); //creates the coordinates of the bounding box at north east in the Lambert83 system
    println("North East",ne," \n=> ", this.map.new GeoPoint(ne), //converts the coordinates Lambert83 at north east into WGS 84 coordinates
            " \n=> ", this.map.new ObjectPoint(ne)); //converts the coordinates Lambert83 at north east into Processing coordinates
    //South West    
    Map3D.MapPoint sw = this.map.new MapPoint(Map3D.xllCorner,Map3D.yllCorner); //creates the coordinates of the bounding box at south west in the Lambert83 system
    println("South West:",sw," \n=> ", this.map.new GeoPoint(sw), //converts the coordinates Lambert83 at south west into WGS 84 coordinates
            " \n=> ", this.map.new ObjectPoint(sw)); //converts the coordinates Lambert83 at south west into Processing coordinates
    //South East    
    Map3D.MapPoint se = this.map.new MapPoint(Map3D.xllCorner+Map3D.width,Map3D.yllCorner); //creates the coordinates of the bounding box at south east in the Lambert83 system
    println("South East:",se," \n=> ", this.map.new GeoPoint(se), //converts the coordinates Lambert83 at south east into WGS 84 coordinates
            " \n=> ", this.map.new ObjectPoint(se)); //converts the coordinates Lambert83 at south east into Processing coordinates
    //Direct conversion to Processing coordinates
    // North West (direct)
    Map3D.ObjectPoint onw = this.map.new ObjectPoint(-w/2.0f, -h/2.0f); //creates Processing coordinates at north west
    println("South West (direct) :", onw); //prints the coordinates
    // North East (direct)
    Map3D.ObjectPoint one = this.map.new ObjectPoint(+w/2.0f, -h/2.0f); //creates Processing coordinates at north east
    println("North East (direct) :", one); //prints the coordinates
    // South West (direct)
    Map3D.ObjectPoint osw = this.map.new ObjectPoint(-w/2.0f, +h/2.0f); //creates Processing coordinates at south west
    println("South West (direct) :", osw); //prints the coordinates 
    // South East (direct) 
    Map3D.ObjectPoint ose = this.map.new ObjectPoint(+w/2.0f, +h/2.0f); //creates Processing coordinates at south east
    println("South West (direct) :", ose);  //prints the coordinates  
  }
  
  //methods
  //draws shapes to the display window 
  public void update(){
    shape(this.shadow);
    shape(this.satellite);
    shape(this.wireFrame);
  }
  
  //displays or not the shapes of this class
  public void toggle(){
    //isVisible() returns a boolean value "true" if the image is set to be visible
    //setVisible() sets the shape to be visible or invisible in function of isVisible
    //"false" makes the shape invisible and "true" makes it visible
    this.satellite.setVisible(!this.satellite.isVisible());
    this.wireFrame.setVisible(!this.wireFrame.isVisible());
  }
}
