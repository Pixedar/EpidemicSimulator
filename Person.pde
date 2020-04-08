import java.util.SplittableRandom;
float locTestSumA = 0;
float locTestSumB = 0;
float tCtn = 0;
float maxCp = 0;
class Person implements Serializable {
  private color c;
  private int infectionSpreadRadius;
  private PVector pos;
  private PVector v = new PVector();
  private int vQ = 1;
  public boolean infected = false;
  public boolean detected = false;
  private boolean witchoutSymptoms = false;
  private boolean dead = false;
  private boolean recovered = false;
  private float firstContactTimeInDays =0;
  private float daysWithoutSymptoms;
  private float disaseDuration;
  private float stayAtCityTime = 0;
  private boolean traveledToAnotherCity = false;
  private PVector lastPos;
  private float leaveHomeDate = 0;
  private boolean isTraveling = false;
  private float travelCoef = 0;
  private float localTravelRate;
  private float infectionProbability;
  private int hotspotId;
  private PVector lastPosForBuf = new PVector();
  private boolean outOfRange = false;
  private HeatMap heatMap;
  Params params;
  public Person() {
  }
  public Person(PVector pos) {
    this.pos = pos;
  }
  public void init(Params params) {
    this.params = params;
    infectionSpreadRadius = round(random(params.meanInfectionSpreadRadius, params.maxInfectionSpreadRadius, params.minInfectionSpreadRadius));
    daysWithoutSymptoms = random(params.meanDaysWithoutSymptoms, params.maxDaysWithoutSymptoms, params.minDaysWithoutSymptoms); 
    disaseDuration = random(params.meanDisaseDuration, params.maxDisaseDuration, params.minDisaseDuration);
    localTravelRate = random(params.meanLocalTravelRate, params.maxLocalTravelRate, params.minLocalTravelRate);
    infectionProbability = random(params.meanInfectionProbability, params.maxInfectionProbability, params.minInfectionProbability);
    hotspotId = round(random(params.numOfHotspots-1));
  }
  public void setHeatMap(HeatMap heatMap) {
    this.heatMap = heatMap;
  }
  public void setParams(Params params) {
    this.params = params;
  }
  public void update() {
    if (outOfRange) {
      return;
    }
    lastPosForBuf.x = pos.x;
    lastPosForBuf.y = pos.y;
    if (!recovered&&!dead) {
      handlePeroidWithoutSymptopms();
      handleDiseaseResult();
    }
    if ((!detected&&!dead)||recovered) {
      moveWithinCity();  
      handleIntercityTravel();
    }
    if ((int)pos.x<=0||(int)pos.x >=img.width||(int)pos.y <=0||(int)pos.y >=img.height) {
      outOfRange = true;
      return;
    }
    updateLocBuffer();
  }
  private void updateLocBuffer() {
    heatMap.infectedBuffer[(int)lastPosForBuf.x][(int)lastPosForBuf.y][0] = false;
    //  heatMap.getheatMap.infectedBuffer()[(int)pos.x][(int)pos.y][0] = infected2;
    heatMap.infectedBuffer[(int)pos.x][(int)pos.y][0] = infected;
  }

  private void moveWithinCity() {
    double xT = s.nextDouble(-localTravelRate, localTravelRate);
    double yT = s.nextDouble(-localTravelRate, localTravelRate);
    pos.x+=xT;
    pos.y+= yT;
    // locTestSumA +=abs((float)xT);
    // locTestSumB+=abs((float)yT);
    // tCtn++;
  }

  private void handlePeroidWithoutSymptopms() {
    if (days > firstContactTimeInDays + daysWithoutSymptoms&&infected&&!detected&&!recovered&&!dead) {

      if (s.nextDouble() < heatMap.detectionRate*heatMap.getTestsCapacity()) {
        c = heatMap.detectedColor;
        detected = true;
        infected = false;
        heatMap.numOfInfected--;
        heatMap.numOfHospitalsed++;
      }
    }
  }
  private void handleDiseaseResult() {
    if (days > firstContactTimeInDays + disaseDuration + daysWithoutSymptoms&&(infected||detected)) {
      float localMortalityRate = getLoclMortalityRate();
      if (s.nextDouble() <localMortalityRate) {
        dead = true;
        c = heatMap.deadColor;
        heatMap.numOfDeaths++;
      } else {
        recovered = true;
        c = heatMap.recoveredColor;
        heatMap.numOfRecovered++;
      }
      heatMap.numOfHospitalsed--;
      if (!detected) {
        heatMap.numOfInfected --;
      }
      infected = false;
    }
  }

  private float getLoclMortalityRate() {
    if (witchoutSymptoms) {
      return 0;
    }
    float cP = 0;
    for (int k = 0; k < params.numOfHotspots; k++) {   
      float dist = dist(heatMap.deadhHotspots[k][0]/heatMap.deadhHotspots[k][2], heatMap.deadhHotspots[k][1]/heatMap.deadhHotspots[k][2], pos.x, pos.y);
      if (dist !=0) {
        cP+=1.0/dist;
      }
    }
    //check min possible avg distance
    if (cP >maxCp) {
      maxCp = cP;
    }
    if (heatMap.currentMaxHealthCareCapacity*params.maxMortalityRate > params.minMortalityRate) {
      //if local mortality rate is higher than minimal mortality return local mortality rate
      return map(cP, 0, maxCp, params.minMortalityRate, heatMap.currentMaxHealthCareCapacity*params.maxMortalityRate);
    }
    return params.minMortalityRate;
  }
  private void returnToHome() {
    pos.x = lastPos.x;
    pos.y = lastPos.y;
    traveledToAnotherCity = false;
  }

  private void handleIntercityTravel() { 
    if (traveledToAnotherCity&&days > leaveHomeDate + stayAtCityTime ) {
      returnToHome();
      return;
    }
    if (!traveledToAnotherCity&&  s.nextDouble() < params.intercityTravelRate) {
      stayAtCityTime = random(params.meanTimeAwayFromHome, params.maxTimeAwayFromHome, params.minTimeAwayFromHome);
      lastPos = new PVector(pos.x, pos.y);
      traveledToAnotherCity = true;
      isTraveling = true;
      leaveHomeDate = days;
      int maxCx = 0;
      int maxCy = 0;
      double maxC =0;
      float population =0.5;
      if (s.nextDouble() >params.heavyTravelers) {
        for (int k =0; k < cityPos.length; k++) {
          double dist = dist(pos.x, pos.y, cityPos[k][0], cityPos[k][1]);
          if (dist > heatMap.maxDistanceForCityTravel*0.01&&  s.nextDouble()>0.1) {
            dist*=dist*s.nextDouble(params.travelDistanceSpread, 1);
            double c = (1.0d/(dist))*cityPopulation[k];
            if (c > maxC) {
              maxC = c;
              maxCx = (int)(cityPos[k][0]);
              maxCy = (int)(cityPos[k][1]);
              population = (float)cityPopulation[k];
            }
          }
        }
      } else {    
        int rw = s.nextInt(0, 20);
        maxCx = (int)(cityPos[rw][0]);
        maxCy = (int)(cityPos[rw][1]);  
        population = (float)cityPopulation[rw];
        stayAtCityTime = params.minTimeAwayFromHome ;
      }

      float cf = 0;
      float cf2 = 0;
      for (int k =0; k <3; k++) {
        cf+=s.nextDouble(-params.citySpread*population, params.citySpread*population);
        cf2+=s.nextDouble(-params.citySpread*population, params.citySpread*population);
      }
      pos.x = maxCx + cf*img.width;
      pos.y = maxCy +cf2*img.height;
  //    travelCtn ++;
    }
  }
  public void draw() {  
    if (infected||detected||dead||recovered&&(heatMap.posIndex+1 <heatMap.people.size()-1)) {
      heatMap.setPos(pos);
      heatMap.setColors(c);
      heatMap.setIndices();
    }
  }
  void infect() {
    firstContactTimeInDays = days;
    c = heatMap.infectedColor;
    infected = true;
    // infected2 =true;
    heatMap.numOfInfected++;
    heatMap.totoalInfected ++;
    heatMap.deadhHotspots[hotspotId][0]+= pos.x;
    heatMap.deadhHotspots[hotspotId][1]+= pos.y;
    heatMap.deadhHotspots[hotspotId][2]++;
  }
  void checkStatus() {
    if (!detected&&!infected&&!recovered&&!dead&&s.nextDouble() <=infectionProbability*heatMap.infectionPreventionFactor) {
      for (int y1 = -infectionSpreadRadius; y1 <= infectionSpreadRadius; y1++) {
        for (int x1 = -infectionSpreadRadius; x1 <= infectionSpreadRadius; x1++) {
          if (x1+y1 == 0) {
            continue;
          }
          int xD = (int)(pos.x+x1);
          int yD = (int)(pos.y+y1);

          if (xD >0&&xD < img.width&&yD>0&&yD<img.height) {
            if (heatMap.infectedBuffer[xD][yD][0]) {
              infect();
              return;
            }
          }
        }
      }
    }
  }
}
float random(float mean, float max, float min) {
  float maxD;
  if (abs(mean -max) >abs(mean -min)) {
    maxD = abs(mean -max);
  } else {
    maxD = abs(mean -min);
  }
  if (max == min) return mean;
  for (int k=0; k < 4; k++) {
    float  h = (float)s.nextDouble(min, max);
    float meanDist = abs(mean -h)/maxD; 
    if (s.nextDouble() > sqrt(meanDist)) {
      return h;
    }
  }
  return mean;
}
