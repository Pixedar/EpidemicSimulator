class Chart {
  PVector pos;
  PVector size;
  color c;
  float max =-Float.MAX_VALUE;
  float min =Float.MAX_VALUE;
  int lastDays = 0;
  ArrayList<Float> values = new ArrayList();
  public Chart(float x, float y, float w, float h, color c) {
    this.pos = new PVector(x, y);
    this.size =new PVector(w, h);
    this.c= c;
  }
  public void update(float data) {
    if ((int)(days*100)!=lastDays) {
      values.add(new Float(data));
      if (data > max) {
        max =data;
      }
      if (data < min) {
        min =data;
      }
      lastDays = (int)(days*100);
    }
  }
  public void draw() {
    stroke(c);
    noFill();
    beginShape();
    strokeWeight(1.5);
    float xQ = 0;
    for (float v : values) {
      float y = map(v, 0, (people.size()-1)*0.25, pos.y, pos.y-size.y);
      float x= map(xQ, 0, 80*100, pos.x, pos.x+size.x);
      vertex(x, y);
      xQ++;
    }
    endShape();
    strokeWeight(1);
  }
}
