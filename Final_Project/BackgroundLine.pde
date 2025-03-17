class BackgroundLine {
  PVector start, end;
  float angle;
  color baseColor = color(30); // Default dim gray
  color currentColor;
  int flashFrames = 0; // Controls flashing effect
  boolean blinking = false; // Tracks blinking mode
  int blinkCounter = 0; // Counts blinks

  BackgroundLine() {
    // **Generate a random point INSIDE the canvas**
    float x1 = random(width);
    float y1 = random(height);
    angle = random(TWO_PI); // Random orientation
    
    float lineLength = max(width, height) * 1.5; // **Lines are very long now!**

    // **Extend the line beyond the canvas**
    PVector direction = PVector.fromAngle(angle).mult(lineLength);
    start = new PVector(x1 - direction.x * 0.5, y1 - direction.y * 0.5);
    end = new PVector(x1 + direction.x * 0.5, y1 + direction.y * 0.5);
    
    currentColor = baseColor; // Start with dim gray
  }

  void display() {
    stroke(currentColor);
    strokeWeight(2);
    line(start.x, start.y, end.x, end.y);
  }

  void update() {
    // Gradually fade back to dim gray
    if (!blinking) {
      currentColor = lerpColor(currentColor, baseColor, 0.1);
    }

    // Handle blinking effect
    if (blinking) {
      if (blinkCounter % 10 < 5) {
        currentColor = color(255); // Bright flash
      } else {
        currentColor = baseColor; // Back to dim gray
      }
      blinkCounter++;
      if (blinkCounter > 20) { // Blink twice (2 fast cycles)
        blinking = false;
        blinkCounter = 0;
      }
    }

    flashFrames = max(0, flashFrames - 1); // Reduce flash duration
  }

  void flashBright() {
    currentColor = color(220); // Bright white flash when shooting
    flashFrames = 10;
  }

  void turnColorful() {
    currentColor = color(random(100, 255), random(100, 255), random(100, 255)); // Vibrant colors
  }

  void blink() {
    blinking = true;
    blinkCounter = 0;
  }
}
