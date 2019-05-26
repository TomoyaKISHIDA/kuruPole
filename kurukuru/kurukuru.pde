class Stage{
  void wall(){
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
  size(500, 500);
  
  s = new Stage();
  p = new Player();
  e = new Effect();
}

void draw(){
  background(255);
  
}
