import processing.sound.*;

class Agent {
  PVector velocity;
  PVector position;
  float speedIndex;
  float colorG;
  float colorB;
  int attack;
  float size;
  
  SinOsc osc;
  float agentAmplitude = 0.02;
  int lastToneChange = 0;
  
  PApplet parent;
  
  Agent(float positionX, float positionY, float speed, PApplet p) {
    parent = p;
    position = new PVector(positionX, positionY);
    velocity = new PVector(0, 0);
    speedIndex = speed;
    attack = 3 + floor(random(0, 9));
    size = attack * 2 - 10;
    
    colorG = random(0.0, 200.0);
    colorB = random(0.0, 60.0);
    
    osc = new SinOsc(parent);
    osc.amp(agentAmplitude);
    changeTone();
    osc.play();
  }
  
  void changeTone() {
    int chordIndex = currentChord;
    int noteIndex = floor(random(0, 5));
    float baseFreq = chords[chordIndex][noteIndex];
    float octaveMultiplier = map(attack, 3, 12, 2.0, 0.5);
    osc.freq(baseFreq * octaveMultiplier);
  }
  
  void stopSound() {
    osc.stop();
  }
  
  void display() {
    pushMatrix(); // Save transformation state
    translate(position.x, position.y); // Move to agent position

    // **Bubble Body (Main Circle)**
    fill(110 + ((attack - 3) * 40), colorG, 0, 180); // Semi-transparent color
    noStroke();
    circle(0, 0, size);

    // **Inner Highlight (White Circle)**
    float highlightSize = size * 0.3; // Smaller highlight circle
    PVector highlightOffset = velocity.copy().setMag(size * 0.2); // Position based on velocity
  
    fill(255, 255, 255, 200); // White highlight
    circle(highlightOffset.x, highlightOffset.y, highlightSize);

    popMatrix(); // Restore transformation state
  }

  
  void updateSpeed(float newSpeed) {
    speedIndex = newSpeed;
  }
  
  void updateLocation() {
    PVector mousePosition = new PVector(mouseX, mouseY);
    PVector direction = mousePosition.copy().sub(position);
    velocity = direction.normalize(); // Move toward the Goblin
  
    // Adjust speed: Lower attack → Faster movement
    float speedMultiplier = map(attack, 3, 12, 1.5, 0.8); // Scale speed (weaker enemies move faster)
    float adjustedSpeed = speedIndex * speedMultiplier;

    // Wavy movement parameters
    float waveFrequency = 0.5 + 0.1 * (12 - attack) + adjustedSpeed * 0.6; // Hz
    float waveAmplitude = attack + adjustedSpeed * 0.6; // How wide the wavy motion is
    float waveOffset = sin(TWO_PI * waveFrequency * (numFrames / 60.0)) * waveAmplitude;

    // Determine the perpendicular direction
    PVector perpendicular = new PVector(-velocity.y, velocity.x);
  
    // Apply the wavy movement in the perpendicular direction
    position.add(velocity.copy().mult(adjustedSpeed)); // Move forward with adjusted speed
    position.add(perpendicular.mult(waveOffset * 0.02)); // Add wavy offset
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
