class Bullet {
  PVector position;
  PVector velocity;
  float size;
  float speed = 5.0;
  boolean isActive;
  boolean belongGoblins;
  boolean isBlue;
  float colorR;
  float colorG;
  float colorB;

  
  Bullet(PVector initialPosition, float givenAngle, boolean isGoblins, boolean isGoblinShielded, float R, float G, float B) {
    position = initialPosition;
    size = 8.0;
    velocity = PVector.fromAngle(givenAngle);
    velocity.mult(speed);
    
    isActive = true;
    belongGoblins = isGoblins;
    isBlue = isGoblinShielded;
    
    colorR = R;
    colorG = G;
    colorB = B;
    
  }
  
  void display() {
    if (belongGoblins) {
      if (isBlue) {
        fill(173, 216, 210);
      } else {
        fill(255, 200, 0);
      }
    } else {
      fill(colorR, colorG, colorB);
    }
    noStroke();
    circle(position.x, position.y, size);
  }
  
  void move() {
    position.add(velocity);
    if (position.x > width || position.x < 0 || position.y > height || position.y < 0) {
      isActive = false;
    }
  }
  
  void hit() {
    isActive = false;
  }
  
  PVector getLocation() {
    return position;
  }
  
  PVector getVelocity() {
    return velocity;
  }
  
  float getSize() {
    return size;
  }
  
  boolean getIsActive() {
    return isActive;
  }
  
  boolean getBelongGoblins() {
    return belongGoblins;
  }
}
