class Agent {
  PVector velocity;
  PVector position;
  float speedIndex;

  int attack = 10 + floor(random(0, 10));
  float size = attack * 2 - 10;
  
  Agent(float positionX, float positionY, float speed) {
    position = new PVector(positionX, positionY);
    velocity = new PVector(0, 0);
    speedIndex = speed;
  }
  
  void display() {
    fill(80 + ((attack - 10) * 17.5), 0, 0);
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
}
