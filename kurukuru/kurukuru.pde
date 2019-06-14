class Stage{
  void wall(int pw, int ph){
    rect( int(random(40))+pw, int(random(40))+ph, int(random(150))+80, int(random(150))+80);
  }
  
  void obstacle(){
  }
  
  int makeRandom(){
    int n = 0;
    return n;
  }
  
  boolean hit(){
    return true;
  }
  
  boolean goal(){
    return true;
  }
}

class Player{
  void spinPole(){
  }
  
  void spinArrow(){
  }
  
  void progress(){
  }
}

class Effect{
  void startScreen(){
  }
  
  void playScreen(){
  }
  
  void resultScreen(){
  }
}

Stage s;
Player p;
Effect e;

void setup(){
  size(900, 600);
  
  s = new Stage();
  p = new Player();
  e = new Effect();
    
  fill(255, 0, 0);
  rect(0, 0, 300, 300);
  
  fill(0, 255, 0);
  rect(300, 0, 300, 300);
  
  fill(0, 0, 255);
  rect(600, 0, 300, 300);
  
  fill(255, 255, 0);
  rect(0, 300, 300, 300);
  
  fill(255, 0, 255);
  rect(300, 300, 300, 300);
  
  fill(0, 255, 255);
  rect(600, 300, 300, 300);
  
  fill(0);
  s.wall(30, 30);
  s.wall(330, 30);
  s.wall(630, 30);
  s.wall(30, 330);
  s.wall(330, 330);
  s.wall(630, 330);
}

void draw(){
  
}
