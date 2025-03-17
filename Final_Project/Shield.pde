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
    pushMatrix();
    translate(position.x + size / 2, position.y + size / 2); // Center the shield

    // **Glowing Outline Effect**
    for (int i = 4; i > 0; i--) {
      float glowSize = size + i * 3;
      fill(173, 216, 230, 40 - i * 8); // Light blue glow fading out
      noStroke();
      beginShape();
      vertex(-glowSize * 0.5, -glowSize * 0.2); // Top left
      vertex(glowSize * 0.5, -glowSize * 0.2); // Top right
      vertex(glowSize * 0.3, glowSize * 0.6); // Bottom right
      vertex(0, glowSize * 0.8); // Bottom point (tip)
      vertex(-glowSize * 0.3, glowSize * 0.6); // Bottom left
      endShape(CLOSE);
    }

    // **Shield Body**
    fill(173, 216, 230); // Light blue shield color
    stroke(100, 150, 200); // Slight outline for depth
    strokeWeight(2);
    beginShape();
    vertex(-size * 0.5, -size * 0.2); // Top left
    vertex(size * 0.5, -size * 0.2); // Top right
    vertex(size * 0.3, size * 0.6); // Bottom right
    vertex(0, size * 0.8); // Bottom point (tip)
    vertex(-size * 0.3, size * 0.6); // Bottom left
    endShape(CLOSE);

    // **Center Emblem - A Smaller Triangle**
    fill(100, 150, 200); // Darker blue for contrast
    noStroke();
    beginShape();
    vertex(-size * 0.2, 0); // Top left of emblem
    vertex(size * 0.2, 0); // Top right of emblem
    vertex(0, size * 0.5); // Bottom center of emblem
    endShape(CLOSE);

    popMatrix();
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
