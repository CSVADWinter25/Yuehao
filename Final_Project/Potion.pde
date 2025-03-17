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
    pushMatrix();
    translate(position.x + size / 2, position.y + size / 2); // Center the potion

    // Glowing outline effect
    for (int i = 4; i > 0; i--) {
      float glowSize = size + i * 3;
      fill(0, 255, 0, 40 - i * 8); // Green glow fading out
      noStroke();
      square(-glowSize / 2, -glowSize / 2, glowSize);
    }

    // **Potion Body - Stack of Squares**
    fill(0, 255, 0); // Green potion color
    noStroke();
  
    float topSize = size * 0.3;  // Smallest top square (potion cap)
    float midSize = size * 0.6;  // Middle square
    float baseSize = size;       // Largest bottom square (potion body)

    // Draw squares from top to bottom
    square(-topSize / 2, -size * 0.6, topSize);    // Top part
    square(-midSize / 2, -size * 0.3, midSize);    // Middle part
    square(-baseSize / 2, 0, baseSize);           // Bottom part (largest)

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
