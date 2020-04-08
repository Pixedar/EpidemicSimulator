double cityPopulation[] = new double[21];
int cityPos[][] = new int[21][2];

void fillCityPopulation() {
  final double maxPopulation = 1783321;
  cityPopulation[0] = maxPopulation/maxPopulation;//Warszawa
  cityPopulation[1] = 774839.0d/maxPopulation;//Krakow
  cityPopulation[2] = 682679.0d/maxPopulation;//Lodz
  cityPopulation[3] = 641607.0d/maxPopulation;//Wroclaw
  cityPopulation[4] = 535802.0d/maxPopulation;//Poznan
  cityPopulation[5] = 468158.0d/maxPopulation;//Gdansk
  cityPopulation[6] = 402067.0d/maxPopulation;//Szczecin
  cityPopulation[7] = 349021.0d/maxPopulation;//Bydgoszcz
  cityPopulation[8] = 339770.0d/maxPopulation;//Lublin
  cityPopulation[9] = 297356.0d/maxPopulation;//Bialystok
  cityPopulation[10] = 296262.0d/maxPopulation;//Katowice
  cityPopulation[11] = 246306.0d/maxPopulation;//Gdynia
  cityPopulation[12] = 224376.0d/maxPopulation;//Czestochowa
  cityPopulation[13] = 214566.0d/maxPopulation;//Radom
  cityPopulation[14] = 204013.0d/maxPopulation;//Sosnowiec
  cityPopulation[15] = 202562.0d/maxPopulation;//Torun
  cityPopulation[16] = 196804.0d/maxPopulation;//Kielce
  cityPopulation[17] = 189662.0d/maxPopulation;//Rzeszow
  cityPopulation[18] = 173070.0d/maxPopulation;//Olsztyn
  cityPopulation[19] = 139819.0d/maxPopulation;//Zielona gora
  cityPopulation[20] = 171277.0d/maxPopulation;//Bielsko Biala
}

void fillCityPos() {
  cityPos[0][0] = 817;
  cityPos[0][1] = 498;

  cityPos[1][0] = 694;
  cityPos[1][1] = 927;

  cityPos[2][0] = 629;
  cityPos[2][1] = 598;  

  cityPos[3][0] = 330;
  cityPos[3][1] = 719;

  cityPos[4][0] = 330;
  cityPos[4][1] = 467;

  cityPos[5][0] = 528;
  cityPos[5][1] = 85;

  cityPos[6][0] = 65;
  cityPos[6][1] = 252;

  cityPos[7][0] = 463;
  cityPos[7][1] = 332;

  cityPos[8][0] = 1008;
  cityPos[8][1] = 691;

  cityPos[9][0] = 1058;
  cityPos[9][1] = 316;

  cityPos[10][0] = 558;
  cityPos[10][1] = 876;

  cityPos[11][0] = 519;
  cityPos[11][1] = 58;

  cityPos[12][0] = 585;
  cityPos[12][1] = 783;

  cityPos[13][0] = 836;
  cityPos[13][1] = 665;

  cityPos[14][0] = 590;
  cityPos[14][1] = 881; 

  cityPos[15][0] = 532;
  cityPos[15][1] = 350; 

  cityPos[16][0] = 770;
  cityPos[16][1] = 774; 

  cityPos[17][0] = 951;
  cityPos[17][1] = 928; 

  cityPos[18][0] = 743;
  cityPos[18][1] = 203; 

  cityPos[19][0] = 159;
  cityPos[19][1] = 557;

  cityPos[20][0] = 576;
  cityPos[20][1] = 979;
}
