
// Goblin At the Gate
// How to survive in front of a giant flock of enemies
// Yuehao Gao
// Redesigned from class example


// HOW TO PLAY THIS GAME: 
// - survive for longer, dodge the enemies and their bullets
// - shoot enimies by clicking the mouse
//   it is available every 5 second, unless being "shielded", which enable unlimited shooting
// - crash enimies when shielded (after picking up the blue square)
//   shooting ability will be increased
// - pick up potions (green square) to regain life



// All characters ------------------------------------
Goblin goblin;
Potion potion;
Shield shield;
ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Agent> agentsToRemove = new ArrayList<Agent>();
ArrayList<Bullet> goblinBullets = new ArrayList<Bullet>();
ArrayList<Bullet> goblinBulletsToRemove = new ArrayList<Bullet>();
ArrayList<Bullet> agentBullets = new ArrayList<Bullet>();
ArrayList<Bullet> agentBulletsToRemove = new ArrayList<Bullet>();


// All parameters ------------------------------------
boolean gameRunning;
int survivedTime;
int score;
int initialNumAgent = 30;
int numAgent;
float agentSpeed;
int numFrames;
int newAgentFrameCount = 240;        // A new agent will join the game every 4 seconds
                                     // at first, and gradually faster
int harderFrameCount = 360;          // The game becomes harder every 6 seconds
                                     // including agents' speed and refresh rate
                                     // limiting at 1 second / new agent
int newPotionCount = 720;            // Potion refreshes every 12 seconds
int newShieldCount = 1200;           // Shield refreshes every 20 seconds
int takeShieldFrame = 0;
int numGoblinBullet = 6;
int shieldDuration = 120;            // Shield lasts for 2 seconds
int lastShootFrame = -300;
int shootingInterval = 300;
int lastAgentShootFrame = 500;
int agentShootInterval = 300;


// --------------------------------------------------
void setup() {
  background(0);
  gameRunning = true;
  survivedTime = 0;
  score = 0;
  numFrames = 0;
  agentSpeed = 0.15;
  
  // Initialize the "Goblin" and "enemy agents"
  goblin = new Goblin();
  potion = new Potion();
  shield = new Shield();
  numAgent = initialNumAgent;
  for (int i = 0; i < initialNumAgent; i++) {
    Agent oneNewAgent = newAggentAppear(agentSpeed);
    agents.add(oneNewAgent);
  }

  size(1000, 700);
  textSize(24);
}


// --------------------------------------------------
// At every frame of the game
void draw() {
  
  // The first things to display are the texts
  if (gameRunning) {
    fill(255);
    text("Life: " + goblin.getLife(), 25, 30);
    text("Time lapsed: " + survivedTime + "s", 25, 50);
    text("Your score: " + score, 25, 70);
  } else {
    fill(255, 0, 255);
    text("GAME OVER", width / 2 - 60, height / 2);
    text("Time lapsed: " + survivedTime + "s", width / 2 - 70, height / 2 + 20);
    text("Your Score: " + score, width / 2 - 65, height / 2 + 40);
  }
  
  // Then the shadow of the previous frame
  fill(0, 33);
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
  
    // If it is time to become harder, do that
    if (numFrames % harderFrameCount == 0) {
      if (agentSpeed <= 3.5) {
        agentSpeed *= 1.2;
      }
      for (Agent oneAgent : agents) {
        oneAgent.updateSpeed(agentSpeed);
      }
      if (newAgentFrameCount >= 60) {
        newAgentFrameCount -= 20;
      }
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
        if (a.getSize() > 17) {
          dangerousAgents.add(a);
        }
      }
      
      // Pick one "dangerous" agent to do that shooting work
      int shooter = floor(random(0, dangerousAgents.size()));
      if (dangerousAgents.size() > 0) {
        for (int i = 0; i < 10; i++) {
          float angle = TWO_PI / 10 * i;
          agentBullets.add(new Bullet(dangerousAgents.get(shooter).getLocation().copy(), angle, false, false));
        }
      }
      
      lastAgentShootFrame = numFrames;
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
    }
    
    // Check if the goblin picks up the shield
    PVector shieldPosition = shield.getLocation();
    float shieldPosX = shieldPosition.x + potion.getSize() / 2.0;
    float shieldPosY = shieldPosition.y + potion.getSize() / 2.0;
    float distanceToShield = sqrt(pow((shieldPosX - goblinPosX), 2) + pow((shieldPosY - goblinPosY), 2));
    boolean takingShield = (distanceToShield < shield.getSize() + potion.getSize());
    if (takingShield && shield.getShowing()) {
      goblin.shield();
      numGoblinBullet = 16;
      takeShieldFrame = numFrames;
      shield.hide();
      takingShield = false;
    }
    
    // Check if the shield expires
    if (numFrames >= takeShieldFrame + shieldDuration) {
      goblin.unShield();
      numGoblinBullet = 6;
    }
  
    // Handle the location update and displaying of all characters
    goblin.updateLocation();
    goblin.display();
    
    
    if (potion.getShowing()) {
      potion.display();
    }
    
    if (shield.getShowing()) {
      shield.display();
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
      newAgentInitialY = 0.0;
    }
    // 1/4 probability of appearing from right
    else if (initialMarginIndex >= 1.0 && initialMarginIndex < 2.0) {
      newAgentInitialX = width;
      newAgentInitialY = random(0.0, height);
    }
    // 1/4 probability of appearing from bottom
    else if (initialMarginIndex >= 1.0 && initialMarginIndex < 2.0) {
      newAgentInitialX = random(0.0, width);
      newAgentInitialY = height;
    }
    // 1/4 probability of appearing from left
    else {
      newAgentInitialX = 0.0;
      newAgentInitialY = random(0.0, height);
    }
    
  Agent newAgent = new Agent(newAgentInitialX, newAgentInitialY, speed);
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
}



// To shoot
void mousePressed() {
  
  if (numFrames >= lastShootFrame + shootingInterval || goblin.getIsShielded()) {
    for (int i = 0; i < numGoblinBullet; i++) {
      float angle = TWO_PI / numGoblinBullet * i;
      goblinBullets.add(new Bullet(goblin.getLocation().copy(), angle, true, goblin.getIsShielded()));
    }
    lastShootFrame = numFrames;
  }
  else {
    fill(255, 200, 0);
    text("RECHARGING", 25, 90);
  }
}
