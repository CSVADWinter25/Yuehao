class Potion {
  PVector position;
  float size;
  boolean showing;

  
  Potion() {
    position = new PVector(random(50, width - 50), random(50, height - 50));
    size = 30;
    showing = false;
  }
  
  void display() {
    fill(0, 255, 0);
    noStroke();
    square(position.x, position.y, size);
  }

  PVector getLocation() {
    return position;
  }
  
  float getSize() {
    return size;
  }
  
  void show() {
    showing = true;
  }
  
  void hide() {
    showing = false;
  }
  
  boolean getShowing() {
    return showing;
  }
  
  void refreshPosition() {
    PVector newPosition = new PVector(random(0 + 50, width - 50), random(50, height - 50));
    position = newPosition;
  }

}
