class Agent {
  PVector velocity;
  PVector position;
  float speedIndex;
  float colorG;
  float colorB;

  int attack = 3 + floor(random(0, 9));
  float size = attack * 2 - 10;
  
  Agent(float positionX, float positionY, float speed) {
    position = new PVector(positionX, positionY);
    velocity = new PVector(0, 0);
    speedIndex = speed;
    colorG = random(0.0, 200.0);
    colorB = random(0.0, 60.0);
  }
  
  void display() {
    fill(110 + ((attack - 3) * 40), colorG, 0);

    noStroke();
    circle(position.x, position.y, size);
  }
  
  void updateSpeed(float newSpeed) {
    speedIndex = newSpeed;
  }
  
  void updateLocation() {
    PVector mousePosition = new PVector(mouseX, mouseY);
    PVector direction = mousePosition.sub(position);
    velocity = direction.normalize();
    velocity.x = velocity.x * speedIndex;
    velocity.y = velocity.y * speedIndex;
    for (int i = 0; i < 2; i++) {
      position.add(velocity);
    }
  }
  
  PVector getLocation() {
    return position;
  }
  
  float getSize() {
    return size;
  }
  
  
  int getAttack() {
    return attack;
  }
  
  float getColorR() {
    return 110.0 + ((attack - 3) * 40);
  }
  
  float getColorG() {
    return colorG;
  }
  
  float getColorB() {
    return colorB;
  }
}
