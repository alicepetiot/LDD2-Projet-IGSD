public class Buildings {

  private Map3D map;
  private ArrayList<PShape> buildings = new ArrayList<PShape>();

  Buildings(Map3D map) {
    this.map = map;
  }

  void add(String fileName, color Color) {
    PShape building = createShape(GROUP);
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
    JSONArray features =  geojson.getJSONArray("features");
    if (features == null) {
      println("WARNING: GeoJSON file doesn't contain any feature.");
      return;
    }
    
    for (int f = 0; f < features.size(); f++) {
      JSONObject feature = features.getJSONObject(f);
      JSONObject geometry = feature.getJSONObject("geometry");
      JSONObject properties = feature.getJSONObject("properties");
      int levels = properties.getInt("building:levels", 1);
      float top = Map3D.heightScale * 3.0f * (float)levels;
      if (!feature.hasKey("geometry"))break;
      switch (geometry.getString("type", "undefined")) {
        case "Polygon":
          JSONArray coordinates = geometry.getJSONArray("coordinates");
          if (coordinates != null) {
            for (int p = 0; p < coordinates.size(); p++) {
              JSONArray build = coordinates.getJSONArray(p);          
              PShape walls = createShape();
              walls.beginShape(QUAD_STRIP);
              walls.emissive(0x30);
              walls.fill(Color);
              walls.noStroke();
              PShape roof = createShape();
              roof.beginShape(POLYGON);
              roof.emissive(0x60);
              roof.fill(Color);
              roof.noStroke();
              if (build != null) {
                for (int i = 0; i < build.size()-1; i++) {
                  JSONArray point = build.getJSONArray(i);
                  JSONArray point1 = build.getJSONArray(i+1);
                  Map3D.GeoPoint Gp1 = this.map.new GeoPoint(point.getDouble(0), point.getDouble(1));
                  Map3D.GeoPoint Gp2 = this.map.new GeoPoint(point1.getDouble(0),point1.getDouble(1));
                  if (Gp1.inside() && Gp2.inside()) {
                    Map3D.ObjectPoint Obj1 = this.map.new ObjectPoint(Gp1);
                    Map3D.ObjectPoint Obj2 = this.map.new ObjectPoint(Gp2);
                    walls.vertex(Obj1.x,Obj1.y,Obj1.z);
                    walls.vertex(Obj1.x,Obj1.y,Obj1.z + top);
                    walls.vertex(Obj2.x,Obj2.y,Obj2.z);
                    walls.vertex(Obj2.x,Obj2.y,Obj2.z + top);
                    roof.vertex(Obj1.x,Obj1.y,Obj1.z + top);
                  }
                }
              }
              walls.endShape();
              roof.endShape();
              building.addChild(walls);
              building.addChild(roof);
            }
          }
          break;
        default:
          println("WARNING: GeoJSON '" + geometry.getString("type", "undefined") + "' geometry type not handled.");
          break;
      }
    }
    //initializes visible shapes
    for (int i = 0; i < this.buildings.size(); i++){
      this.buildings.get(i).setVisible(this.buildings.get(i).isVisible());
    }
    this.buildings.add(building);
  }

  void update() {
    for (int i = 0; i < this.buildings.size(); i++)
      shape(this.buildings.get(i));
  }

  void toggle() {
    for (int i = 0; i < this.buildings.size(); i++)
      this.buildings.get(i).setVisible(!this.buildings.get(i).isVisible());
  }

}
