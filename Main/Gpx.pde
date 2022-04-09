public class Gpx{
 PShape track, posts, thumbtacks;
 PVector hit;
 PVector hitBis;
 Map3D map;
 int desc = -1;

 
 Gpx(Map3D map,String fileName){
    this.map = map;
    
    this.track = createShape(); 
    this.track.beginShape(LINE_STRIP); 
    this.track.noFill(); 
    this.track.stroke(#FC7FE8); 
    this.track.strokeWeight(3); 
 
    this.posts = createShape();
    this.posts.beginShape(LINES);
    this.posts.noFill(); 
    this.posts.stroke(#888888); 
    this.posts.strokeWeight(2);
       
    this.thumbtacks = createShape();
    this.thumbtacks.beginShape(POINTS);
    this.thumbtacks.noFill(); 
    this.thumbtacks.stroke(0xFFFF3F3F); 
    this.thumbtacks.strokeWeight(8);
  
   // Check ressources
   File ressource = dataFile(fileName);
   if (!ressource.exists() || ressource.isDirectory()) {
     println("ERROR: GeoJSON file " + fileName + " not found.");
     return; 
   }
  
   // Load geojson and check features collection 
   JSONObject geojson = loadJSONObject(fileName); 
   if (!geojson.hasKey("type")) {
     println("WARNING: Invalid GeoJSON file.");
     return;
   } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
     println("WARNING: GeoJSON file doesn't contain features collection.");
     return; 
   }
  
   // Parse features
   JSONArray features = geojson.getJSONArray("features"); 
   if (features == null) {
     println("WARNING: GeoJSON file doesn't contain any feature.");
     return; 
   }
   for (int f=0; f<features.size(); f++) {
     JSONObject feature = features.getJSONObject(f); 
     if (!feature.hasKey("geometry"))
       break;
     JSONObject geometry = feature.getJSONObject("geometry"); 
     switch (geometry.getString("type", "undefined")) {
  
    case "LineString":

      // GPX Track
      JSONArray coordinates = geometry.getJSONArray("coordinates"); 
      if (coordinates != null)
        for (int p=0; p < coordinates.size(); p++) {
          JSONArray point = coordinates.getJSONArray(p); 
          //println("Track ", p, point.getDouble(0), point.getDouble(1));
          Map3D.GeoPoint Mp1 = this.map.new GeoPoint(point.getDouble(0), point.getDouble(1));
          Mp1.elevation += 1.5d;
          Map3D.ObjectPoint Obj1 = this.map.new ObjectPoint(Mp1);
          this.track.vertex(Obj1.x, Obj1.y, Obj1.z);
         
        } 
      break;
  
    case "Point":

      // GPX WayPoint
      if (geometry.hasKey("coordinates")) {
        JSONArray point = geometry.getJSONArray("coordinates"); 
        String description = "Pas d'information.";
        if (feature.hasKey("properties")) {
          description = feature.getJSONObject("properties").getString("desc", description);
        }
        //println("WayPoint", point.getDouble(0), point.getDouble(1), description); 
        Map3D.MapPoint Mp = this.map.new MapPoint(this.map.new GeoPoint(point.getDouble(0), point.getDouble(1)));
        Map3D.ObjectPoint Obj = this.map.new ObjectPoint(Mp);
        this.posts.vertex(Obj.x, Obj.y, Obj.z);
        this.posts.vertex(Obj.x, Obj.y, Obj.z+70);
        this.thumbtacks.vertex(Obj.x, Obj.y, Obj.z+70);
      }
      break;
    
    default:
      println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
      break;
     } 
   }
        
    this.track.endShape();
    this.posts.endShape();
    this.thumbtacks.endShape();
 }
 
 public void update(){
   shape(this.track);
   shape(this.posts);
   shape(this.thumbtacks);
   if (this.desc >=0 && this.desc < this.thumbtacks.getVertexCount()) {
    pushMatrix();
    lights();
    fill(0xFFFFFFFF);
    translate(this.hitBis.x,this.hitBis.y,this.hitBis.z + 10.0f);
    rotateZ(-camera.longitude- HALF_PI);
    rotateX(-camera.colatitude);
    g.hint(PConstants.DISABLE_DEPTH_TEST);
    textMode(SHAPE);
    textSize(48); 
    String description = loadJSONObject("trail.geojson").getJSONArray("features").getJSONObject(desc+1).getJSONObject("properties").getString("desc"); 
    textAlign(LEFT, CENTER);
    text(description, 0, 0);
    g.hint(PConstants.ENABLE_DEPTH_TEST);
    popMatrix();
   }   
 }
 
 public void clic(float mouseX,float mouseY) {
   for (int v = 0; v< this.thumbtacks.getVertexCount();v++){
     this.hit = new PVector();
     this.hit = this.thumbtacks.getVertex(v,hit);
     float distThumbtacks = dist(mouseX,mouseY,screenX(hit.x,hit.y,hit.z),screenY(hit.x,hit.y,hit.z));
     if (distThumbtacks < 10) {
       this.thumbtacks.setStroke(v, 0xFF3FFF7F);
       desc = v;
       this.hitBis = new PVector();
       hitBis = this.hit;
     } else {
       this.thumbtacks.setStroke(v, 0xFFFF3F3F);
     }
   }
 }
 
 public void toggle() {
   this.track.setVisible(!this.track.isVisible());
   this.thumbtacks.setVisible(!this.thumbtacks.isVisible());
   this.posts.setVisible(!this.posts.isVisible());
 }
}
