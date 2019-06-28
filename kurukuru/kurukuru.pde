PVector basePos = new PVector();

class Stage{
  int x, y, w, h;
  int flag;
  
  void wall(){
    if(1 <= flag && flag <= 6){
      ellipse(x*4, y*4, w*4, h*4);
    }else{
      //rect(x, y, w, h);
      rect(x*4, y*4, w*4, h*4);
    }
  }
  
  void obstacle(){
  }
  
  int makeRandom(int n, int m){
    int r = int(random(n)+m);
    return r;
  }
  
  boolean hit(int px, int py){
    if(x*4 <= px && px <= x*4+w*4){
      if(y*4 <= py && py <= y*4+h*4){
        return false;
      }else{
        return true;
      }
    }else{
      return true;
    }
  }
  
  boolean goal(int px, int py){
    if(dist(px, py, x*4, y*4) <= 30){
      return true;
    }else{
      return false;
    }
  }
}

class Player{
  int x = 50;
  int y = 50;
  float flag;
  void spinPole(){
    ellipse(x, y, 15*3, 15*3);
  }
  
  void spinArrow(){
  }
  
  void progress(){
  }
}

abstract class Effect {
  long t_effect;
  float t;

  Effect() {
    t_effect = millis();
  }

  Effect doEffect() {
    t = (millis() - t_effect) / 1000.0;
    text(nf(t, 1, 3)  + "sec.", 20, 20);
    drawEffect();
    return decideEffect();
  }

  abstract void drawEffect();
  abstract Effect decideEffect();
}

class TitleEffect extends Effect {
  void drawEffect() {
    text("Game Title", width * 0.5, height * 0.3);
    text("Press 'z' key to start", width * 0.5, height * 0.7);
  }

  Effect decideEffect() {
    if (keyPressed && key == 'z') { // if 'z' key is pressed
      return new GameEffect(); // start game
    }
    return this;
  }
}

class GameEffect extends Effect {
  void drawEffect() {
    text("Game (for 5 seconds)", width * 0.5, height * 0.5);
  }
  
  Effect decideEffect() {
    if (t>5 == true) { // if ellapsed time is larger than
      return new EndingEffect(); // go to ending
    } 
    return this;
  }
}

class EndingEffect extends Effect {
  void drawEffect() {
    text("GAME CLEAR", width * 0.5, height * 0.5);
    if (t > 3) {
      text("Press 'a' to restart game.", width * 0.5, height * 0.7);
    }
  }

  Effect decideEffect() {
    if (t > 3 && keyPressed && key == 'a') {
      return new TitleEffect();
    }
    return this;
  }
}
//state
Effect effect;

//room
Stage s1, s2, s3, s4, s5, s6;

//path
Stage s1_r, s1_d;
Stage s2_l, s2_d, s2_r;
Stage s3_l, s3_d;
Stage s4_u, s4_r;
Stage s5_l, s5_u, s5_r;
Stage s6_l, s6_u;

//bridge
Stage b1, b2, b3, b4, b5, b6, b7;

//goal
Stage g;

//pole
Player p;

//
Effect e;

//first xy
int x0, y0;

void setup(){
  //size(900, 600);
  size(600, 600);
//  size(300, 200);

  textSize(32); 
  fill(128);
  e =new TitleEffect();
  
  s1 = new Stage();
  s2 = new Stage();
  s3 = new Stage();
  s4 = new Stage();
  s5 = new Stage();
  s6 = new Stage();
  
  s1_r = new Stage();
  s1_d = new Stage();
  s2_l = new Stage();
  s2_d = new Stage();
  s2_r = new Stage();
  s3_l = new Stage();
  s3_d = new Stage();
  s4_u = new Stage();
  s4_r = new Stage();
  s5_l = new Stage();
  s5_u = new Stage();
  s5_r = new Stage();
  s6_l = new Stage();
  s6_u = new Stage();
  
  b1 = new Stage();
  b2 = new Stage();
  b3 = new Stage();
  b4 = new Stage();
  b5 = new Stage();
  b6 = new Stage();
  b7 = new Stage();
  
  g = new Stage();
  
  p = new Player();
  e = new TitleEffect();
  
  noStroke();
  fill(200, 100, 100);
  rect(0, 0, 300, 300);
  
  fill(100, 200, 100);
  rect(300, 0, 300, 300);
  
  fill(100, 100, 200);
  rect(600, 0, 300, 300);
  
  fill(200, 200, 100);
  rect(0, 300, 300, 300);
  
  fill(200, 100, 200);
  rect(300, 300, 300, 300);
  
  fill(100, 200, 200);
  rect(600, 300, 300, 300);
  
  s1.x = s1.makeRandom(40, 30);
  s1.y = s1.makeRandom(40, 30);
  s1.w = s1.makeRandom(150, 80);
  s1.h = s1.makeRandom(150, 80);
  
  s2.x = s2.makeRandom(40, 330);
  s2.y = s2.makeRandom(40, 30);
  s2.w = s2.makeRandom(150, 80);
  s2.h = s2.makeRandom(150, 80);
  
  s3.x = s3.makeRandom(40, 630);
  s3.y = s3.makeRandom(40, 30);
  s3.w = s3.makeRandom(150, 80);
  s3.h = s3.makeRandom(150, 80);
  
  s4.x = s4.makeRandom(40, 30);
  s4.y = s4.makeRandom(40, 330);
  s4.w = s4.makeRandom(150, 80);
  s4.h = s4.makeRandom(150, 80);
  
  s5.x = s5.makeRandom(40, 330);
  s5.y = s5.makeRandom(40, 330);
  s5.w = s5.makeRandom(150, 80);
  s5.h = s5.makeRandom(150, 80);
  
  s6.x = s6.makeRandom(40, 630);
  s6.y = s6.makeRandom(40, 330);
  s6.w = s6.makeRandom(150, 80);
  s6.h = s6.makeRandom(150, 80);
  
  s1_r.x = s1.x+s1.w;
  s1_r.y = int(random(s1.y)+s1.h-20);
  s1_r.w = 300-s1.x-s1.w;
  s1_r.h = 20;
  
  s1_d.x = int(random(s1.x)+s1.w-20);
  s1_d.y = s1.y+s1.h;
  s1_d.w = 20;
  s1_d.h = 300-s1.y-s1.h;
  
  s2_l.x = s2.x;
  s2_l.y = int(random(s2.y)+s2.h-20);
  s2_l.w = 300-s2.x;
  s2_l.h = 20;
  
  s2_d.x = int(random(s2.x, (s2.x)+s2.w-20));
  s2_d.y = s2.y+s2.h;
  s2_d.w = 20;
  s2_d.h = 300-s2.y-s2.h;
  
  s2_r.x = s2.x+s2.w;
  s2_r.y = int(random(s2.y)+s2.h-20);
  s2_r.w = 600-s2.x-s2.w;
  s2_r.h = 20;
  
  s3_l.x = s3.x;
  s3_l.y = int(random(s3.y)+s3.h-20);
  s3_l.w = 600-s3.x;
  s3_l.h = 20;
  
  s3_d.x = int(random(s3.x, (s3.x)+s3.w-20));
  s3_d.y = s3.y+s3.h;
  s3_d.w = 20;
  s3_d.h = 300-s3.y-s3.h;
  
  s4_u.x = int(random(s4.x, (s4.x)+s4.w-20));
  s4_u.y = s4.y;
  s4_u.w = 20;
  s4_u.h = 300-s4.y;
  
  s4_r.x = s4.x+s4.w;
  s4_r.y = int(random(s4.y, (s4.y)+s4.h-20));
  s4_r.w = 300-s4.x-s4.w;
  s4_r.h = 20;
  
  s5_l.x = s5.x;
  s5_l.y = int(random(s5.y, (s5.y)+s5.h-20));
  s5_l.w = 300-s5.x;
  s5_l.h = 20;
  
  s5_u.x = int(random(s5.x, (s5.x)+s5.w-20));
  s5_u.y = s5.y;
  s5_u.w = 20;
  s5_u.h = 300-s5.y;
  
  s5_r.x = s5.x+s5.w;
  s5_r.y = int(random(s5.y, (s5.y)+s5.h-20));
  s5_r.w = 600-s5.x-s5.w;
  s5_r.h = 20;
  
  s6_l.x = s6.x;
  s6_l.y = int(random(s6.y, (s6.y)+s6.h-20));
  s6_l.w = 600-s6.x;
  s6_l.h = 20;
  
  s6_u.x = int(random(s6.x, (s6.x)+s6.w-20));
  s6_u.y = s6.y;
  s6_u.w = 20;
  s6_u.h = 300-s6.y;
  
  if(s2_l.y <= s1_r.y){
    b1.x = s1_r.x + s1_r.w;
    b1.y = s2_l.y;
    b1.w = 20;
    b1.h = s1_r.y - s2_l.y + 20;
  }else{
    b1.x = s1_r.x + s1_r.w;
    b1.y = s1_r.y;
    b1.w = 20;
    b1.h = s2_l.y - s1_r.y;
  }
  
  if(s3_l.y <= s2_r.y){
    b2.x = s2_r.x + s2_r.w;
    b2.y = s3_l.y;
    b2.w = 20;
    b2.h = s2_r.y - s3_l.y + 20;
  }else{
    b2.x = s2_r.x + s2_r.w;
    b2.y = s2_r.y;
    b2.w = 20;
    b2.h = s3_l.y - s2_r.y;
  }
  
  if(s1_d.x <= s4_u.x){
    b3.x = s1_d.x;
    b3.y = s4_u.y + s4_u.h;
    b3.w = s4_u.x - s1_d.x + 20;
    b3.h = 20;
  }else{
    b3.x = s4_u.x;
    b3.y = s4_u.y + s4_u.h;
    b3.w = s1_d.x - s4_u.x + 20;
    b3.h = 20;
  }
  
  if(s5_l.y <= s4_r.y){
    b4.x = s4_r.x + s4_r.w;
    b4.y = s5_l.y;
    b4.w = 20;
    b4.h = s4_r.y - s5_l.y + 20;
  }else{
    b4.x = s4_r.x + s4_r.w;
    b4.y = s4_r.y;
    b4.w = 20;
    b4.h = s5_l.y - s4_r.y;
  }
  
  if(s2_d.x <= s5_u.x){
    b5.x = s2_d.x;
    b5.y = s5_u.y + s5_u.h;
    b5.w = s5_u.x - s2_d.x + 20;
    b5.h = 20;
  }else{
    b5.x = s5_u.x;
    b5.y = s5_u.y + s5_u.h;
    b5.w = s2_d.x - s5_u.x + 20;
    b5.h = 20;
  }
  
  if(s6_l.y <= s5_r.y){
    b6.x = s5_r.x + s5_r.w;
    b6.y = s6_l.y;
    b6.w = 20;
    b6.h = s5_r.y - s6_l.y + 20;
  }else{
    b6.x = s5_r.x + s5_r.w;
    b6.y = s5_r.y;
    b6.w = 20;
    b6.h = s6_l.y - s5_r.y;
  }
  
  if(s3_d.x <= s6_u.x){
    b7.x = s3_d.x;
    b7.y = s6_u.y + s6_u.h;
    b7.w = s6_u.x - s3_d.x + 20;
    b7.h = 20;
  }else{
    b7.x = s6_u.x;
    b7.y = s6_u.y + s6_u.h;
    b7.w = s3_d.x - s6_u.x + 20;
    b7.h = 20;
  }
  
  g.flag = int(random(1, 7));
  println(g.flag);
  g.x = 10;
  g.y = 10;
  g.w = 20;
  g.h = 20;
  
  if(g.flag == 1){
    g.x = int(random(s1.x+20, s1.x+s1.w-20));
    g.y = int(random(s1.y+20, s1.y+s1.h-20));
  }else if(g.flag == 2){
    g.x = int(random(s2.x+20, s2.x+s2.w-20));
    g.y = int(random(s2.y+20, s2.y+s2.h-20));
  }else if(g.flag == 3){
    g.x = int(random(s3.x+20, s3.x+s3.w-20));
    g.y = int(random(s3.y+20, s3.y+s3.h-20));
  }else if(g.flag == 4){
    g.x = int(random(s4.x+20, s4.x+s4.w-20));
    g.y = int(random(s4.y+20, s4.y+s4.h-20));
  }else if(g.flag == 5){
    g.x = int(random(s5.x+20, s5.x+s5.w-20));
    g.y = int(random(s5.y+20, s5.y+s5.h-20));
  }else{
    g.x = int(random(s6.x+20, s6.x+s6.w-20));
    g.y = int(random(s6.y+20, s6.y+s6.h-20));
  }
    
  p.x = int(random(s1.x*3)+s1.w*3-20);
  p.y = int(random(s1.y*3)+s1.h*3-20);
  x0 = p.x;
  y0 = p.y;
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == RIGHT){
      p.x += 15;
    }
    if(keyCode == LEFT){
      p.x -= 15;
    }
    if(keyCode == UP){
      p.y -= 15;
    }
    if(keyCode == DOWN){
      p.y += 15;
    }
  }
}
        

void draw(){
  background(0);
  
  basePos.x = (basePos.x * 0.98f + (-p.x + width/2)*0.02f);
  basePos.y = (basePos.y * 0.98f + (-p.y + height/2)*0.02f);
  translate(basePos.x, basePos.y);
  
  e = e.doEffect();
  
  //stage-generate
  noStroke();
  fill(255);
  s1.wall();
  s2.wall();
  s3.wall();
  s4.wall();
  s5.wall();
  s6.wall();
  
  s1_r.wall();
  s1_d.wall();
  
  s2_l.wall();
  s2_d.wall();
  s2_r.wall();
  
  s3_l.wall();
  s3_d.wall();
  
  s4_u.wall();
  s4_r.wall();
  
  s5_l.wall();
  s5_u.wall();
  s5_r.wall();
  
  s6_l.wall();
  s6_u.wall();
  
  b1.wall();
  b2.wall();
  b3.wall();
  b4.wall();
  b5.wall();
  b6.wall();
  b7.wall();
  
  p.flag = 1.0;
  if(s1.hit(p.x, p.y) == false){
    p.flag = 1.0;
  }else{
    println("TRUE");
    p.x = x0;
    p.y = y0;
  }
  
  if(s1.hit(p.x, p.y) == true){
    if(p.flag == 1.5 && s1_r.hit(p.x, p.y) == false){
      p.flag = 1.5;
    }else{
      println("TRUE");
      p.x = x0;
      p.y = y0;
    }
  }
    
  /*
  if(s1.hit(p.x, p.y) == false){
    if((s2.hit(p.x, p.y) == true) && (s3.hit(p.x, p.y) == true) &&
       (s4.hit(p.x, p.y) == true) && (s5.hit(p.x, p.y) == true) &&
       (s5.hit(p.x, p.y) == true)){
         //do nothing
       }
     }else{
       println("true 1");
       p.x = x0;
       p.y = y0;
     }
  */
  
  if(g.goal(p.x, p.y) == true){
    println("CLEAR");
    setup();
  }else{
    //cheak
    //println(dist(p.x, p.y, g.x, g.y));
  }
  
  fill(100, 100, 200);
  g.wall();
  
  fill(200, 100, 100);
  p.spinPole();
  
}
