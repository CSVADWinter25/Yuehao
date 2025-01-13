void setup() {
  size(600, 600);
  int canvasSize = 600;
  int faceSize = 350;

  background(255);
  
  // Draw the outline of the faces, body, and arms
  fill(255, 255, 70);
  ellipse(canvasSize / 2, (canvasSize / 2) + 300, faceSize * 0.8, faceSize); // (x, y, width, height)
  fill(255, 255, 100);
  ellipse((canvasSize / 2) - 2, (canvasSize / 2) + 302, faceSize * 0.8 - 5, faceSize - 5); // (x, y, width, height)
  fill(255, 255, 130);
  ellipse((canvasSize / 2) - 4, (canvasSize / 2) + 304, faceSize * 0.8 - 10, faceSize - 10); // (x, y, width, height)
  fill(255, 255, 160);
  ellipse((canvasSize / 2) - 6, (canvasSize / 2) + 306, faceSize * 0.8 - 15, faceSize - 15); // (x, y, width, height)
  fill(255, 255, 190);
  ellipse((canvasSize / 2) - 8, (canvasSize / 2) + 308, faceSize * 0.8 - 20, faceSize - 20); // (x, y, width, height)
  fill(255, 255, 240);
  ellipse((canvasSize / 2) - 8, (canvasSize / 2) + 308, faceSize * 0.4, faceSize * 0.6); // (x, y, width, height)
  
  fill(255, 255, 50);
  ellipse((canvasSize / 2) - 180, (canvasSize / 2) + 170, faceSize * 0.6, faceSize * 0.2); // (x, y, width, height)
  fill(255, 255, 100);
  ellipse((canvasSize / 2) - 182, (canvasSize / 2) + 172, faceSize * 0.6 - 5, faceSize * 0.2 - 5); // (x, y, width, height)
  fill(255, 255, 140);
  ellipse((canvasSize / 2) - 184, (canvasSize / 2) + 174, faceSize * 0.6 - 10, faceSize * 0.2 - 10); // (x, y, width, height)
  fill(255, 255, 170);
  ellipse((canvasSize / 2) - 186, (canvasSize / 2) + 176, faceSize * 0.6 - 15, faceSize * 0.2 - 15); // (x, y, width, height)
 
  fill(255, 255, 50);
  ellipse((canvasSize / 2) + 186, (canvasSize / 2) + 170, faceSize * 0.6, faceSize * 0.2); // (x, y, width, height)
  fill(255, 255, 100);
  ellipse((canvasSize / 2) + 184, (canvasSize / 2) + 172, faceSize * 0.6 - 5, faceSize * 0.2 - 5); // (x, y, width, height)
  fill(255, 255, 140);
  ellipse((canvasSize / 2) + 182, (canvasSize / 2) + 174, faceSize * 0.6 - 10, faceSize * 0.2 - 10); // (x, y, width, height)
  fill(255, 255, 170);
  ellipse((canvasSize / 2) + 180, (canvasSize / 2) + 176, faceSize * 0.6 - 15, faceSize * 0.2 - 15); // (x, y, width, height)

  
  fill(255, 255, 50);
  ellipse(canvasSize / 2, canvasSize / 2, faceSize, faceSize); // (x, y, width, height)
  fill(255, 255, 80);
  ellipse((canvasSize / 2) - 2, (canvasSize / 2) + 2, faceSize - 5, faceSize - 5); // (x, y, width, height)
  fill(255, 255, 110);
  ellipse((canvasSize / 2) - 4, (canvasSize / 2) + 4, faceSize - 10, faceSize - 10); // (x, y, width, height)
  fill(255, 255, 140);
  ellipse((canvasSize / 2) - 6, (canvasSize / 2) + 6, faceSize - 15, faceSize - 15); // (x, y, width, height)
  fill(255, 255, 160);
  ellipse((canvasSize / 2) - 8, (canvasSize / 2) + 8, faceSize - 20, faceSize - 20); // (x, y, width, height)
  fill(255, 255, 180);
  ellipse((canvasSize / 2) - 10, (canvasSize / 2) + 10, faceSize - 25, faceSize - 25); // (x, y, width, height)
  
  
  // Draw the eyes, nose and mouse
  noStroke();
  
  fill(255, 255, 255);
  ellipse(210, 270, 90, 90);
  fill(144, 238, 144);
  ellipse(214, 274, 80, 80);
  fill(24, 40, 24);
  ellipse(218, 278, 70, 70);
  fill(235, 235, 255);
  ellipse(218, 245, 16, 16);
  
  fill(255, 255, 255);
  ellipse(390, 270, 90, 90);
  fill(144, 238, 144);
  ellipse(386, 274, 80, 80);
  fill(24, 40, 24);
  ellipse(382, 278, 70, 70);
  fill(235, 235, 255);
  ellipse(382, 245, 16, 16);
  
  fill(0, 0, 0);
  triangle(300, 320, 279, 330, 321, 330);
  
  fill(255, 192, 203);
  ellipse(300, 380, 130, 65);
  fill(255, 255, 180);
  rect(220, 330, 200, 30);
  fill(255, 255, 255);
  rect(250, 355, 100, 5);

}
