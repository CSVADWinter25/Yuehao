void setup() {
  size(500, 500);
  background(50);
  stroke(0);
}


void draw() {
  if (mousePressed) {
    float w = map(sin(frameCount * 0.1), -1, 1, 1, 20);
    float s1 = map(sin(frameCount * 0.1), -1, 1, 100, 0);
    float s2 = map(cos(frameCount * 0.1), -1, 1, 100, 0);
    stroke(200 - s1, s2 * 0.5, s2 * 0.6);
    strokeWeight(w);
    
    // Draw the original line
    drawSymmetricLine(mouseX, mouseY, pmouseX, pmouseY);
    
    // Calculate the center point
    float centerX = width / 2.0;
    float centerY = height / 2.0;
    
    // Calculate offsets from the center
    float offsetX = mouseX - centerX;
    float offsetY = mouseY - centerY;
    float prevOffsetX = pmouseX - centerX;
    float prevOffsetY = pmouseY - centerY;

    // Draw the remaining 7 symmetric lines
    for (int i = 1; i < 8; i++) {
      float angle = TWO_PI / 8.0 * i; // Rotate by 45 degrees
      float rotatedX = centerX + cos(angle) * offsetX - sin(angle) * offsetY;
      float rotatedY = centerY + sin(angle) * offsetX + cos(angle) * offsetY;
      float rotatedPrevX = centerX + cos(angle) * prevOffsetX - sin(angle) * prevOffsetY;
      float rotatedPrevY = centerY + sin(angle) * prevOffsetX + cos(angle) * prevOffsetY;

      drawSymmetricLine(rotatedX, rotatedY, rotatedPrevX, rotatedPrevY);
    }
  }
}

void drawSymmetricLine(float x, float y, float px, float py) {
  // Draw lines for one channel and its reflection
  line(x, y, px, py);                           // Original line
  line(width - x, y, width - px, py);           // Horizontal symmetry
  line(x, height - y, px, height - py);         // Vertical symmetry
  line(width - x, height - y, width - px, height - py); // Full center symmetry
}
