
class HeatMap {
  public float size;
  private PVector pos;
  private PImage img;
  private double maxDistanceForCityTravel;
  private ArrayList<Person> people = new ArrayList();
  boolean infectedBuffer[][][];
  int numOfInfected = 0;
  int numOfHospitalsed = 0;
  int numOfRecovered = 0;
  int numOfDeaths= 0;
  int totoalInfected = 0;


  float alpha = 0.75*255;
  color infectedColor;
  color detectedColor;
  color recoveredColor;
  color deadColor;
  

  float deadhHotspots[][];

  float infectionPreventionFactor;
  float testsCapacity;
  float detectionRate;

  float currentMaxHealthCareCapacity;
  float chartsXmargin = 0.01;
  float chartsYmargin = 0.01;
  float chartsWidth = 0.15;
  float chartsHeight= 0.1;
  Params params =new Params();

  final float polandHeight = 647.5;
  final float polandWidth = 650;
  int numOfTests =0;
  PrintWriter output;
  String ck;
  float pl= 25;
  float detectedFactor;

  private float[] positions;
  private float[] colors;
  private int[] indices;

  private int posIndex = 0;
  private int colorIndex = 0;
  private int indicesIndex = 0;


  public HeatMap(ArrayList<Person> people, Renderer renderer, Params params, PVector pos, PImage densityMap, float size) {
    this.params = params;
    this.pos = pos;
    this.size = size;
    this.img = densityMap;
    for (Person p1 : people) {
      this.people.add(new Person(new PVector(p1.pos.x, p1.pos.y)));
    }
    infectedBuffer =  new boolean[width][height][1];
    infectedColor = color(255, 0, 0, alpha);
    detectedColor = color(0, 0, 255, alpha);
    recoveredColor = color(0, 255, 0, alpha);
    deadColor = color(255, 255, 0, 255);

    //    init();

    positions = new float[(people.size()-1)*2];
    colors = new float[(people.size()-1)*4];
    indices = new int[(people.size()-1)];
    for (Person p : this.people) {
      p.setHeatMap(this);
      p.init(params);
    }
    deadhHotspots = new float[params.numOfHotspots][3];

    infect(params.numOfPeopleInfectedAtTheBegining); 




    //   distributePeople();
    if (img.height > img.width) {
      maxDistanceForCityTravel = img.height*mapsSize;
    } else {
      maxDistanceForCityTravel = img.width*mapsSize;
    }


    output = createWriter("\\chart data\\" +"chart data " +getDate()+".txt");

    testsCapacity = params.initialTestingCapacity;
    textSize(params.textSize*size);
  }
  public void incColorIndex() {
    colorIndex++;
  }
  public void incPosIndex() {
    posIndex++;
  }
  public void incIndicesIndex() {
    indicesIndex++;
  }
  public int getColorIndex() {
    return colorIndex;
  }
  public int getPosIndex() {
    return posIndex;
  }
  public int getIndicesIndex() {
    return indicesIndex;
  }
  public float getSize() {
    return size;
  }
  public int getNumOfHospitalsed() {
    return numOfHospitalsed;
  }
  public int getNumOfInfected() {
    return numOfInfected;
  }

  public void setIndices() {
    indices[getIndicesIndex()] = getIndicesIndex();
    incIndicesIndex();
  }
  public float getTestsCapacity() {
    return testsCapacity;
  }

  public void setColors(color c) {
    colors[getColorIndex()] = red(c)/255.0f;
    incColorIndex();
    colors[getColorIndex()] = green(c)/255.0f;
    incColorIndex();
    colors[getColorIndex()] = blue(c)/255.0f;
    incColorIndex();
    colors[getColorIndex()] =alpha(c)/255.0f;
    incColorIndex();
  }
  public void setPos(PVector pos) {
    //    if(posIndex+1 < positions.length){
    positions[posIndex] = pos.x*getSize() +this.pos.x ;
    posIndex++;
    positions[posIndex] = pos.y*getSize()+this.pos.y ;
    posIndex++;
    //  }
  }


  private void infect(int val) {
    for (int k =0; k < val; k++) {
      int n = (int)random(people.size()-1);
      int rg = round(random(0, 19));
      if (random(1) <params.initalDistributionInCities*cityPopulation[rg]) {
        people.get(n).pos.x = cityPos[rg][0];
        people.get(n).pos.y = cityPos[rg][1];
      }
      people.get(n).infect();
    }
  }
  private void showDensityMap() {
    image(img, 0, 0);
    fill(255, 0, 0);
    for (int k =0; k <cityPos.length; k++) {
      ellipse(cityPos[k][0], cityPos[k][1], 7, 7);
    }
  }

  public void draw() {
    detectedFactor = (float)(totoalInfected - numOfInfected)/(people.size()-1);
    calcTestsDetectionRate();
    calcInfectionPreventionFactor();
    calcTestsCapacity();

    indicesIndex= 0;
    posIndex = 0;
    colorIndex = 0;

    for (Person p : people) {
      p.update();
      p.checkStatus();
      p.draw();
    }
    println(testsCapacity);

    //  showWatermark();
    renderer.drawGL(positions, colors, indices);
    //    showStatistics();
    indicesIndex= 0;
    posIndex = 0;
    colorIndex = 0;
  }

  private void calcTestsDetectionRate() {
    if (detectedFactor >params.finalTestsDetectionRateThreshold) return;
    detectionRate= map(detectedFactor, params.finalTestsDetectionRateThreshold, 0, params.finalTestsDetectionRate, params.initialTestsDetectionRate);
  }
  private void calcTestsCapacity() {    
    float p;
    if (detectedFactor >params.finalTestingCapacityThreshold) {
      p = params.finalTestingCapacity;
    } else {
      p = map(detectedFactor, params.finalTestingCapacityThreshold, 0, params.finalTestingCapacity, params.initialTestingCapacity);
    }
    if (p*days*(people.size()-1) < numOfHospitalsed) {
      testsCapacity = p*days*(people.size()-1)/numOfHospitalsed;
    } else {
      testsCapacity = 1;
    }
  }
  private void calcInfectionPreventionFactor() {
    if (detectedFactor > params.finalInfectionPreventionThreshold) return;
    infectionPreventionFactor = map(detectedFactor, params.finalInfectionPreventionThreshold, 0, params.finalInfectionPreventionFactor, params.initialInfectionPreventionFactor);
  }

  private void updateCurrentHealthCapacity() {
    float j = (float)numOfHospitalsed/((float)people.size()-1);
    if (j <params.maxHealthCareCapacity) {
      currentMaxHealthCareCapacity = map(j, 0, params.maxHealthCareCapacity, 0, 1);
    } else {
      currentMaxHealthCareCapacity = 1;
    }
  }
  private void showWatermark() {
    if (pl >0) {
      textSize(14*size);
      fill(red(backgroundColor)+pl, green(backgroundColor)+pl, blue(backgroundColor)+pl);
      text("user/Pixedar", 649*size +pos.x, 944*size +pos.y);
      textSize(params.textSize);
      if (frameCount%30 == 0) {
        pl-=0.1;
      }
    }
  }
  private void showStatistics() {
    int l = 40;
    fill(255-l, l, l);
    text("Total infected: " + str(totoalInfected) + " (" + str(round(10000*(float)totoalInfected/(people.size()-1))/100.0) + "%)", width*0.001*size +pos.x, (height - height*0.002)*size +pos.y);
    text("Currently infected: " + str(numOfInfected) + " (" + str(round(10000*(float)numOfInfected/(people.size()-1))/100.0) + "%)", width*0.001*size+pos.x, (height - height*0.002 - params.textSize*1)*size +pos.y);
    fill(l, l, 255-l);
    text("Detected: " + str(numOfHospitalsed)+ " (" + str(round(10000*(float)numOfHospitalsed/(people.size()-1))/100.0) + "%)", width*0.001*size +pos.x, (height - height*0.002 - params.textSize*2)*size +pos.y);
    fill(l, 255-l, l);
    text("Recovered: " + str(numOfRecovered)+ " (" + str(round(10000*(float)numOfRecovered/(people.size()-1))/100.0) + "%)", width*0.001*size +pos.x, (height - height*0.002 - params.textSize*3)*size +pos.y);
    fill(255-l, 255-l, 0);
    text("Deaths: " + str(numOfDeaths)+ " (" + str(round(10000*(float)numOfDeaths/(people.size()-1))/100.0) + "%)", width*0.001*size, (height - height*0.002 - params.textSize*4)*size + pos.y);
    fill(255-l, 255-l, 255-l);
    text("days: " + str(round(days*10)/10.0), width*0.001*size, (height - height*0.002 - params.textSize*5)+pos.y);
  }

  public void saveCurrentState() {
    println("saving current state");
    try
    {
      java.io.FileOutputStream fos = new java.io.FileOutputStream("\\state data\\"+getID());
      java.io.ObjectOutputStream oos = new java.io.ObjectOutputStream(fos);
      // oos.writeObject(p);
      oos.writeObject(params);
      oos.close();
      fos.close();
      println("saving current state done");
    }           
    catch (IOException ioe) 
    {
      ioe.printStackTrace();
    }
  }
  private String getID() {
    return getDate() + " " +str(round((numOfRecovered+numOfDeaths)/(people.size()-1))*100)+ " "+str(days);
  }
  private String getDate() {
    return format(year())+"-" + format(month()) +"-"+ format(day()) + " " + format(hour())+" "+format(minute()) + " "+ format(second());
  }
  private String format(int v) {
    if (v <9) {
      return "0"+str(v);
    }
    return str(v);
  }
  public void setInfectedColor(color c) {
    this.infectedColor = c;
  }
  public void setDetectedColorr(color c) {
    this.detectedColor = c;
  }
  public void setRecoveredColor(color c) {
    this.recoveredColor = c;
  }
  public void setDeadColorr(color c) {
    this.deadColor = c;
  }
}
