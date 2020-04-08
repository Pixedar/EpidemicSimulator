import java.io.Serializable;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.IntBuffer;
import com.jogamp.opengl.GL;
import com.jogamp.opengl.GL2ES2;
IntBuffer pixelsBuff; 
SplittableRandom s = new SplittableRandom();
Renderer renderer;
PShader shader;
color backgroundColor = color(0);
FloatBuffer posBuffer;
FloatBuffer colorBuffer;
IntBuffer indexBuffer;
ArrayList<HeatMap> heatMaps = new ArrayList();
boolean mapGridMode = false;
float mapsSize = 0.25;
float mapsMargin = 0.0001;
PImage img;
ArrayList<Person> people = new ArrayList();
final float simulationSpeed = 0.02f;
float days = 0;
Chart chart;
void setup() {
  size(1207, 1122, P2D);
  //size(1900, 1122, P2D);

  shader = loadShader("shaders/frag.glsl", "shaders/vert.glsl");
  img = loadImage("\\maps\\"+"poland_density.png");
  // img.resize((int)(img.width*0.2), (int)(img.height*0.2));
  chart = new Chart(img.width+10, 100, width-img.width, 200, color(255));
  distributePeople(new Params());
  fillCityPos();
  fillCityPopulation();

  allocBuffers(people.size()-1);
  renderer =  new Renderer(posBuffer, colorBuffer, indexBuffer);

  if (mapGridMode) {
    int w =(int)(width/(img.width*mapsSize + 2*mapsMargin*width));
    int h = (int)(height/(img.height*mapsSize + 2*mapsMargin*width)); 

    for (int y = 0; y < h; y++) {
      for (int x = 0; x <w; x++) {

        Params p = new Params();
        p.initialTestingCapacity = setParam(p.initialTestingCapacity, x, w, 0.99);
        p.finalTestingCapacity = setParam(p.finalTestingCapacity, x, w, 0.99);

        p.finalTestsDetectionRate = setParam(p.finalTestsDetectionRate, y, h, 0.92);
        p.initialTestsDetectionRate = setParam(p.initialTestsDetectionRate, y, h, 0.92);


        PVector pos = new PVector(x*mapsMargin + x*img.width*mapsSize, y*mapsMargin + y*img.width*mapsSize);

        heatMaps.add(new HeatMap(people, renderer, p, pos, img, mapsSize));
      }
    }
    //  int numOfMaps = (1.0/(mapsSize+2*mapsMargin))
  } else {
    mapsSize = 1.0;
    heatMaps.add(new HeatMap(people, renderer, new Params(), new PVector(0, 0), img, mapsSize));
  }
}
float setParam(float p, int index, int max) {
  return  p + map(index, 0, max, -p*0.5, p*0.5);
}
float setParam(float p, int index, int max, float v) {
  return  p + map(index, 0, max, -p*v, p*v);
}
void distributePeople(Params params) {
  for (int y =0; y < img.height; y++) {
    for (int x =0; x < img.width; x++) {
      color c = img.get(x, y);
      float val = brightness(c);
      if (c!=255) {
        if (random(255) >= val) {
          people.add(new Person(new PVector(x, y)));
        }
      }
    }
  }
}
void allocBuffers(int length) {
  posBuffer = allocateDirectFloatBuffer(length*2);
  colorBuffer = allocateDirectFloatBuffer(length*4); 
  indexBuffer = allocateDirectIntBuffer(length);
}
void draw() {
  //println(mouseX +" "+ mouseY);

  background(0);
  for (HeatMap h : heatMaps) {
    h.draw();
  }

  if (!mapGridMode) {
    for (HeatMap h : heatMaps) {
      h.showStatistics();
    }
  }
  days+=simulationSpeed;
  // saveFrame("frames/#####");
}
//void keyPressed() {
//  if (key == 'q') {
//    saveChartData();
//    exit();
//  }
//  if (key == 'w') {
//    saveChartData();
//    saveCurrentState();
//    exit();
//  }
//}
//void saveChartData() {
//  println("savingData");
//  output.flush(); 
//  output.close(); 
//  println("savingData done");
//}
FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}

IntBuffer allocateDirectIntBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Integer.BYTES).order(ByteOrder.nativeOrder()).asIntBuffer();
}
