public class Roads {
  PShape roadsways,roadstrack;
  Map3D map;
  String laneKind = "unclassified";
  color laneColor = 0xFFFF0000;
  double laneOffset = 1.50d;
  float laneWidth = 0.5f;
  
  Roads(Map3D map, String fileName){
    this.map = map;
    this.roadsways = createShape(GROUP);
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
      this.roadstrack = createShape();
      this.roadstrack.beginShape(LINE_STRIP);
      this.roadstrack.noFill(); 
      this.roadstrack.stroke(this.laneColor); 
      this.roadstrack.strokeWeight(this.laneWidth); 
      switch(geometry.getString("type","undefined")) {
        case "LineString":
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if(coordinates != null) {
            for (int p = 0; p < coordinates.size(); p++) {
              JSONArray point = coordinates.getJSONArray(p);
              //println("point ",f,point.getDouble(0),point.getDouble(1));
              Map3D.GeoPoint Mp1 = this.map.new GeoPoint(point.getDouble(0), point.getDouble(1));
              if (Mp1.inside()){
                Mp1.elevation += 7.5d;
                Map3D.ObjectPoint Obj1 = this.map.new ObjectPoint(Mp1);
                this.roadstrack.vertex(Obj1.x,Obj1.y,Obj1.z);
              }
            }
          }
          break;
        default:
          println("WARNING: GeoJSON' " + geometry.getString("type","undefined") + " ' geometru type not handled.");
          break;
      }
      // See https://wiki.openstreetmap.org/wiki/Key:highway
      JSONObject properties = feature.getJSONObject("properties");
      laneKind = properties.getString("highway", "unclassified");
      switch (laneKind) {
      case "motorway":
       laneColor = 0xFFe990a0;
       laneOffset = 3.75d;
       laneWidth = 2.50f;
       break;
      case "trunk":
       laneColor = 0xFFfbb29a;
       laneOffset = 3.60d;
       laneWidth = 2.25f;
       break;
      case "trunk_link":
      case "primary":
       laneColor = 0xFFfdd7a1;
       laneOffset = 3.45d;
       laneWidth = 2.0f;
       break;
      case "secondary":
      case "primary_link":
       laneColor = 0xFFf6fabb;
       laneOffset = 3.30d;
       laneWidth = 1.75f;
       break;
      case "tertiary":
      case "secondary_link":
       laneColor = 0xFFE2E5A9;
       laneOffset = 3.15d;
       laneWidth = 1.50f;
       break;
      case "tertiary_link":
      case "residential":
      case "construction":
      case "living_street":
       laneColor = 0xFFB2B485;
       laneOffset = 3.00d;
       laneWidth = 1.25f;
       break;
      case "corridor":
      case "cycleway":
      case "footway":
      case "path":
      case "pedestrian":
      case "service":
      case "steps":
      case "track":
      case "unclassified":
       laneColor = 0xFFcee8B9;
       laneOffset = 2.85d;
       laneWidth = 1.0f;
       break;
      default:
       laneColor = 0xFFFF0000;
       laneOffset = 1.50d;
       laneWidth = 0.5f;
       println("WARNING: Roads kind not handled : ", laneKind);
       break;
      }
      // Display threshold (increase if more performance needed...)
      if (laneWidth < 1.0f)
       break;
      this.roadstrack.endShape();
      this.roadsways.addChild(this.roadstrack);
    }
    
    this.roadsways.setVisible(true);
  }
  
  public void update(){
    shape(this.roadsways);
  }
  
  public void toggle(){
    this.roadsways.setVisible(!this.roadsways.isVisible());
  }
}
