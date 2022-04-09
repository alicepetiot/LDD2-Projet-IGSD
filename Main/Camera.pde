public class Camera { //java class
  //variables
  //r = distance from the center of the cartesian system
  //l = angle formed by the vectors x and the point P
  //c =angle formed by the vectors z and the point P 
  public float radius,longitude,colatitude;   //spherical coordinates
  private float x,y,z; //cartesian coordinates
  private boolean lightning = false;
  
  //constructor
  Camera(float r, float l, float c){
    this.radius = r; //initializes the radius
    this.longitude = l; //initializes the longitude
    this.colatitude = c; //initializes the colatitude
    this.cartesian(); //converts spherical coordinates to cartesian coordinates
  }
  
  //methods
  //converts spherical coordinates to cartesian coordinates
  private void cartesian(){
    this.x = this.radius*sin(colatitude)*cos(longitude);
    this.y = this.radius*sin(colatitude)*sin(longitude);
    this.z = this.radius*cos(colatitude);
  }
  
  //positions the camera on the virtual sphere
  public void update() { 
    camera(this.x, -this.y, this.z,0,0,0,0,0,-1);
    //sunny vertical lightning
    ambientLight(0x7F,0x7F,0x7F);
    if(lightning) { //custom lighting
      directionalLight(0xA0,0xA0,0x60,0,0,-1); //adds a directional light
      lightFalloff(0.0f,0.0f,1.0f); //sets the falloffrate for point lights, spot lights and ambient lights
      lightSpecular(0.0f,0.0f,0.0f); //sets the specular color for lights
    }
  }
  
  //adjust the zoom of the camera in meters
  public void adjustRadius(float offset){
    //the radius is set between widht*0.5 and width*3.0
    if (this.radius+offset >= width*0.5 && this.radius+offset <= width*3.0){
      this.radius += offset; //updates the radius variables of the camera
      this.cartesian(); //updates the cartesian coordinates
    }
  }
  
  //moves the camera to the right or left
  public void adjustLongitude(float delta){
    //the radius is set between -3*(PI/2) and PI/2
    if (this.longitude+delta >= -3*(PI/2) && this.longitude+delta <= PI/2){
      this.longitude += delta; //updates the longitude variables of the camera
      this.cartesian(); //updates the cartesian coordinates
    }
  }
  
  //defines the plunging angle of the camera (in radians)
  public void adjustColatitude(float delta){
    //the colatitude is set between epsilon and PI/2
    if (this.colatitude+delta >= epsilon && this.colatitude+delta <= PI/2){
      this.colatitude += delta; //updates the colatitude variables of the camera
      this.cartesian(); //updates the cartesian coordinates
    }
  }  
  
  //displays or not the lightning of this class
  public void toggle() {
    //isVisible() returns a boolean value "true" if the image is set to be visible
    //setVisible() sets the shape to be visible or invisible in function of isVisible
    //"false" makes the shape invisible and "true" makes it visible
     this.lightning = !this.lightning;
  }
}
