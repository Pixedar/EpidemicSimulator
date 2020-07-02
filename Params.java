import processing.core.*;
import java.io.Serializable;
class Params implements Serializable {
  //local mortality rate is calculated based on nerbay acive cases, localMortalityRateSamplesFactor specify ratio of samples to total number of population, the highest the value the more precise local mortality rate is caluclatd at the cost of performance
  public float localMortalityRateSamplesFactor = 0.07f; 
  public int numOfHotspots = 4;
  public int numOfPeopleInfectedAtTheBegining=3;
// public int numOfPeopleInfectedAtTheBegining= 10000;
  public float maxCitySize = 0.01f;
  //how much people infected at the beginning is located in cities or country where 1 mean 100% people is located in city
  public float initalDistributionInCities =0.35f;
  //visual:
  //color backgroundColor = color(0);
  //color infectedColor = color(255,0,0);
  //color detectedColor = color(0,0,255);
  //color recoveredColor = color(0,255,0);
  //color deadColor = color(255,255,0);
  int textSize = 16;
  //DISEASE PARAMS:
  //probability that person will infect another person
  float minInfectionProbability =  0.003f;
  float maxInfectionProbability = 0.01f;
  float meanInfectionProbability = 0.007f; //from 0 to 1
  //how many people can one person infect (for simulation with large number of peoples where distance between pixels is low is recommended to keep this param low and change infect probability instead):
  public int maxInfectionSpreadRadius = 1;
  public int minInfectionSpreadRadius = 1;
  public int meanInfectionSpreadRadius = 1;
  //mortalityRate (mean value is missing because local mortality rate is cacluated based on number of active cases and health care capacity):
  public float maxMortalityRate = 0.55f;
  public float minMortalityRate = 0.015f;
  //days without symptoms:
  public float meanDaysWithoutSymptoms = 5;
  public float maxDaysWithoutSymptoms = 10;
  public float minDaysWithoutSymptoms = 2;
  //disaseDuration in days:
  public float maxDisaseDuration = 40;
  public float minDisaseDuration = 5;
  public float meanDisaseDuration = 9;
  //Probability that person will have disase without symptoms and/or will not be detected and isolated:
  public float undetecedRate = 0.0f;
  //MOVEMENT PARAMS:
  //how important is distance to another city lower value will increase likelihood of traveling large distances, for travelDistanceSpread = 1 people will travel only to nearest city 
  public float travelDistanceSpread = 0.2f;
  //people that travel a lot (truck drivers etc) compared to to averange person where 1 meaning 100% people that are traveling (so if ie. intercityTravelRate = 0.001 and heavyTravelers = 1 the total procentage of all population will be 0.1%)
  public float heavyTravelers = 0.1f;
  //how much people travel within citites:
  public float maxLocalTravelRate =0.3f;
  public float minLocalTravelRate = 0;
  public float meanLocalTravelRate = 0.1f;
  //how much time in days peopole spend in another city when they decied to travel:
  public float maxTimeAwayFromHome = 35; 
  public float minTimeAwayFromHome = 0.5f;
  public float meanTimeAwayFromHome = 5;
  //Probability that person will travel to another city:
  public float intercityTravelRate = 0.000127f;
  //public float intercityTravelRate = 0.0001f;
  //how much people spread through the city when they arrived where 1 mean 100% window width
  public float citySpread = 0.01f;
  //PREVENTION PARMS:
  public boolean enablePrevention = true;
  //health care capacity number of hospotals,doctors etc. from 0 to 1 where 1 mean 100% population, if ratio of active cases to population will exceed maxHealthCareCapacity mortality rate will reach maxMortalityRate
  public float maxHealthCareCapacity = 0.00223f;
  //public float 
  //how much people will follow the prevention rules
  //public float globalRulesFactor = 0.9f;
  //public float maxGlobalPreventionThreshold;
  //public float minGloablPreventionThreshold;
  
  public float initialInfectionPreventionFactor = 1.0f;
  public float finalInfectionPreventionFactor = 0.5f;
  
  public float finalInfectionPreventionThreshold = 0.25f;
  //probability that test will detect illness
  public float initialTestsDetectionRate = 0.18f;
  public float finalTestsDetectionRate = 0.991f;
  public float finalTestsDetectionRateThreshold = 0.15f;
  //amout of available tests
  public float initialTestingCapacity = 0.001f;
  public float finalTestingCapacity = 0.0022f;
  public float finalTestingCapacityThreshold = 0.15f;
  
  //mean 3.672 days
}
