public class Railways {
  PShape railways,railtrack;
  Map3D map;
  int lineWidth = 5;
  
  Railways(Map3D map, String fileName){
    this.map = map;
    this.railways = createShape(GROUP);
    //checks ressources
    File ressource = dataFile(fileName);
    if (!ressource.exists() || ressource.isDirectory()){
      println("ERROR: GeoJSON file " + fileName + " not found.");
      return;
    }
    
    //loads geojson and checks features collection
    JSONObject geojson = loadJSONObject(fileName);
    if (!geojson.hasKey("type")) {
      println("WARNIN: Invalid GeoJSON file.");
      return;
    } else if (!"FeatureCollection".equals(geojson.getString("type", "undefined"))) {
      println("WARNING: GeoJSON file doesn't contain features collection.");
      return; 
    }
    
    //parses-analyses features
    JSONArray features = geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }
    
    for (int f = 0; f < features.size(); f++) {
      JSONObject feature = features.getJSONObject(f);
      if (!feature.hasKey("geometry"))
        break;
      JSONObject geometry = feature.getJSONObject("geometry");
      this.railtrack = createShape();
      this.railtrack.beginShape(QUAD_STRIP);
      this.railtrack.noFill(); 
      this.railtrack.stroke(#F2FDFF); 
      this.railtrack.strokeWeight(1.5); 
      switch(geometry.getString("type","undefined")) {
        case "LineString":
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if(coordinates != null) {
            for (int p = 0; p < coordinates.size(); p++) {
              JSONArray point = coordinates.getJSONArray(p);
              //println("point ",f,point.getDouble(0),point.getDouble(1));
              Map3D.GeoPoint Mp1 = this.map.new GeoPoint(point.getDouble(0), point.getDouble(1));
              Map3D.GeoPoint Mp2 = this.map.new GeoPoint(point.getDouble(0), point.getDouble(1));
              
              if (Mp1.inside()){
                Mp1.elevation += 7.5d;
                Map3D.ObjectPoint Obj1 = this.map.new ObjectPoint(Mp1);
                Map3D.ObjectPoint Obj2 = this.map.new ObjectPoint(Mp2);
                PVector Va = new PVector(Obj1.y - Obj2.y, Obj2.x - Obj1.x).normalize().mult(this.lineWidth/2.0f);
                this.railtrack.vertex(Obj1.x - Va.x ,Obj1.y - Va.y,Obj1.z);
                this.railtrack.vertex(Obj1.x + Va.x,Obj1.y + Va.y,Obj1.z);
 
              }
            }
          }
          break;
        default:
          println("WARNING: GeoJSON' " + geometry.getString("type","undefined") + " ' geometru type not handled.");
          break;
        }
      this.railtrack.endShape();
      this.railways.addChild(this.railtrack);
    }
    this.railways.setVisible(true);
  }
  
  public void update(){
    shape(this.railways);
  }
  
  public void toggle(){
    this.railways.setVisible(!this.railways.isVisible());
  }
}
