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
  boolean blinking;
  int blinkCounter;
  
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
    blinking = false;
    blinkCounter = 0;
  }
  
  void display() {
    noStroke();
    
    // **Blinking Effect (Every 10 frames switch color)**
    if (blinking) {
      blinkCounter++;
      if (blinkCounter % 20 < 10) { // Flash red every 10 frames
        fill(0, 0, 0); 
      } else {
        fill(colorR, colorG, colorB); 
      }
    } else {
      fill(colorR, colorG, colorB);
    }

    // Draw bar with smooth transition
    for (int i = 0; i < currentLength; i++) {
      float alpha = map(i, 0, currentLength, 100, 255);
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
    
    if (ratioTillFullyCharge > 0.75) {
      blinking = true;
    } else {
      blinking = false;
      blinkCounter = 0; // Reset counter when stopping the blink
    }
    
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
