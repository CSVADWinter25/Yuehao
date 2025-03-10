class Goblin {
  PVector position;
  float size;
  int life;
  boolean isShielded;
  
  Goblin() {
    position = new PVector(mouseX, mouseY);
    life = 150;
    size = life * 0.33;
    isShielded = false;
  }
  
  void display() {
    if (!isShielded) {
      fill(255, 200, 0);
    } else {
      fill(173, 216, 210);
    }
    noStroke();
    circle(position.x, position.y, size);
    
    //size((int)size, (int)size, P3D);
    //noStroke();
    //lights();
    //translate(position.x, position.y, 0);
    //sphere(size);
    
  }
  
  void updateLocation() {
    PVector mousePosition = new PVector(mouseX, mouseY);
    position = mousePosition;
  }
  
  int getLife() {
    return life;
  }
  
  PVector getLocation() {
    return position;
  }
  
  float getSize() {
    return size;
  }
  
  boolean getIsShielded() {
    return isShielded;
  }
  
  void getHit(int attack) {
    if (!isShielded) {
      life -= attack;
      refreshSize(round(life * 0.33));
    }
  }
  
  void refreshSize(int newSize) {
    size = newSize;
  }
  
  void heal(int healAmount) {
    life += healAmount;
    if (life > 150) {
      life = 150;
    }
    refreshSize(round(life * 0.33));
  }
  
  void shield() {
    isShielded = true;
  }
  
  void unShield() {
    isShielded = false;
  }
  
  

}
