class RechargeBar {
  float maxLength;
  float currentLength;
  float colorR;
  float colorG;
  float colorB;
  float initialR;
  float initialG;
  float initialB;
  float yPos;
  boolean haveDualMode;
  boolean rechargeMode;
  
  RechargeBar(float R, float G, float B, float Y, boolean dualMode) {
    colorR = R;
    initialR = R;
    colorG = G;
    initialG = G;
    colorB = B;
    initialB = B;
    yPos = Y;
    maxLength = 100;
    currentLength = 0;
    haveDualMode = dualMode;
    rechargeMode = false;
  }
  
  void display() {
    noStroke();
    for (int i = 0; i < currentLength; i++) {
      float alpha = map(i, 0, currentLength, 100, 255); // Smooth color transition
      fill(colorR, colorG, colorB, alpha);
      rect(26 + i, yPos, 1, 10);
    }
  }
  
  void refreshColor(float newR, float newG, float newB) {
    colorR = newR;
    colorG = newG;
    colorB = newB;
  }
  
  void refreshCurrentLength(float ratioTillFullyCharge) {
    float newLength;
    if (ratioTillFullyCharge >= 1.0) {
      ratioTillFullyCharge = 1.0;
    }

    newLength = maxLength * (1.0 - ratioTillFullyCharge);
    
    if (newLength < 0) {
      newLength = 0;
    }
    currentLength = newLength;
    
    if (haveDualMode) {
      if (!rechargeMode) {
        if (newLength != maxLength) {
          rechargeMode = true;
          refreshColor(128.0, 128.0, 128.0);
        }
        
      }
      
      if (rechargeMode) {
        if (newLength == maxLength) {
          rechargeMode = false;
          refreshColor(initialR, initialG, initialB);
        }
      }
    }
    
    
  }


}
