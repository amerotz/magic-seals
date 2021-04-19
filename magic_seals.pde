int id = 0;
int n;
final float outer = 0.9;
final float inner = 0.87;
final float mid = 0.7;
float inside;
final int dim = 400;
String name;
int textSize = 30;

color polyColor = color(217, 221, 146);
color white = color(236, 228, 183);
color black = color(49, 30, 16);
color mainRune = color(221, 96, 49);
color minorRunes = color(234, 190, 124);

void keyPressed(){
  if (keyCode == ENTER) {
    id = (int)(random(Integer.MAX_VALUE));
    randomSeed(id);
    n = (int)(random(3, 13));
    if(n == 4) n = 13;
    inside = abs(mid * (1 - 2* sin(PI / n) * cos(HALF_PI * (n - 2) / n)));
    name = name();
  }
  else if(key == 's') selectOutput("Export as png...", "fileSelected");
  key = '\\';
}

void fileSelected(File f){
  save(f.getAbsolutePath()+".png");
}

void setup() {
  id = millis();
  randomSeed(id);
  size(500, 500);
  n = (int)(random(3, 13));
  if(n == 4) n = 13;
  inside = abs(mid * (1 - 2 * sin(PI / n) * cos(HALF_PI * (n - 2) / n)));
  name = name();
}

void draw() {
  background(black);
  translate(width / 2, height / 2);
  randomSeed(id);
  showName();
  
  translate(0, textSize/2);

  circles();
  poly();
  signs();
  rune(id, inside, 3, mainRune);
}

void circles() {
  stroke(white);
  noFill();
  strokeWeight(3);
  circle(0, 0, dim * outer);
  circle(0, 0, dim * inner);
  circle(0, 0, dim * mid);
}

void poly() {
  noFill();
  strokeWeight(1);
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < n; i++) {
    float angle = -HALF_PI + TWO_PI * i / n;
    float x = 0.5 * dim * cos(angle);
    float y = 0.5 * dim * sin(angle);
    stroke(polyColor);
    vertex(mid * x, mid * y);
    line(mid * x, mid * y, inner * x, inner * y);
  }
  vertex(mid * 0.5 * dim * cos(-HALF_PI), mid * 0.5 * dim * sin(-HALF_PI));
  vertex(mid * 0.5 * dim * cos(-HALF_PI + TWO_PI / n), mid * 0.5 * dim * sin(-HALF_PI + TWO_PI / n));
  endShape();
}

void signs() {
  float len = (mid + inner) / 2;
  for (int i = 0; i < n; i++) {
    float angle = -HALF_PI + TWO_PI / (2 * n) + TWO_PI * i / n;
    float x = len*0.5 * dim * cos(angle);
    float y = len*0.5 * dim * sin(angle);
    push();
    translate(x, y);
    rotate(-HALF_PI + angle);
    rune((int)random(Integer.MAX_VALUE), (mid-inner)*0.3, 2, minorRunes);
    pop();
  }
}

void rune(int seed, float rad, float s, color c){
  //4 different "Great Symbols"
  greatSymbol(seed, rad, s, c);
  //4 lines
  cardinals(seed, rad, s, c);
}

void greatSymbol(int seed, float rad, float s, color c){
  randomSeed(seed);
  float side = 0.5*rad*inner*dim;
  int gs = (int)random(4);
  stroke(c);
  strokeWeight(s);
  switch(gs){
    case 0: // the wand
    line(0, -side, 0, side);
    break;
    case 1: // the crown
    {
    beginShape();
    int k = 2;
    for(int i = 0; i <= k; i++){
      float angle = -PI + PI*i/k;
      float x = 0.5*side*cos(angle);
      float y = 0.5*side*sin(angle);
      vertex(x, y);
    }
    endShape();
    break;
    }
    case 2: // the snake
    {
    float x = 0;
    float y = side*sin(HALF_PI);
    float angle = PI*0.4;
    float xoff = side*cos(angle)*0.66;
    float yoff = side*sin(angle)*0.66;
    beginShape();
    vertex(x, y);
    vertex(x - xoff, y - yoff);
    vertex(-x + xoff, -y + yoff);
    vertex(-x, -y);
    endShape();
    break;
    }
    case 3: //the sword
    {
    line(0, -side, 0, side);
    line(-0.25*side, 0.33*side, 0.25*side, 0.33*side);
    }
  }
}

void cardinals(int seed, float rad, float s, color col){
  randomSeed(seed);
  float side = 0.5*rad*inner*dim;
  stroke(col);
  strokeWeight(s);
  int k = n;
  beginShape();
  float c[] = new float[k];
  for(int i = 0; i < k; i++) c[i] = i/(float)k;
  for(int i = 0; i < k; i++){
    int j = (int)random(k);
    float tmp = c[i];
    c[i] = c[j];
    c[j] = tmp;
  }
  for(int i = 0; i < 3; i++) {
    float angle = c[i]*TWO_PI;
    float x = side*cos(angle);
    float y = side*sin(angle);
    vertex(x, y);
  }
 endShape();
}

void showName(){
  textSize(textSize);
  fill(white);
  textAlign(CENTER);
  text(name, 0, -height*0.5 + 1.5*textSize);
}

String name(){
  randomSeed(id);
  String s = "";
  final String[] cons = {"b", "g", "j", "d", "dh", "h", "z", "zh", "kh", "t", "k", "m", "n", "s", "p", "tsh", "q", "r", "sh", "th"};
  final String[] vow = {"e", "a", "o", "i", "e", "a", "o", "u", "ei", "ai", "oi", "ui", "y"};
  for(int i = 0; i < random(4, 7); i++){
    if(i%2 == 0) s += cons[(int)(random(cons.length))];
    else s += vow[(int)(random(vow.length))];
    if(random(1) < 0.02) s += "\'";
  }
  char[] c = s.toCharArray();
  s = "";
  for(int i = 0; i < c.length; i++){
    s += c[i];
    if(i == 0) s = s.toUpperCase();
  }
  return s;
}
