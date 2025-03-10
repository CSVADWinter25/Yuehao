class RechargeBar {
  float maxLength;
  float currentLength;
  float colorR;
  float colorG;
  float colorB;
  float yPos;
  
  RechargeBar(float R, float G, float B, float Y) {
    colorR = R;
    colorG = G;
    colorB = B;
    yPos = Y;
    maxLength = 100;
    currentLength = 0;
  }
  
  void display() {
    fill(colorR, colorG, colorB);
    noStroke();
    rect(26, yPos, currentLength, 10);
  }
  
  void refreshCurrentLength(float ratioTillFullyCharge) {
    float newLength = maxLength * (1.0 - ratioTillFullyCharge);
    if (newLength < 0) {
      newLength = 0;
    }
    currentLength = newLength;
    
  }


}
