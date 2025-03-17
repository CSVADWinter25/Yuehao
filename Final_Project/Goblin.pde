class Goblin {
  PVector position;
  float size;
  int life;
  boolean isShielded;
  PShape goblinShape;
  boolean isGlowingGreen; // New flag for green glow
  int potionGlowStartFrame; // Stores when the potion was taken
  
  
  Goblin() {
    position = new PVector(mouseX, mouseY);
    life = 150;
    size = life * 0.23 + 30;
    isShielded = false;
    isGlowingGreen = false;
    potionGlowStartFrame = -1000; // Start far in the past
    goblinShape = loadShape("knight.svg");
  }
  
  void display() {
    pushMatrix();  
    translate(position.x, position.y);  

    // **Shielded Glow Effect (Blue)**
    if (isShielded) {
      for (int i = 5; i > 0; i--) {  
        float glowSize = size + i * 10;
        fill(173, 216, 230, 50 - i * 8);
        noStroke();
        ellipse(0, 0, glowSize, glowSize);
      }
    }
    
    // **Potion Glow Effect (Green)**
    if (isGlowingGreen) {
      for (int i = 5; i > 0; i--) {  
        float glowSize = size + i * 10;
        fill(0, 255, 0, 50 - i * 8); // Bright green glow
        noStroke();
        ellipse(0, 0, glowSize, glowSize);
      }
    }

    // Draw Goblin (Main Shape)
    fill(100, 100, 10);
    noStroke();
    shape(goblinShape, -size / 2, -size / 2, size, size);

    popMatrix();
  }
  
  void startPotionGlow() {
    isGlowingGreen = true;
    potionGlowStartFrame = numFrames; // Start counting
  }

  void stopPotionGlow() {
    isGlowingGreen = false;
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
      refreshSize(round(life * 0.23 + 30));
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
    refreshSize(round(life * 0.23 + 30));
  }
  
  void shield() {
    isShielded = true;
  }
  
  void unShield() {
    isShielded = false;
  }
}
