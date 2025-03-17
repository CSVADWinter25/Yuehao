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

  
  Bullet(PVector initialPosition, float givenAngle, boolean isGoblins, 
  boolean isGoblinShielded, float R, float G, float B) {
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
    pushMatrix();  // Save transformation state
    translate(position.x, position.y);  // Move to bullet position
    float angle = atan2(velocity.y, velocity.x);  // Get the direction of movement
    rotate(angle);  // Rotate arrow to face movement direction

    if (belongGoblins) {
      if (isBlue) {
        fill(173, 216, 230); // Light blue for shielded bullets
      } else {
        fill(0, 204, 140);   // Light blue-green
      }
    } else {
      fill(colorR, colorG, colorB); // Enemy bullet color
    }
    noStroke();

    float arrowLength = size * 4; // Total arrow length
    float arrowWidth = size * 0.5; // Width of the arrow tail

    // Draw arrow body (line)
    beginShape();
    vertex(-arrowLength * 0.4, -arrowWidth * 0.5); // Left tail
    vertex(-arrowLength * 0.4, arrowWidth * 0.5);  // Right tail
    vertex(arrowLength * 0.4, arrowWidth * 0.5);  // Right head base
    vertex(arrowLength * 0.4, -arrowWidth * 0.5); // Left head base
    endShape(CLOSE);

    // Draw arrowhead (triangle)
    beginShape();
    vertex(arrowLength * 0.4, -arrowWidth * 0.7); // Left head base
    vertex(arrowLength * 0.4, arrowWidth * 0.7);  // Right head base
    vertex(arrowLength * 0.7, 0); // Arrow tip
    endShape(CLOSE);

    popMatrix();  // Restore transformation state
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
