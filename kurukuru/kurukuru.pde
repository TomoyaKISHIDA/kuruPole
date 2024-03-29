PVector basePos = new PVector();
int EffectFlag = 0;
int HitCount=0, ClearCount=0;
/*-------------------------------------*/
/*-----------------------------------------------
     ステージクラス
-----------------------------------------------*/
class Stage{
  int x, y, w, h;
  int flag;
  float ox, oy, dx, dy;
  float seek = 0.005;
  float s = 75;
  PImage obs = loadImage("inini.png"); //おっさんface
  PImage go = loadImage("kurugoal.png"); //ゴール
  
  //壁生成
  void wall(){
    if (1 <= flag && flag <= 6){
      //ellipse(x, y, w, h);//check
      //ellipse(x*4, y*4, w*4, h*4);
      image(go, x*4, y*4, s, s);
    }else{
      //rect(x, y, w, h);//check
      rect(x*4, y*4, w*4, h*4);
    }
  }
  
  //障害物おっさん表示
  void displayObstacle(){
    image(obs, ox, oy, s, s);
  }
  
  //障害物の動き(プレイヤーに寄る)
  void obstacle(int px, int py){
    seek = 0.0070;
    dx = px-25 -ox;
    dy = py-25 -oy;
    if(1 < abs(ox)){
      ox += dx * seek;
    }
    if(1 < abs(oy)){
      oy += dy * seek;
    }
  }
  
  //障害物の動き(ステージ端による)
  void backObstacle(int sx, int sy){
    seek = 0.0015;
    dx = sx-25 -ox;
    dy = sy-25 -oy;
    if(1 < abs(ox)){
      ox += dx * seek;
    }
    if(1 < abs(oy)){
      oy += dy * seek;
    }
  }

  boolean hitObstacle(int px, int py){
    dx = px-40 -ox;
    dy = py-40 -oy;
    if(abs(dx) < 40){
      if(abs(dy) < 40){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  int makeRandom(int n, int m){
    int r = int(random(n)+m);
    return r;
  }

  boolean hit(int px, int py){
    int r = 15;
    if(x*4 <= px+r && px-r <= x*4+w*4){
      if(y*4 <= py+r && py-r <= y*4+h*4){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  boolean goal(int px, int py){
    if (dist(px, py, x*4+go.width/2-30, y*4+go.height/2-30) <= 30){
      return true;
    }else{
      return false;
    }
  }
}

/*-----------------------------------------------
     プレイヤークラス
-----------------------------------------------*/
class Player{
  PImage pole = loadImage("kurupole.png"); 
  PImage arrow = loadImage("kuruarrow.png");
  float stepx = 3;
  float stepy = 3;
  float s = 30; //size
  float r = 0;

  int px = 100;
  int py = 100;

  float rollP = 0;
  float rollA = 0;

  int start;

  int x;
  int y;

  void spinPole(){
    x = px + pole.width / 2;
    y = py + pole.height / 2;
    pushMatrix();
    translate(x, y);
    rotate(rollP);
    imageMode(CENTER);
    image(pole, 0, 0, s * 5, s);
    imageMode(CORNER);
    popMatrix();
    rollP += 0.03;
  }

  void spinArrow(){
    x = px + pole.width / 2;
    y = py + pole.height / 2;
    pushMatrix();
    translate(x, y);
    rotate(rollA);
    imageMode(CENTER);
    image(arrow, 0, 0, s, s);
    imageMode(CORNER);
    popMatrix();

    rollA += 0.035;
    r += 2;
    if(r == 360){
      r = 0;
      rollA = 0;
    }
  }

  void progress(){
    x = px + pole.width / 2;
    y = py + pole.height / 2;
    pushMatrix();
    translate(x, y);
    rotate(rollA);
    imageMode(CENTER);
    image(arrow, 0, 0, s, s);
    imageMode(CORNER);
    popMatrix();

    if(r <= 22.5){
      py -= stepy;
    }else if(r <= 67.5){
      px += stepx;
      py -= stepy;
    }else if(r <= 112.5){
      px += stepx;
    }else if(r <= 157.5){
      px += stepx;
      py += stepy;
    }else if(r <= 202.5){
      py += stepy;
    }else if(r <= 247.5){
      px -= stepy;
      py += stepx;
    }else if(r <= 292.5){
      px -= stepx;
    }else if(r <= 337.5){
      px -= stepx;      
      py -= stepy;
    }else{
      py -= stepy;
    }
  }
}
/*----------------------------------------------*/
/*-----------------------------------------------
     エフェクトクラス
-----------------------------------------------*/
class Effect{
  PImage meme = loadImage("kuruclear.png");

  void state(){
    fill(0);
    PFont font = createFont("MS Gothic", 48, true);
    textFont(font); // 選択したフォントを指定する
    text("くるぼーる", width * 0.37, height * 0.2);
    //text("練習画面", width * 0.4, height * 0.3);
    text("操作を説明するぜ！！", width * 0.28, height * 0.5);
    text("ENTERキーを押す！これだけだ", width * 0.16, height * 0.6);
    fill(100, 100, 200);
    text("Press 'z' key to start", width * 0.24, height * 0.7);
    
    if(keyPressed && key == 'z'){ // if 'z' key is pressed
      //setup();
      randomStart();
      EffectFlag += 1;
    }
  }

  //(x座標, y座標, 幅, 高さ, 再帰回数)
  void divideRect(float x, float y, float w, float h, int n){ 
    stroke(0);
    fill(220, 50, 50);
    rect(x, y, w, h);

    n--;
    if(n>=0){   
      //幅が高さよりも大きい、または幅と高さが等しい場合
      if(w>=h){
        //ランダムな値を得る
        float randomW = random(w*0.1, w*0.9);
        //ランダムな値から2つのdivideRectを呼び出す
        divideRect(x, y, randomW, h, n);    //左側の四角形
        divideRect(x+randomW, y, w-randomW, h, n);    //右側の四角形
      }

      //幅が高さよりも小さい場合
      if(w<h){
        float randomH = random(h*0.1, h*0.9);
        divideRect(x, y, w, randomH, n);    //上側の四角形
        divideRect(x, y+randomH, w, h-randomH, n);    //下側の四角形
      }
    }
  }

  void GO(){
    divideRect(10, 10, width-20, height-20, 8);

    fill(0);
    text("Game Over", width * 0.35, height * 0.3);
    text("Press 'r' key to RE:start", width * 0.22, height * 0.7);
    text("Press 'e' key to easy RE:start", width * 0.16, height * 0.5);
    if(keyPressed && key == 'r'){ // if 'z' key is pressed
      EffectFlag = 0;
      HitCount = 0;
      obstacleStart();
    }else if(keyPressed && key == 'e'){ // if 'z' key is pressed
      EffectFlag = 0;
      HitCount = 0;
      ClearCount +=1;
      obstacleStart();
    }
  }

  void clearEnd(){
    background(255);
    image(meme, 0, 0, width+50, height);

    if(keyPressed && key == 'r'){
      setup();
      EffectFlag = 0;
      HitCount = 0;
      ClearCount = 0;
    }
  }
}
/*----------------------------------------------*/
/*-----------------------------------------------
     グローバル変数
-----------------------------------------------*/
//state
Effect effect;
//room
Stage s1, s2, s3, s4, s5, s6;

//out of stage
Stage[] o;

//path
Stage s1_r, s1_d;
Stage s2_l, s2_d, s2_r;
Stage s3_l, s3_d;
Stage s4_u, s4_r;
Stage s5_l, s5_u, s5_r;
Stage s6_l, s6_u;

//obstacle
Stage[] obstacle;

//bridge
Stage b1, b2, b3, b4, b5, b6, b7;

//goal
Stage g;

//pole
Player p;
int flag = 0;

//effect
Effect e;

//first xy
int x0, y0;
int cnt;

float ro = 0;

/*----------------------------------------------*/
void setup(){
  int a = 15;
  size(900, 600);
  //size(600, 600);  

  s1 = new Stage();
  s2 = new Stage();
  s3 = new Stage();
  s4 = new Stage();
  s5 = new Stage();
  s6 = new Stage();

  o = new Stage[52];
  for(int i = 0; i < o.length; i ++){
    o[i] = new Stage();
  }

  obstacle = new Stage[6];
  for(int i = 0; i < obstacle.length; i ++){
    obstacle[i] = new Stage();
  }

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

  textSize(48); 
  fill(128);
  e = new Effect();

  noStroke();
  /*
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
   */
  /*-----------------------------------------------
   ステージ生成(ランダム)
   -----------------------------------------------*/
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

  /*-----------------------------------------------
   通路生成(ランダム)
   -----------------------------------------------*/

  s1_r.x = s1.x+s1.w;
  s1_r.y = int(random(s1.y)+s1.h-a);
  s1_r.w = 300-s1.x-s1.w;
  s1_r.h = a;

  s1_d.x = int(random(s1.x)+s1.w-a);
  s1_d.y = s1.y+s1.h;
  s1_d.w = a;
  s1_d.h = 300-s1.y-s1.h;

  s2_l.x = 300;
  s2_l.y = int(random(s2.y)+s2.h-a);
  s2_l.w = s2.x-300;
  s2_l.h = a;

  s2_d.x = int(random(s2.x, (s2.x)+s2.w-a));
  s2_d.y = s2.y+s2.h;
  s2_d.w = a;
  s2_d.h = 300-s2.y-s2.h;

  s2_r.x = s2.x+s2.w;
  s2_r.y = int(random(s2.y)+s2.h-a);
  s2_r.w = 600-s2.x-s2.w;
  s2_r.h = a;

  s3_l.x = 600;
  s3_l.y = int(random(s3.y)+s3.h-a);
  s3_l.w = s3.x-600;
  s3_l.h = a;

  s3_d.x = int(random(s3.x, (s3.x)+s3.w-a));
  s3_d.y = s3.y+s3.h;
  s3_d.w = a;
  s3_d.h = 300-s3.y-s3.h;

  s4_u.x = int(random(s4.x, (s4.x)+s4.w-a));
  s4_u.y = 300;
  s4_u.w = a;
  s4_u.h = s4.y-300;

  s4_r.x = s4.x+s4.w;
  s4_r.y = int(random(s4.y, (s4.y)+s4.h-a));
  s4_r.w = 300-s4.x-s4.w;
  s4_r.h = a;

  s5_l.x = 300;
  s5_l.y = int(random(s5.y, (s5.y)+s5.h-a));
  s5_l.w = s5.x-300;
  s5_l.h = a;

  s5_u.x = int(random(s5.x, (s5.x)+s5.w-a));
  s5_u.y = 300;
  s5_u.w = a;
  s5_u.h = s5.y-300;

  s5_r.x = s5.x+s5.w;
  s5_r.y = int(random(s5.y, (s5.y)+s5.h-a));
  s5_r.w = 600-s5.x-s5.w;
  s5_r.h = a;

  s6_l.x = 600;
  s6_l.y = int(random(s6.y, (s6.y)+s6.h-a));
  s6_l.w = s6.x-600;
  s6_l.h = a;

  s6_u.x = int(random(s6.x, (s6.x)+s6.w-a));
  s6_u.y = 300;
  s6_u.w = a;
  s6_u.h = s6.y-300;

  /*-----------------------------------------------
   通路をつなぐ橋生成
   -----------------------------------------------*/

  if(s2_l.y <= s1_r.y){
    b1.x = s1_r.x + s1_r.w;
    b1.y = s2_l.y;
    b1.w = a;
    b1.h = s1_r.y - s2_l.y + a;
  }else{
    b1.x = s1_r.x + s1_r.w;
    b1.y = s1_r.y;
    b1.w = a;
    b1.h = s2_l.y - s1_r.y;
  }

  if(s3_l.y <= s2_r.y){
    b2.x = s2_r.x + s2_r.w;
    b2.y = s3_l.y;
    b2.w = a;
    b2.h = s2_r.y - s3_l.y + a;
  }else{
    b2.x = s2_r.x + s2_r.w;
    b2.y = s2_r.y;
    b2.w = a;
    b2.h = s3_l.y - s2_r.y;
  }

  if(s1_d.x <= s4_u.x){
    b3.x = s1_d.x;
    b3.y = s4_u.y;
    b3.w = s4_u.x - s1_d.x + a;
    b3.h = a;
  }else{
    b3.x = s4_u.x;
    b3.y = s4_u.y;
    b3.w = s1_d.x - s4_u.x + a;
    b3.h = a;
  }

  if(s5_l.y <= s4_r.y){
    b4.x = s4_r.x + s4_r.w;
    b4.y = s5_l.y;
    b4.w = a;
    b4.h = s4_r.y - s5_l.y + a;
  }else{
    b4.x = s4_r.x + s4_r.w;
    b4.y = s4_r.y;
    b4.w = a;
    b4.h = s5_l.y - s4_r.y;
  }

  if(s2_d.x <= s5_u.x){
    b5.x = s2_d.x;
    b5.y = s5_u.y;
    b5.w = s5_u.x - s2_d.x + a;
    b5.h = a;
  }else{
    b5.x = s5_u.x;
    b5.y = s5_u.y;
    b5.w = s2_d.x - s5_u.x + a;
    b5.h = a;
  }

  if(s6_l.y <= s5_r.y){
    b6.x = s5_r.x + s5_r.w;
    b6.y = s6_l.y;
    b6.w = a;
    b6.h = s5_r.y - s6_l.y + a;
  }else{
    b6.x = s5_r.x + s5_r.w;
    b6.y = s5_r.y;
    b6.w = a;
    b6.h = s6_l.y - s5_r.y;
  }

  if(s3_d.x <= s6_u.x){
    b7.x = s3_d.x;
    b7.y = s6_u.y;
    b7.w = s6_u.x - s3_d.x + a;
    b7.h = a;
  }else{
    b7.x = s6_u.x;
    b7.y = s6_u.y;
    b7.w = s3_d.x - s6_u.x + a;
    b7.h = a;
  }

  /*-----------------------------------------------
   ステージの外側(壁)生成
   -----------------------------------------------*/

  o[0].x = s1.x;
  o[0].y = 0;
  o[0].w = s1.w;
  o[0].h = s1.y;

  o[1].x = 0;
  o[1].y = s1.y;
  o[1].w = s1.x;
  o[1].h = s1.h;

  o[2].x = s1.x;
  o[2].y = s1.y+s1.h;
  o[2].w = s1_d.x-s1.x;
  o[2].h = s1_d.h;

  o[3].x = s1_d.x+s1_d.w;
  o[3].y = s1.y+s1.h;
  o[3].w = s1.x+s1.w-s1_d.x-s1_d.w;
  o[3].h = s1_d.h;

  o[4].x = s1.x+s1.w;
  o[4].y = s1.y;
  o[4].w = s1_r.w;
  o[4].h = s1_r.y-s1.y;

  o[5].x = s1.x+s1.w;
  o[5].y = s1_r.y+s1_r.h;
  o[5].w = s1_r.w;
  o[5].h = s1.y+s1.h-s1_r.y-s1_r.h;

  o[6].x = b1.x;
  o[6].y = b1.y-b1.w;
  o[6].w = b1.w;
  o[6].h = b1.w;

  if(s2_l.y <= s1_r.y){
    o[7].x = b1.x;
    o[7].y = b1.y+b1.h;
    o[7].w = b1.w;
    o[7].h = s1.y+s1.h-b1.y-b1.h;

    o[9].x = s2_l.x+b1.w;
    o[9].y = s2_l.y+s2_l.h;
    o[9].w = s2_l.w-b1.w;
    o[9].h = 300-s2_l.y-s2_l.h;
  }else{
    o[7].x = s1_r.x;
    o[7].y = b1.y+b1.w;
    o[7].w = s1_r.w;
    o[7].h = b1.h;

    o[9].x = b1.x;
    o[9].y = s2_l.y+s2_l.h;
    o[9].w = s2_l.w;
    o[9].h = 300-s2_l.y-s2_l.h;
  }

  o[8].x = s2_l.x+b1.w;
  o[8].y = s2.y;
  o[8].w = s2_l.w-b1.w;
  o[8].h = s2_l.y-s2.y;

  o[10].x = s2.x;
  o[10].y = 0;
  o[10].w = s2.w;
  o[10].h = s2.y;

  o[11].x = s2.x;
  o[11].y = s2.y+s2.h;
  o[11].w = s2_d.x-s2.x;
  o[11].h = 300-s2.y-s2.h;

  o[12].x = s2_d.x+s2_d.w;
  o[12].y = s2_d.y;
  o[12].w = s2.x+s2.w-s2_d.x-s2_d.w;
  o[12].h = s2_d.h;

  o[13].x = s2.x+s2.w;
  o[13].y = s2.y;
  o[13].w = s2_r.w;
  o[13].h = s2_r.y-s2.y;

  o[14].x = s2.x+s2.w;
  o[14].y = s2_r.y+s2_r.h;
  o[14].w = s2_r.w;
  o[14].h = s2.y+s2.h-s2_r.y-s2_r.h;

  o[15].x = b2.x;
  o[15].y = b2.y-b2.w;
  o[15].w = b2.w;
  o[15].h = b2.w;

  if(s3_l.y <= s2_r.y){
    o[16].x = b2.x;
    o[16].y = b2.y+b2.h;
    o[16].w = b2.w;
    o[16].h = s2.y+s2.h-b2.y-b2.h;

    o[18].x = s3_l.x+b2.w;
    o[18].y = s3_l.y+s3_l.h;
    o[18].w = s3_l.w-b2.w;
    o[18].h = 300-s3_l.y-s3_l.h;
  }else{
    o[16].x = s2_r.x;
    o[16].y = b2.y+b2.w;
    o[16].w = s2_r.w;
    o[16].h = b2.h;

    o[18].x = b2.x;
    o[18].y = s3_l.y+s3_l.h;
    o[18].w = s3_l.w;
    o[18].h = 300-s3_l.y-s3_l.h;
  }

  o[17].x = s3_l.x+b2.w;
  o[17].y = s3.y;
  o[17].w = s3_l.w-b2.w;
  o[17].h = s3_l.y-s3.y;

  o[19].x = s3.x;
  o[19].y = 0;
  o[19].w = s3.w;
  o[19].h = s3.y;

  o[20].x = s3.x;
  o[20].y = s3.y+s3.h;
  o[20].w = s3_d.x-s3.x;
  o[20].h = 300-s3.y-s3.h;

  o[21].x = s3_d.x+s3_d.w;
  o[21].y = s3_d.y;
  o[21].w = s3.x+s3.w-s3_d.x-s3_d.w;
  o[21].h = s3_d.h;

  o[22].x = s3.x+s3.w;
  o[22].y = s3.y;
  o[22].w = 900-s3.x-s3.w;
  o[22].h = s3.h;

  if(s1_d.x <= s4_u.x){
    o[23].x = b3.x+b3.h;
    o[23].y = b3.y-b3.h;
    o[23].w = b3.w;
    o[23].h = b3.h;

    o[25].x = 0;
    o[25].y = b3.y;
    o[25].w = b3.x;
    o[25].h = b3.h;

    o[26].x = s4_u.x+s4_u.w;
    o[26].y = s4_u.y;
    o[26].w = 300-s4_u.x-s4_u.w;
    o[26].h = s4_u.h;
  }else{
    o[23].x = b3.x+b3.w;
    o[23].y = b3.y;
    o[23].w = s1.x+s1.w-s1_d.x-s1_d.w;
    o[23].h = b3.h;

    o[25].x = 0;
    o[25].y = b3.y;
    o[25].w = b3.x;
    o[25].h = b3.h;

    o[26].x = s4_u.x+s4_u.w;
    o[26].y = s4_u.y+b3.h;
    o[26].w = 300-s4_u.x-s4_u.w;
    o[26].h = s4_u.h-b3.h;
  }

  o[24].x = s4.x;
  o[24].y = s4_u.y+b3.h;
  o[24].w = s4_u.x-s4.x;
  o[24].h = s4_u.h-b3.h;

  o[27].x = 0;
  o[27].y = s4.y;
  o[27].w = s4.x;
  o[27].h = s4.h;

  o[28].x = s4.x;
  o[28].y = s4.y+s4.h;
  o[28].w = s4.w;
  o[28].h = 600-s4.y-s4.h;

  o[29].x = s4.x+s4.w;
  o[29].y = s4.y;
  o[29].w = s4_r.w;
  o[29].h = s4_r.y-s4.y;

  o[30].x = s4.x+s4.w;
  o[30].y = s4_r.y+s4_r.h;
  o[30].w = s4_r.w;
  o[30].h = s4.y+s4.h-s4_r.y-s4_r.h;

  o[31].x = b4.x;
  o[31].y = b4.y-b4.w;
  o[31].w = b4.w;
  o[31].h = b4.w;

  if(s5_l.y <= s4_r.y){
    o[32].x = b4.x;
    o[32].y = b4.y+b4.h;
    o[32].w = b4.w;
    o[32].h = s4.y+s4.h-b4.y-b4.h;

    o[34].x = s5_l.x+b4.w;
    o[34].y = s5_l.y+s5_l.h;
    o[34].w = s5_l.w-b4.w;
    o[34].h = 600-s2_l.y-s2_l.h;
  }else{
    o[32].x = s4_r.x;
    o[32].y = b4.y+b4.w;
    o[32].w = s4_r.w;
    o[32].h = b4.h;

    o[34].x = s5_l.x;
    o[34].y = s5_l.y+s5_l.h;
    o[34].w = s5_l.w;
    o[34].h = 600-s2_l.y;
  }

  o[33].x = s5_l.x+b4.w;
  o[33].y = s5.y;
  o[33].w = s5_l.w-b4.w;
  o[33].h = s5_l.y-s5.y;

  if(s2_d.x <= s5_u.x){
    o[35].x = b5.x+b5.h;
    o[35].y = b5.y-b5.h;
    o[35].w = b5.w;
    o[35].h = b5.h;

    o[37].x = 300;
    o[37].y = b5.y;
    o[37].w = b5.x-300;
    o[37].h = b5.h;

    o[38].x = s5_u.x+s5_u.w;
    o[38].y = s5_u.y;
    o[38].w = 600-s5_u.x-s5_u.w;
    o[38].h = s5_u.h;
  }else{
    o[35].x = b5.x+b5.w;
    o[35].y = b5.y;
    o[35].w = s2.x+s2.w-s2_d.x-s2_d.w;
    o[35].h = b5.h;

    o[37].x = 300;
    o[37].y = b5.y;
    o[37].w = b5.x-300;
    o[37].h = b5.h;

    o[38].x = s5_u.x+s5_u.w;
    o[38].y = s5_u.y+b5.h;
    o[38].w = 600-s5_u.x-s5_u.w;
    o[38].h = s5_u.h-b5.h;
  }

  o[36].x = s5.x;
  o[36].y = s5_u.y+b5.h;
  o[36].w = s5_u.x-s5.x;
  o[36].h = s5_u.h-b5.h;

  o[39].x = s5.x;
  o[39].y = s5.y+s5.h;
  o[39].w = s5.w;
  o[39].h = 600-s5.y-s5.h;

  o[40].x = s5.x+s5.w;
  o[40].y = s5.y;
  o[40].w = s5_r.w;
  o[40].h = s5_r.y-s5.y;

  o[41].x = s5.x+s5.w;
  o[41].y = s5_r.y+s5_r.h;
  o[41].w = s5_r.w;
  o[41].h = s5.y+s5.h-s5_r.y-s5_r.h;

  o[42].x = b6.x;
  o[42].y = b6.y-b6.w;
  o[42].w = b6.w;
  o[42].h = b6.w;

  if(s6_l.y <= s5_r.y){
    o[43].x = b6.x;
    o[43].y = b6.y+b6.h;
    o[43].w = b6.w;
    o[43].h = s5.y+s5.h-b6.y-b6.h;

    o[45].x = s6_l.x+b6.w;
    o[45].y = s6_l.y+s6_l.h;
    o[45].w = s6_l.w-b6.w;
    o[45].h = 600-s6_l.y-s6_l.h;
  }else{
    o[43].x = s5_r.x;
    o[43].y = b6.y+b6.w;
    o[43].w = s5_r.w;
    o[43].h = b6.h;

    o[45].x = s6_l.x;
    o[45].y = s6_l.y+s6_l.h;
    o[45].w = s6_l.w;
    o[45].h = 600-s6_l.y-s6_l.h;
  }

  o[44].x = s6_l.x+b6.w;
  o[44].y = s6.y;
  o[44].w = s6_l.w-b6.w;
  o[44].h = s6_l.y-s6.y;

  if(s3_d.x <= s6_u.x){
    o[46].x = b7.x+b7.h;
    o[46].y = b7.y-b7.h;
    o[46].w = b7.w;
    o[46].h = b7.h;

    o[48].x = 600;
    o[48].y = b7.y;
    o[48].w = b7.x-600;
    o[48].h = b7.h;

    o[49].x = s6_u.x+s6_u.w;
    o[49].y = s6_u.y;
    o[49].w = 900-s6_u.x-s6_u.w;
    o[49].h = s6_u.h;
  }else{
    o[46].x = b7.x+b7.w;
    o[46].y = b7.y;
    o[46].w = s3.x+s3.w-s3_d.x-s3_d.w;
    o[46].h = b7.h;

    o[48].x = 600;
    o[48].y = b7.y;
    o[48].w = b7.x-600;
    o[48].h = b7.h;

    o[49].x = s6_u.x+s6_u.w;
    o[49].y = s6_u.y+b7.h;
    o[49].w = 900-s6_u.x-s6_u.w;
    o[49].h = s6_u.h-b7.h;
  }

  o[47].x = s6.x;
  o[47].y = s6_u.y+b7.h;
  o[47].w = s6_u.x-s6.x;
  o[47].h = s6_u.h-b7.h;

  o[50].x = s6.x;
  o[50].y = s6.y+s6.h;
  o[50].w = s6.w;
  o[50].h = 600-s6.y-s6.h;

  o[51].x = s6.x+s6.w;
  o[51].y = s6.y;
  o[51].w = 900-s6.x-s6.w;
  o[51].h = s6.h;

  /*-----------------------------------------------
   ゴール生成(ランダム)
   -----------------------------------------------*/

  g.flag = int(random(1, 7));
  println("g:" + g.flag);
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

  /*-----------------------------------------------
   スタート生成(ランダム)
   -----------------------------------------------*/
   
  p.start = int(random(1, 7));
  while(p.start == g.flag){
    p.start = int(random(1, 7));
  }
  println("p:" + p.start);
  randomStart();
  obstacleStart();
  x0 = p.x;
  y0 = p.y;
  cnt = 0;
  
  println("ClearCount: " + ClearCount);
  println("EffectFlag: " + EffectFlag);
  println("HitCount: " + HitCount);
  
  //EffectFlag = 2;　//クリア画面の動作チェック
}
/*-----------------------------------------------
 障害物生成関数
 -----------------------------------------------*/
void obstacleStart(){
  obstacle[0].ox = s1.x*4;
  obstacle[0].oy = s1.y*4;

  obstacle[1].ox = s2.x*4 + s2.w*2;
  obstacle[1].oy = s2.y*4;

  obstacle[2].ox = s3.x*4 + s3.w*4;
  obstacle[2].oy = s3.y*4;

  obstacle[3].ox = s4.x*4;
  obstacle[3].oy = s4.y*4 + s4.h*4;

  obstacle[4].ox = s5.x*4 + s5.w*2;
  obstacle[4].oy = s5.y*4 + s5.h*4;

  obstacle[5].ox = s6.x*4 + s6.w*4;
  obstacle[5].oy = s6.y*4 + s6.w*4;
}
/*----------------------------------------------*/

/*-----------------------------------------------
 スタート位置生成関数
 -----------------------------------------------*/
void randomStart(){
  int w = 50;
  if(p.start == 1){
    p.px = s1.x*4+w;
    p.py = s1.y*4+w*2;
  }else if(p.start == 2){
    p.px = s2.x*4+w;
    p.py = s2.y*4+w*2;
  }else if(p.start == 3){
    p.px = s3.x*4+w;
    p.py = s3.y*4+w*2;
  }else if(p.start == 4){
    p.px = s4.x*4+w;
    p.py = s4.y*4+w;
  }else if(p.start == 5){
    p.px = s5.x*4+w;
    p.py = s5.y*4+w;
  }else{
    p.px = s6.x*4+w;
    p.py = s6.y*4+w;
  }
}
/*----------------------------------------------*/
/*-----------------------------------------------
 Enterキーが押された時の処理
 -----------------------------------------------*/
void keyPressed(){
  if(keyCode == ENTER){
    flag = 1;
  }
}

void keyReleased(){
  if(keyCode == ENTER){
    flag = 0;
  }
}     
/*----------------------------------------------*/
/*-----------------------------------------------
 draw関数
 -----------------------------------------------*/
void draw(){
  background(255);
  /*-----------------------------------------------
   スタート画面
   -----------------------------------------------*/
  if(EffectFlag == 0){
    //p.x = -300;
    //p.y = -300;
    e.state();
  }
  /*-----------------------------------------------
   プレイ画面設定
   -----------------------------------------------*/
  else if(EffectFlag == 1){
    /*-----------------------------------------------
   スクロール設定
   -----------------------------------------------*/
    basePos.x = (basePos.x * 0.98f + (-p.x + width/2)*0.02f);
    basePos.y = (basePos.y * 0.98f + (-p.y + height/2)*0.02f);
    translate(basePos.x, basePos.y);

    /*-----------------------------------------------
     ステージ出力
     -----------------------------------------------*/
    noStroke();
    fill(150, 200, 150);
    s1.wall();
    s2.wall();
    s3.wall();
    s4.wall();
    s5.wall();
    s6.wall();
    /*-----------------------------------------------
     通路出力
     -----------------------------------------------*/
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
    /*-----------------------------------------------
     橋出力
     -----------------------------------------------*/
    b1.wall();
    b2.wall();
    b3.wall();
    b4.wall();
    b5.wall();
    b6.wall();
    b7.wall();
    /*-----------------------------------------------
     壁-プレイヤー当たり判定
     -----------------------------------------------*/
    for(int i = 0; i < o.length; i ++){
      if(o[i].hit(p.x, p.y) == true){
        println("true:" + i);
        HitCount++;
        if(HitCount == 1){
          EffectFlag = 99;
        }
        randomStart();
      }
    }
    /*-----------------------------------------------
     ゴール判定
     -----------------------------------------------*/
    if(g.goal(p.x, p.y) == true){
      println("CLEAR");
      ClearCount++;
      setup();
      if(ClearCount >= 3){
        EffectFlag += 1;
      }
    }else{
      //check
      //println(dist(p.x, p.y, g.x, g.y));
    }

    fill(100, 100, 200);
    g.wall();

    /*-----------------------------------------------
     壁出力
     -----------------------------------------------*/
    for(int i = 0; i < o.length; i ++){
      //fill(100);
      noFill();
      //check
      if(o[i].w < 0 || o[i].h < 0){
        fill(200, 100, 100);
        print(o[i].w +" "+ o[i].h + " ");
        println(i);
      }/*else{
       fill(int(random(125)), int(random(125)), int(random(125)));
       }*/
      o[i].wall();
    }
    /*-----------------------------------------------
     障害物出力
     -----------------------------------------------*/
    for(int i = 0; i < obstacle.length; i ++){
      obstacle[i].displayObstacle();
      if(obstacle[i].hitObstacle(p.x, p.y) == true){
        println("true:" + i);
        HitCount++;
        if(HitCount == 1){
          EffectFlag = 99;
        }
        randomStart();
      }
    }
    /*-----------------------------------------------
     長エスタ圭佑出力
     -----------------------------------------------*/
    PFont font = createFont("MS Gothic", 48, true);
    textFont(font); // 選択したフォントを指定する
    fill(random(256));
    textSize(random(12*4, 36*4));
    text("長", random(width*4), random(height*4));
    text("エ", random(width*4), random(height*4));
    text("ス", random(width*4), random(height*4));
    text("タ", random(width*4), random(height*4));
    text("圭", random(width*4), random(height*4));
    text("佑", random(width*4), random(height*4));
    /*-----------------------------------------------
    プレイヤー出力
    -----------------------------------------------*/
    //p.spinPole(); 
    if(flag == 0){
      p.spinArrow();
    }else{
      p.progress();
    }
    /*-----------------------------------------------
    プレイヤーが一定範囲のステージ内にいる時の障害物
    -----------------------------------------------*/
    if(s1.hit(p.x, p.y) == true || s1_r.hit(p.x, p.y) == true ||
       s1_d.hit(p.x, p.y) == true){
       obstacle[0].obstacle(p.x, p.y);
    }else{
      obstacle[0].backObstacle(s1.x*4, s1.y*4);
    }
    if(s2.hit(p.x, p.y) == true || s2_r.hit(p.x, p.y) == true ||
       s2_d.hit(p.x, p.y) == true || s2_l.hit(p.x, p.y) == true){
       obstacle[1].obstacle(p.x, p.y);
    }else{
      obstacle[1].backObstacle(s2.x*4+s2.w*2, s2.y*4);
    }
    if(s3.hit(p.x, p.y) == true || s3_l.hit(p.x, p.y) == true ||
       s3_d.hit(p.x, p.y) == true){
       obstacle[2].obstacle(p.x, p.y);
    }else{
      obstacle[2].backObstacle(s3.x*4+s3.w*4, s3.y*4);
    }
    if(s4.hit(p.x, p.y) == true || s4_u.hit(p.x, p.y) == true ||
       s4_r.hit(p.x, p.y) == true){
       obstacle[3].obstacle(p.x, p.y);
    }else{
      obstacle[3].backObstacle(s4.x*4, s4.y*4+s4.h*4);
    }
    if(s5.hit(p.x, p.y) == true || s5_r.hit(p.x, p.y) == true ||
       s5_u.hit(p.x, p.y) == true || s5_l.hit(p.x, p.y) == true){
       obstacle[4].obstacle(p.x, p.y);
    }else{
      obstacle[4].backObstacle(s5.x*4+s5.w*2, s5.y*4+s5.h*4);
    }
    if(s6.hit(p.x, p.y) == true || s6_l.hit(p.x, p.y) == true ||
       s6_u.hit(p.x, p.y) == true){
       obstacle[5].obstacle(p.x, p.y);
    }else{
      obstacle[5].backObstacle(s6.x*4+s6.w*4, s6.y*4+s6.h*4);
    }
  }
  
  if(EffectFlag == 99){
    textSize(48);
    e.GO();
  }else if(EffectFlag == 2){
    //background(255);
    textSize(48);
    e.clearEnd();
  }
}
