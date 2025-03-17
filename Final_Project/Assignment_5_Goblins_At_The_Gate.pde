
// Goblin At the Gate
// How to survive in front of a giant flock of enemies
// Yuehao Gao
// Redesigned from class example


// HOW TO PLAY THIS GAME: 
// - survive for longer, dodge the enemies and their bullets
// - there are obstacles appearing, so dodge them while avoiding the enemies
// - shoot enimies by clicking the mouse
//   it is available every 3 second, unless being "shielded", which enable unlimited shooting
// - crash enimies when shielded (after picking up the blue shield)
//   shooting ability will be increased
// - pick up potions (green bottle) to regain hp values



// Change the background to dynamic
// SUPER MUSIC
// glow to red when being hit





// The sound package ----------------------------------------------
import processing.sound.*;

ArrayList<SinOsc> sineOscs = new ArrayList<SinOsc>();
                           // SATB Sine oscillators
Reverb reverb;             // Reverb effect
int measureDuration;       // The amount of frame per measure (2 seconds, 120 frames)

// Chordal Progression
float[][] chords = {

  {98.00, 196.00, 392.00, 466.16, 587.33},    // G minor
  {77.78, 196.00, 392.00, 466.16, 622.25},    // Eb major
  {116.54, 233.08, 349.23, 466.16, 587.33},   // Bb major
  {87.31, 220.0, 349.23, 440.0, 523.25},      // F major
  {130.81, 261.62, 311.12, 392.00, 523.25},   // C minor
  {98.00, 196.00, 293.67, 392.00, 466.16},    // G minor
  {110.0, 277.18, 329.63, 392.00, 466.16},    // A minor7q
  {73.416, 293.67, 369.99, 440.0, 587.33}     // D major

};


int currentChord = 0; // 0 = G minor, 1 = F major
boolean isPlaying = true; // Tracks whether the chord is playing or silent
int lastSwitchTime = 0; // Stores when the last switch happened


// All characters --------------------------------------------
Goblin goblin;
Potion potion;
Shield shield;
RechargeBar lbBar;
RechargeBar sdBar;
RechargeBar hpBar;
ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Agent> agentsToRemove = new ArrayList<Agent>();
ArrayList<Bullet> goblinBullets = new ArrayList<Bullet>();
ArrayList<Bullet> goblinBulletsToRemove = new ArrayList<Bullet>();
ArrayList<Bullet> agentBullets = new ArrayList<Bullet>();
ArrayList<Bullet> agentBulletsToRemove = new ArrayList<Bullet>();
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();


// All parameters ------------------------------------
boolean gameRunning;
boolean isPaused;
boolean needClearing;
boolean superMode;
int survivedTime;
int score;
int initialNumAgent = 60;
int numAgent;
float agentSpeed;
int numFrames;
int newAgentFrameCount;              // A new agent will join the game every 4 seconds
int initialMargin = 10;              // The margin of each enemy agent outside the canvas when appearing
int harderFrameCount = 360;          // The game becomes harder every 6 seconds
                                     // including agents' speed and refresh rate
                                     // limiting at 0.5 second / new agent
int newPotionCount;                  // Potion refreshes every 12 seconds at first
                                     // Then shortened all the way to 9 seconds
int newShieldCount;                  // Shield refreshes every 20 seconds
                                     // Then shortened all the way to 12 seconds
int takeShieldFrame = 0;
int numGoblinBullet;
int numNormalGoblinBullet;
int numShieldedGoblinBullet;
int obstacleSpawnTime = 900;         // Obstacles start appearing 15 seconds after game start
int lastObstacleSpawnFrame = -1000;  // Ensures the first obstacle appears correctly
int shieldDuration = 120;            // Shield lasts for 2 seconds
int lastPickShieldFrame = -2200;
float shieldRechargeRatio = 0.0;
int lastShootFrame = -180;
int shootingInterval = 180;
float shootingRechargeRatio = 1.0;
int lastAgentShootFrame = 500;
int agentShootInterval = 300;


// Background ------------------------------------
ArrayList<BackgroundLine> bgLines = new ArrayList<BackgroundLine>();



// --------------------------------------------------
void setup() {
  background(0);
  bgLines.clear();
  gameRunning = true;
  isPaused = false;
  needClearing = false;
  survivedTime = 0;
  score = 0;
  numFrames = 0;
  agentSpeed = 0.25;
  newShieldCount = 1200;
  newAgentFrameCount = 240;
  newPotionCount = 720;
  
  shieldRechargeRatio = 0.0;
  shootingRechargeRatio = 1.0;
  lastShootFrame = -180;
  lastPickShieldFrame = -200;
  numNormalGoblinBullet = 5;
  numShieldedGoblinBullet = 3 * numGoblinBullet;
  numGoblinBullet = numNormalGoblinBullet;
  
  obstacles.clear();
  lastObstacleSpawnFrame = numFrames;
  
  // Initialize the "Goblin" and "enemy agents"
  goblin = new Goblin();
  potion = new Potion();
  shield = new Shield();
  hpBar = new RechargeBar(255.0, 0.0, 0.0, 85.0, false);
  lbBar = new RechargeBar(0.0, 204.0, 140.0, 95.0, true);
  sdBar = new RechargeBar(173.0, 216.0, 210.0, 105.0, false);
  numAgent = initialNumAgent;
  for (int i = 0; i < initialNumAgent; i++) {
    Agent oneNewAgent = newAggentAppear(agentSpeed);
    agents.add(oneNewAgent);
  }

  size(1000, 700);
  textSize(24);
  
  // Sound initialization -----------------------------
  // Initialize oscillators
  for (SinOsc osc : sineOscs) {
    osc.stop(); // Stop old oscillators
  }
  sineOscs.clear(); // Empty the list before adding new ones
  
  for (int i = 0; i < 5; i++) {
    SinOsc newOscillator = new SinOsc(this);
    newOscillator.amp(0.03);
    sineOscs.add(newOscillator);
  }
  

  // Initialize reverb
  reverb = new Reverb(this);
  for (SinOsc oneSineOsc : sineOscs) {
    reverb.process(oneSineOsc);
  }
  reverb.room(0.7);
  reverb.damp(0.6);

  // Start with the first chord
  currentChord = 0; // Reset chord index
  playChord(chords[currentChord]);
  lastSwitchTime = millis();
  
  
  // Generate multiple random background lines
  for (int i = 0; i < 20; i++) {  // **More lines for a denser background**
    bgLines.add(new BackgroundLine());
  }
}


// --------------------------------------------------
// At every frame of the game
void draw() {
  
  noCursor();
  
  // Display background lines
  for (BackgroundLine line : bgLines) {
    line.update();
    line.display();
  }

  // The first things to display are the texts
  if (gameRunning) {
    
    int elapsed = millis() - lastSwitchTime;

    if (isPlaying && elapsed >= 1500) { // Play chord for 1.5s
      //stopChord(); // Silence for 0.5s
      isPlaying = false;
      lastSwitchTime = millis();
    } 
    else if (!isPlaying && elapsed >= 500) { // Silence for 0.5s passed
      currentChord = (currentChord + 1) % 8; // Switch between G minor (0) and F major (1)
      playChord(chords[currentChord]);
      isPlaying = true;
      lastSwitchTime = millis();
    }
    
    if (isPaused) {
      return;
    }
    
    float lifeRatio = 1.0 - ((float) goblin.getLife() / 150.0); // Max life is 150
    hpBar.refreshCurrentLength(lifeRatio);
    hpBar.display();
    
    fill(255);
    text("Life: " + goblin.getLife(), 25, 30);
    text("Press Space to Pause", 25, 140);
    text("Time lapsed: " + survivedTime + "s", 25, 50);
    text("Your score: " + score, 25, 70);
    
    hpBar.display();
  } else {
    fill(255, 0, 255);
    text("GAME OVER", width / 2 - 60, height / 2);
    text("Time lapsed: " + survivedTime + "s", width / 2 - 70, height / 2 + 20);
    text("Your Score: " + score, width / 2 - 70, height / 2 + 40);
    fill(255, 0, 5);
    text("Press Space To Restart", width / 2 - 105, height / 2 + 80);
  }
  
  // Then the shadow of the previous frame
  fill(0, 27);
  rect(0, 0, width, height);
  
  
  // If the game is still running (not lost)
  if (gameRunning) {
    // Count add one for frame (so the first frame will be counted as "1")
    numFrames++;
   
    if (numFrames % 60 == 0) {
      survivedTime ++;
    }
  
    // If it is time to add new enemy agent, do that
    if (numFrames % newAgentFrameCount == 0) {
      Agent oneNewAgent = newAggentAppear(agentSpeed);
      agents.add(oneNewAgent);
    }
    
    // If it is time to add new obstacle, do that
    if (numFrames >= obstacleSpawnTime && (numFrames - lastObstacleSpawnFrame) >= 600) {
        obstacles.add(new Obstacle());
        lastObstacleSpawnFrame = numFrames;
    }
  
    // If it is time to become harder, do that
    if (numFrames % harderFrameCount == 0) {
      if (agentSpeed <= 3.5) {
        agentSpeed *= 1.2;
      }
      for (Agent oneAgent : agents) {
        oneAgent.updateSpeed(agentSpeed);
      }
      if (newAgentFrameCount >= 30) {
        newAgentFrameCount -= 15;
      }
      if (newShieldCount >= 540) {
        newShieldCount -= 15;
      }
      if (newPotionCount >= 540) {
        newPotionCount -= 30;
      }
      if (newShieldCount >= 720) {
        newShieldCount -= 30;
      }
      numNormalGoblinBullet += 1;
      numShieldedGoblinBullet += 3;
    }
    
    // If it is time to refresh a new potion, do that
    if (numFrames % newPotionCount == 0) {
      if (!potion.getShowing()) {
        potion.show();
      }
    }
    
    // If it is time to refresh a new potion, do that
    if (numFrames % newShieldCount == 0) {
      if (!shield.getShowing()) {
        shield.show();
      }
    }
    
    // If it is time for an enemy to shoot, do that
    if (numFrames > lastAgentShootFrame + agentShootInterval) {
      
      ArrayList<Agent> dangerousAgents = new ArrayList<Agent>();
      for (Agent a : agents) {
        if (a.getSize() > 8) {
          dangerousAgents.add(a);
        }
      }
      
      // Pick one "dangerous" agent to do that shooting work
      int shooter = floor(random(0, dangerousAgents.size()));
      if (dangerousAgents.size() > 0) {
        for (int i = 0; i < 10; i++) {
          float angle = TWO_PI / 10 * i;
          //agent shootingAgent = dangerousAgents.get(shooter);
          agentBullets.add(new Bullet(dangerousAgents.get(shooter).getLocation().copy(), angle, false, false, dangerousAgents.get(shooter).getColorR(), dangerousAgents.get(shooter).getColorG(), dangerousAgents.get(shooter).getColorB()));
        }
      }
      
      lastAgentShootFrame = numFrames;
      
      playShootingSound();
      
      if (agentShootInterval > 180) {
        agentShootInterval -= 5;
      }
    }
  
    // Check if the goblin collides with any agent
    for (Agent oneAgent : agents) {
      if (isColliding(oneAgent)) {
        collide(oneAgent);
        if (goblin.getIsShielded()) {
          score += oneAgent.getAttack() * 100;
        }
      }
    }
    
    // Check if the goblin picks up the potion
    PVector potionPosition = potion.getLocation();
    PVector goblinPosition = goblin.getLocation();
    float potionPosX = potionPosition.x + potion.getSize() / 2.0;
    float potionPosY = potionPosition.y + potion.getSize() / 2.0;
    float goblinPosX = goblinPosition.x;
    float goblinPosY = goblinPosition.y;
    float distance = sqrt(pow((potionPosX - goblinPosX), 2) + pow((potionPosY - goblinPosY), 2));
    boolean takingPotion = (distance < goblin.getSize() + potion.getSize());
    if (takingPotion && potion.getShowing()) {
      goblin.heal(20);
      potion.hide();
      potion.refreshPosition();
      takingPotion = false;
      goblin.startPotionGlow(); // Trigger green glow!
    }
    
    // Check if the goblin picks up the shield
    PVector shieldPosition = shield.getLocation();
    float shieldPosX = shieldPosition.x + potion.getSize() / 2.0;
    float shieldPosY = shieldPosition.y + potion.getSize() / 2.0;
    float distanceToShield = sqrt(pow((shieldPosX - goblinPosX), 2) + pow((shieldPosY - goblinPosY), 2));
    boolean takingShield = (distanceToShield < shield.getSize() + potion.getSize());
    if (takingShield && shield.getShowing()) {
      lastPickShieldFrame = numFrames;
      goblin.shield();
      numGoblinBullet = numShieldedGoblinBullet;
      takeShieldFrame = numFrames;
      shield.hide();
      takingShield = false;
      shieldRechargeRatio = 0.0;
      sdBar.refreshCurrentLength(shieldRechargeRatio);

      // **Make background lines colorful**
      for (BackgroundLine line : bgLines) {
        line.turnColorful();
      }
    }
    
    // Check if the shield expires
    if (numFrames >= takeShieldFrame + shieldDuration && !superMode) {
      goblin.unShield();
      numGoblinBullet = numNormalGoblinBullet;
    }
  
    // Handle the location update and displaying of all characters
    goblin.updateLocation();
    
    // **Stop potion glow after 1 second**
    if (goblin.isGlowingGreen && numFrames >= goblin.potionGlowStartFrame + 60) {
      goblin.stopPotionGlow(); // Stop glowing after 60 frames (1 second)
    }
  
  
    goblin.display();
    
    // Display the recharge bars
    shootingRechargeRatio = 1 - ((float)(numFrames - lastShootFrame) / (float)shootingInterval);
    
    if (shootingRechargeRatio < 0.0) {
      shootingRechargeRatio = 0.0;
    }
    
    if (shootingRechargeRatio > 1.0) {
      shootingRechargeRatio = 1.0;
    }
    
    lbBar.refreshCurrentLength(shootingRechargeRatio);
    lbBar.display();
    
    shieldRechargeRatio = (float)(numFrames - lastPickShieldFrame) / (float)shieldDuration;
    sdBar.refreshCurrentLength(shieldRechargeRatio);
    sdBar.display();
    
    if (potion.getShowing()) {
      potion.display();
    }
    
    if (shield.getShowing()) {
      shield.display();
    }
    
    for (Obstacle obs : obstacles) {
      obs.display();
    }
    
    for (Agent oneAgent : agents) {
      oneAgent.updateLocation();
      oneAgent.display();
    }
    
    for (Bullet gb : goblinBullets) {
      if (gb.getIsActive()) {
        gb.move();
        gb.display();
        
        // See if it hits any agents
        for (Agent a : agents) {
          if (isBulletHittingAgent(gb, a)) {
            gb.hit();
            a.stopSound();
            agentsToRemove.add(a);
            score += a.getAttack() * 50;
          }
        }
      }
      if (!gb.getIsActive()) {
        goblinBulletsToRemove.add(gb);
      }
    }
    
    for (Bullet ab : agentBullets) {
      if (ab.getIsActive()) {
        ab.move();
        ab.display();

        if (isBulletHittingGoblin(ab)) {
          ab.hit();
          if (!goblin.getIsShielded()) {
            goblin.getHit(20);
          }
        }
        
      }
      if (!ab.getIsActive()) {
        agentBulletsToRemove.add(ab);
      }
    }
    
    // Remove the agents that are hit by the goblin
    for (Agent oneAgentToRemove : agentsToRemove) {
      agents.remove(oneAgentToRemove);
    }
    agentsToRemove.clear();
    
    // Remove dead bullets
    for (Bullet oneGBToRemove : goblinBulletsToRemove) {
      goblinBullets.remove(oneGBToRemove);
    }
    goblinBulletsToRemove.clear();
    for (Bullet oneABToRemove : agentBulletsToRemove) {
      agentBullets.remove(oneABToRemove);
    }
    agentBulletsToRemove.clear();
    
    if (goblin.getLife() <= 0) {
      gameRunning = false;
      needClearing = true;
    }
  } else {
    
    // Stop all the Sine oscillators and the grannular sounds
    for (SinOsc oneSineOsc : sineOscs) {
      oneSineOsc.stop();
    }
    
    for (Agent a : agents) {
      a.stopSound();
    }
    
    
    if (needClearing) {
      agents.clear();
      agentsToRemove.clear();
      goblinBullets.clear();
      goblinBulletsToRemove.clear();
      agentBullets.clear();
      agentBulletsToRemove.clear();
      
      numFrames = 0;
      
      needClearing = false;
    }
  }
}


// To add a new ememy agent to the game
Agent newAggentAppear(float speed) {
    float initialMarginIndex = random(0.0, 4.0);
    float newAgentInitialX = 0.0;
    float newAgentInitialY = 0.0;
    
    // 1/4 probability of appearing from top
    if (initialMarginIndex < 1.0) {
      newAgentInitialX = random(0.0, width);
      newAgentInitialY = -1 * initialMargin;
    }
    // 1/4 probability of appearing from right
    else if (initialMarginIndex >= 1.0 && initialMarginIndex < 2.0) {
      newAgentInitialX = width + initialMargin;
      newAgentInitialY = random(0.0, height);
    }
    // 1/4 probability of appearing from bottom
    else if (initialMarginIndex >= 1.0 && initialMarginIndex < 2.0) {
      newAgentInitialX = random(0.0, width);
      newAgentInitialY = height + initialMargin;
    }
    // 1/4 probability of appearing from left
    else {
      newAgentInitialX = -1 * initialMargin;
      newAgentInitialY = random(0.0, height);
    }
    
  Agent newAgent = new Agent(newAgentInitialX, newAgentInitialY, speed, this);
  return newAgent;
}



// To tell if the goblin collides with an agent
boolean isColliding(Agent theAgent) {
  boolean answer = false;
  
  PVector GoblinLocation = goblin.getLocation();
  PVector AgentLocation = theAgent.getLocation();
  float goblinSize = goblin.getSize();
  float agentSize = theAgent.getSize();
  
  float radiusSum = goblinSize * 0.5 + agentSize * 0.5;
  if (radiusSum > PVector.dist(GoblinLocation, AgentLocation)) {
    answer = true;
  }
  return answer;
}



// To tell if the goblin collides with an agent
boolean isBulletHittingAgent(Bullet b, Agent theAgent) {
  boolean answer = false;
  
  PVector bulletLocation = b.getLocation();
  PVector AgentLocation = theAgent.getLocation();
  float bulletSize = b.getSize();
  float agentSize = theAgent.getSize();
  
  float radiusSum = bulletSize * 0.5 + agentSize * 0.5;
  if (radiusSum > PVector.dist(bulletLocation, AgentLocation)) {
    answer = true;
  }
  return answer;
}


// To tell if the goblin collides with goblin
boolean isBulletHittingGoblin(Bullet b) {
  boolean answer = false;
  
  PVector bulletLocation = b.getLocation();
  PVector goblinLocation = goblin.getLocation();
  float bulletSize = b.getSize();
  float goblinSize = goblin.getSize();
  
  float radiusSum = bulletSize * 0.5 + goblinSize * 0.5;
  if (radiusSum > PVector.dist(bulletLocation, goblinLocation)) {
    answer = true;
  }
  return answer;
}



// If the Goblin collides with an agent
void collide(Agent theAgent) {
  goblin.getHit(theAgent.getAttack());
  agentsToRemove.add(theAgent);
  theAgent.stopSound();
}



// To shoot
void mousePressed() {
  // Check if it's time to shoot or if the Goblin is shielded
  if (numFrames >= lastShootFrame + shootingInterval || goblin.getIsShielded()) {
    shootingRechargeRatio = 0.0;
    lbBar.refreshCurrentLength(shootingRechargeRatio);
    
    for (int i = 0; i < numGoblinBullet; i++) {
      float angle = TWO_PI / numGoblinBullet * i;
      goblinBullets.add(new Bullet(goblin.getLocation().copy(), angle, true, goblin.getIsShielded(), 0.0, 0.0, 0.0));
    }
    lastShootFrame = numFrames;
    
    playShootingSound();

    // **Flash background lines when shooting**
    for (BackgroundLine line : bgLines) {
      line.flashBright();
    }

    // **Blink background lines when shielded & shooting**
    if (goblin.getIsShielded()) {
      for (BackgroundLine line : bgLines) {
        line.blink();
      }
    }
  }
  else {
    fill(255, 200, 0);
    text("RECHARGING", 25, 160);
  }
}


void keyPressed() {
  if (key == 'q') {
    superMode = true;
    goblin.shield();
    numGoblinBullet = numShieldedGoblinBullet;
  }
  if (key == ' ') {
    if (!gameRunning) {
      gameRunning = true;
      setup();
    } else {
      isPaused = !isPaused;
    }
  }
}


// Function to play the full chord
void playChord(float[] freqs) {

  int freqIndex = 0;
  for (SinOsc oneSineOsc : sineOscs) {
    oneSineOsc.freq(freqs[freqIndex]);
    oneSineOsc.amp(0.04);
    oneSineOsc.play();
    freqIndex += 1;
  }
  
}

// Function to stop the chord (silence for 0.5s)
void stopChord() {
  for (SinOsc oneSineOsc : sineOscs) {
    oneSineOsc.stop();
  }
}

// To play the "bling" shooting sound
void playShootingSound() {
  // Create a new sine oscillator for the "Bling!" sound
  SinOsc bling = new SinOsc(this);
  bling.freq(chords[currentChord][floor(random(0, 5))]); // Random note, one octave up
  bling.amp(0); // Start with 0 amplitude (to avoid sudden noise)
  bling.play();
  //bling.phase(random(1.0));

  // Create an envelope to shape the sound
  Env envelope = new Env(this);
  
  // Define envelope parameters: attack, sustain, sustain level, release
  float attackTime = 0.01;  // 10ms attack
  float sustainTime = 0.1; // 50ms sustain
  float sustainLevel = 0.9; // Medium volume sustain
  float releaseTime = 0.2;  // 100ms release

  // Play the envelope (all parameters filled correctly)
  envelope.play(bling, attackTime, sustainTime, sustainLevel, releaseTime);

  // Stop the oscillator after the full envelope duration
  new Thread(() -> {
    delay((int) ((attackTime + sustainTime + releaseTime) * 1000));
    bling.stop();
  }).start();
}

