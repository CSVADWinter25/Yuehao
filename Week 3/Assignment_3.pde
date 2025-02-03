import controlP5.*;

ControlP5 cp5;

float speed;
int numMaxCogWheel = 100;
int number_of_wheels = 25;
int hue;
IntList cogXPositions, cogYPositions, cogSizes, directions;

void setup() {
  size(500, 500, P3D);
  cp5 = new ControlP5(this);
  cogXPositions = new IntList();
  cogYPositions = new IntList();
  cogSizes = new IntList();
  directions = new IntList();
  
  for (int i = 0; i < numMaxCogWheel; i++) {
    int currentX = floor(random(80, width - 80));
    cogXPositions.append(currentX);
    int currentY = floor(random(80, height - 80));
    cogYPositions.append(currentY);
    int currentSize = floor(random(3, 16));
    cogSizes.append(currentSize);
    int direction;
    float randDirIndex = random(0, 2);
    if (randDirIndex > 1.0) {
      direction = 1;
    } else {
      direction = -1;
    }
    directions.append(direction);
  }
  
  cp5.addSlider("speed")
     .setPosition(10, 10)
     .setRange(1, 10)
     ;
  cp5.addSlider("number_of_wheels")
     .setPosition(10, 20)
     .setRange(10, numMaxCogWheel)
     ;
  cp5.addSlider("hue")
     .setPosition(10, 30)
     .setRange(0,255)
     ;
}

void draw() {
  background(25);


  for (int i = 0; i < number_of_wheels; i++) {
     for (int j = 0; j < 4; j++) {
        pushMatrix();
        noStroke();
        //lights();
        translate(cogXPositions.get(i), cogYPositions.get(i), 0);
        rotateZ((frameCount * speed * 0.01 + j * 0.8) * directions.get(i));
        color(hue);
        box(cogSizes.get(i), cogSizes.get(i) * 5, 5);
        popMatrix();
     }
  } 
}
