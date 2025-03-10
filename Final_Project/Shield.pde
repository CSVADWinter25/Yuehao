class Shield {
  PVector position;
  float size;
  boolean showing;

  
  Shield() {
    position = new PVector(random(50, width - 50), random(50, height - 50));
    size = 30;
    showing = false;
  }
  
  void display() {
    fill(173, 216, 210);
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
