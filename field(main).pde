int size, w, h, moveRate, spd, enemySpd, spawnspd, fireSpd, miniSpawnspd, miniLaserFireSpd, miniMissileFireSpd;
int powerUpSpawnDur = 2500;
int waveChange = 200000;
PVector pos, dir = new PVector(0,0);
PVector playerBulletsDir = new PVector(0, -10);
ArrayList<PVector> playerBullets = new ArrayList<PVector>();
entity player = new entity();
int survived;
ArrayList<PVector> enemyposList = new ArrayList<PVector>();
ArrayList<Enemy> enemyList = new ArrayList<Enemy>();
ArrayList<PVector> bloomposList = new ArrayList<PVector>();
ArrayList<Enemy> bloomList = new ArrayList<Enemy>();
ArrayList<PVector> enemyBullets = new ArrayList<PVector>();
ArrayList<PVector> bloomBullets = new ArrayList<PVector>();
ArrayList<PVector> enemyBulletsdirs = new ArrayList<PVector>();
Enemy basic = new Enemy();

ArrayList<PVector> miniBossposList = new ArrayList<PVector>();
ArrayList<Enemy> miniBossList = new ArrayList<Enemy>();
ArrayList<PVector> missiles = new ArrayList<PVector>();
ArrayList<Integer> stepCount = new ArrayList<Integer>();
ArrayList<PVector> lasers = new ArrayList<PVector>();

boolean powerUpSpawn = false;
ArrayList<PVector> powerUps = new ArrayList<PVector>();
ArrayList<String> powerUpType = new ArrayList<String>();

boolean spedUp = false;
int speedUpDuration = 500;
int powerUpStart;
boolean healed = false;
boolean timeSlow = false;
int timeSlowDuration = 800;

boolean bossActive = false;
int bossSpawnTime;
int bossSpawnDur = 5000;
Enemy beegBoss = new Enemy();
PVector bossLoc = new PVector(0, 0);
Enemy theBigCrab = new Enemy(size * 9, 3, "theBigCrab", 0, width / 2, height);
ArrayList<PVector> bossHP = new ArrayList<PVector>();

void setup() {
  size(1080, 700);
  size = 20;
  w = width/size;
  h = height/size;
  moveRate = size / 4;
  spd = 10;
  enemySpd = spd;
  spawnspd = 100;
  fireSpd = 50;
  miniSpawnspd = 2000;
  miniLaserFireSpd = 75;
  miniMissileFireSpd = 100;
  pos = new PVector(width / 2 / size * size, height / 2 / size * size); //initial position
  drawPlayer();
  player = new Player(size * 3, 1, (int) pos.x, (int) pos.y);//you adjust player hp here
  createBasics();
  enemyList.add(basic);
  createMiniBosses();
  for(int i = 0; i < width / size; i++){
   bossHP.add(i, new PVector(i * size, 0)); 
  }
  spawnPowerUp();
}

void draw() {
  background(200);
  if(bossActive == false){
  grid();
  }else{bossGrid(); drawBoss(); timerCheckCrab();}
  drawPlayer();
  if(powerUpSpawn == true){
    drawPowerUp();
  }
  if(frameCount % moveRate == 0) {
    updatePlayer();
  }
  if(frameCount % spd == 0) {
    createPlayerBullet();
    collisionCheck();
    collisionCheckPowerUp();
  }
  if(frameCount % enemySpd == 0){
    updateEnemies();
    updateMinis(); 
  }
  if(frameCount % fireSpd == 0){
    createEnemyBullet(); 
    createBulletBloom(); 
  }
  if(frameCount % miniMissileFireSpd == 0){
    createMissiles(size);
  }
  if(frameCount % miniLaserFireSpd * 4 == 0){
    for(int i = 0; i < miniLaserFireSpd / 2; i++){
        createMiniLaser();
  }
  while(lasers.size() > 0){
     lasers.remove(lasers.size() - 1);
  }
  }
  if(frameCount % spawnspd == 0) {
    createBasics();
  }
  if(frameCount % (spawnspd * 3) == 0) {
    createBloomShooters();
  }
  if(frameCount % miniSpawnspd == 0) {
    createMiniBosses();
  }
  if(frameCount % powerUpSpawnDur == 0) {
    spawnPowerUp();
  }
  if(spedUp == true){
    if(frameCount < powerUpStart + speedUpDuration){
      moveRate = size / 8;
    }else{spedUp = false; moveRate = size / 4;}
  }
  if(timeSlow == true){
    if(frameCount < powerUpStart + timeSlowDuration){
      enemySpd *= 5;
      spawnspd *= 5;
      fireSpd *= 5;
      miniSpawnspd *= 5;
      miniMissileFireSpd *= 5;
      for(int i = 0; i < enemyList.size(); i++){
        enemyList.get(i).spd = .1; 
      }
    }else{
  timeSlow = false;
  enemySpd = spd;
  spawnspd = 100;
  fireSpd = 50;
  miniSpawnspd = 2000;
  miniLaserFireSpd = 75;
  miniMissileFireSpd = 100;
  for(int i = 0; i < enemyList.size(); i++){
        enemyList.get(i).spd = 5; 
      }
    }
  }
  if(healed == true){
    player.durability += 5; healed = false;
  }
  if((frameCount % waveChange == 0) && (frameCount != 0)) {
    enemySpd *= 2;
    moveRate *= 2;
  }
  if((bossActive == true ) && (frameCount > bossSpawnTime + bossSpawnDur)){
    bossActive = false;
    setup();
  }
  drawEnemies();
  drawMiniBoss();
  updatePlayerBullets();
  updateEnemyBullets();
  updateBloomBullets();
  updateMissiles();
  gameOver();
  textSize(12);
  fill(255);
  text("Current hp: " + str(player.durability), size, size);
}

void grid() {
    for(int outer = 0; outer < h; outer++){
      for(int inner = 0; inner < w; inner++){
        fill(#404274);
        square( inner * size, outer * size, size);
      }
    }
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == UP) { dir = new PVector(0, -size); }
    if(keyCode == DOWN) { dir = new PVector(0, size); }
    if(keyCode == LEFT) { dir = new PVector(-size, 0); }
    if(keyCode == RIGHT) { dir = new PVector(size, 0); }
    if(keyCode == SHIFT) { dir = new PVector(0, 0); }
    if(keyCode == CONTROL) { bossActive = true; spawnBoss(); }
    if(keyCode == ENTER) { setup(); }
  } 
}

void drawPlayer() {
  fill(#74FF83);
  square(pos.x - size, pos.y - size, size * 3);
}

void updatePlayer(){
  pos.add(dir);
  fill(#74FF83);
}

void createPlayerBullet(){
  PVector playerBulletl = new PVector(pos.x - size, pos.y);
  PVector playerBulletr = new PVector(pos.x + size, pos.y);
  playerBullets.add(playerBulletl);
  playerBullets.add(playerBulletr);
  fill(#C45D5D);
  square(playerBulletl.x, playerBulletl.y, size);
  square(playerBulletr.x, playerBulletr.y, size);
}

void updatePlayerBullets(){
  for(int i = 0; i < playerBullets.size(); i++){
    if(playerBullets.get(i).y > 0){
      playerBullets.get(i).add(playerBulletsDir);
      fill(#C45D5D);
      square(playerBullets.get(i).x, playerBullets.get(i).y, size);
    }
    else{playerBullets.remove(i);}
  }
} 
void playerIsHit(){
   player = new Player(size * 3, player.durability - 1, (int) pos.x, (int) pos.y);
}

void gameOver(){
 if (player.durability < 1){
   fill(#030303);
   rect(0, 0, 1080, 720);
   textSize(128);
   fill(255);
   text("GAME OVER", width / 4,  height / 2);
   textSize(64);
   text("You survived " + survived + " frames" , width / 4,  height / 1.5);
 }else{survived = frameCount;}
}

void collisionCheck(){
 for(int i = 0; i < playerBullets.size(); i++){
   for(int j = 0; j < enemyposList.size(); j++){
     if((abs(playerBullets.get(i).x - enemyposList.get(j).x) < enemyList.get(j).size) &&
     (abs(playerBullets.get(i).y - enemyposList.get(j).y) < enemyList.get(j).size * 3)){
       enemyList.set(j, enemyDamaged(enemyList.get(j)));
       playerBullets.remove(i);
       i = 0;
     }
   }
 }
 for(int i = 0; i < playerBullets.size(); i++){
   for(int j = 0; j < bloomposList.size(); j++){
     if((abs(playerBullets.get(i).x - bloomposList.get(j).x) < bloomList.get(j).size) &&
     (abs(playerBullets.get(i).y - bloomposList.get(j).y) < bloomList.get(j).size * 3)){
       bloomList.set(j, enemyDamaged(bloomList.get(j)));
       playerBullets.remove(i);
       i = 0;
     }
   }
 }
 for(int i = 0; i < playerBullets.size(); i++){
   for(int j = 0; j < miniBossposList.size(); j++){
     if((abs(playerBullets.get(i).x - miniBossposList.get(j).x) < miniBossList.get(j).size / 2) &&
     (abs(playerBullets.get(i).y - miniBossposList.get(j).y) < miniBossList.get(j).size)){
       miniBossList.set(j, enemyDamaged(miniBossList.get(j)));
       playerBullets.remove(i);
       i = 0;
     }
   }
 }
 for(int i = 0; i < enemyBullets.size() ; i++){
     if((abs(enemyBullets.get(i).x - pos.x) < player.size / 2) &&
     (abs(enemyBullets.get(i).y - pos.y) < player.size / 2)){
       playerIsHit();
       enemyBullets.remove(i);
       i = 0;
       gameOver();
     }
   }
   for(int i = 0; i < bloomBullets.size() ; i++){
     if((abs(bloomBullets.get(i).x - pos.x) < player.size / 2) &&
     (abs(bloomBullets.get(i).y - pos.y) < player.size / 2)){
       playerIsHit();
       bloomBullets.remove(i);
       i = 0;
       gameOver();
     }
   }
   for(int i = 0; i < missiles.size() ; i++){
     if((abs(missiles.get(i).x - pos.x) < player.size / 2) &&
     (abs(missiles.get(i).y - pos.y) < player.size / 2)){
       playerIsHit();
       missiles.remove(i);
       stepCount.remove(i);
       i = 0;
       gameOver();
     }
   }
   for(int i = 0; i < lasers.size(); i++){
     if((lasers.get(i).x == pos.x) && (lasers.get(i).y < pos.y)){
       playerIsHit();
       gameOver();
     }
   }
 }
 
void timerCheckCrab(){
  if((frameCount - bossSpawnTime) % (bossSpawnDur / w) == 0){
    hpBarDecrease(); 
  }
}


void spawnBoss(){
  //boss spawn overrides the field
  playerBullets = new ArrayList<PVector>();
  enemyposList = new ArrayList<PVector>();
  enemyList = new ArrayList<Enemy>();
  enemyBullets = new ArrayList<PVector>();
  bloomposList = new ArrayList<PVector>();
  bloomList = new ArrayList<Enemy>();
  miniBossposList = new ArrayList<PVector>();
  miniBossList = new ArrayList<Enemy>();
  missiles = new ArrayList<PVector>();
  stepCount = new ArrayList<Integer>();
  lasers = new ArrayList<PVector>();
  spawnspd = 200;
  fireSpd = 100;
  miniSpawnspd = 10000;
  beegBoss = theBigCrab;//the only boss for now
  bossLoc = new PVector(beegBoss.xcord, beegBoss.ycord);
  bossSpawnTime = bossSpawnTime();
}

void drawBoss(){
  if(beegBoss.type.equals("theBigCrab")){
    drawTheBigCrab();
  }
}

void bossGrid(){
 for(int outer = 0; outer < h; outer++){
      for(int inner = 0; inner < w; inner++){
        fill(#050505);
        square( inner * size, outer * size, size);
      }
    } 
}

void drawTheBigCrab(){
  //this first part is the hp bar
  for(int i = 0; i < bossHP.size(); i++){
  fill(#FA1414);
  square(bossHP.get(i).x, bossHP.get(i).y, size);
  }
  //then the actual "crab"
  fill(#FA975D);
  PVector clawL = new PVector(width / 8, size * 6);
  PVector clawR = new PVector(6 * width / 8, size * 6);
  PVector feelerL = new PVector(3.75 * width / 8, size * 6);
  PVector feelerR = new PVector(4.25 * width / 8, size * 6);
  rect(width / 8, size * 2, 6 * width / 8, size * 6);
  rect(clawL.x, clawL.y, width / 8, size * 9);
  rect(clawR.x, clawR.y, width / 8, size * 9);
  rect(feelerL.x, feelerL.y, width / 24, size * 3);
  rect(feelerR.x, feelerR.y, width / 24, size * 3);
  int pattern = (int) random(100);
  if(frameCount % fireSpd == 0){
    if(pattern < 33){
    bigCrabPatternA();
    }
    else if(pattern < 66){
      bigCrabPatternB();
    }
    else if(pattern < 99){
      bigCrabPatternC();
    }
    else{pattern = 0;}
  }
}

void bigCrabPatternA(){//missiles from claws
  int i = 0;
   while(i < 8){
   if(frameCount % 2 == 0){
       i++;
     }else{break;}
    PVector missileL = new PVector(width / 8, size * 12);
    PVector missileR = new PVector(6 * width / 8, size * 12);
    EnemyBullet bulletdirL = new EnemyBullet(new PVector( random(-15, 15), random(3)));
    EnemyBullet bulletdirR = new EnemyBullet(new PVector( random(-15, 15), random(3)));
    for(int j = 0; j < 20; j++){
      missileL.add(bulletdirL.dir);
      missileR.add(bulletdirR.dir);
   }
   fill(#FA1414);
    square(missileL.x, missileL.y, size);
    stepCount.add(0);
    missiles.add(missileR);
    fill(#FA1414);
    square(missileR.x, missileR.y, size);
    stepCount.add(0);
}
}

void bigCrabPatternB(){//laser from mouth
     PVector laser = new PVector(width / 2, beegBoss.ycord);
     lasers.add(laser);
     fill(#FA1414);
     rect(laser.x, laser.y, size, height); 
}


void bigCrabPatternC(){//bullet spray from claws
  int i = 0;
   while(i < 20){
   if(frameCount % 2 == 0){
       i++;
     }else{break;}
     PVector crabBulletL = new PVector(width / 8, size * 9);
     EnemyBullet bulletL = new EnemyBullet(new PVector( random(-3, 3), random(3)));
     enemyBullets.add(crabBulletL);
     enemyBulletsdirs.add(bulletL.dir);
     PVector crabBulletR = new PVector(6 * width / 8, size * 9);
     EnemyBullet bulletR = new EnemyBullet(new PVector( random(-3, 3), random(3)));
     enemyBullets.add(crabBulletR);
     enemyBulletsdirs.add(bulletR.dir);
   }
}

void hpBarDecrease(){
  bossHP.remove(bossHP.size() - 1);
}

int bossSpawnTime(){
  return frameCount;
}

void createBasics(){
  Enemy basic = new Enemy(size * 2, 5, "basicEnemy", 5, (int) random(width) / size * size, (int) random(height / 3) / size * size);
  PVector basicEnemy = new PVector(basic.xcord, basic.ycord);
  fill(#3F4067);
  square(basicEnemy.x, basicEnemy.y, 40);
  enemyList.add(basic);
  enemyposList.add(basicEnemy);
}

void drawEnemies(){
 for(int i = 0; i < enemyposList.size(); i++){
    fill(#745F40);
    square(enemyposList.get(i).x, enemyposList.get(i).y, enemyList.get(i).size);
  }
  for(int i = 0; i < bloomposList.size(); i++){
    fill(#58E57A);
    square(bloomposList.get(i).x, bloomposList.get(i).y, bloomList.get(i).size);
  }
}


void createBloomShooters(){
  Enemy bloom = new Enemy(size * 2, 5, "bloomer", 5, (int) random(width) / size * size, (int) random(height / 3) / size * size);
  PVector bloomer = new PVector(bloom.xcord, bloom.ycord);
  fill(#58E57A);
  square(bloomer.x, bloomer.y, 40);
  bloomList.add(bloom);
  bloomposList.add(bloomer);
}




void updateEnemies(){
  for(int i = 0; i < enemyposList.size(); i++){
    enemyposList.get(i).add(0.0, (float) enemyList.get(i).spd);
    if (enemyList.get(i).durability < 1){
          enemyList.remove(i);
          enemyposList.remove(i);
          i--;
      }
  }
  for(int i = 0; i < bloomposList.size(); i++){
    bloomposList.get(i).add(0.0, (float) bloomList.get(i).spd);
    if (bloomList.get(i).durability < 1){
          bloomList.remove(i);
          bloomposList.remove(i);
          i--;
      }
  }
}

void createEnemyBullet(){
  for(int i = 0; i < enemyposList.size(); i++){
    if(enemyList.get(i).type.equals("basicEnemy")){
       PVector enemyBullet = new PVector(enemyposList.get(i).x + 2 * size / 3, enemyposList.get(i).y);
       enemyBullets.add(enemyBullet);
       enemyBulletsdirs.add(new EnemyBullet().dir);
    }   
  }
}

void createBulletBloom(){
  for(int i = 0; i < bloomposList.size(); i++){
    for(int j = 0; j < 4; j++){
      PVector enemyBullet = new PVector(bloomposList.get(i).x + 2 * size / 3, bloomposList.get(i).y);
      bloomBullets.add(enemyBullet);
    }
  }
}

void updateEnemyBullets(){
  for(int i = 0; i < enemyBullets.size(); i++){
    enemyBullets.get(i).add(enemyBulletsdirs.get(i));
    fill(#FA1414);
    square(enemyBullets.get(i).x, enemyBullets.get(i).y, size);
  }
} 

void updateBloomBullets(){
  for(int i = 0; i < bloomBullets.size(); i++){
    if(i % 4 == 0){
    bloomBullets.get(i).add(0, 2.5);
    fill(#FA1414);
    square(bloomBullets.get(i).x, bloomBullets.get(i).y, size);
    }
    else if(i % 3 == 0){
    bloomBullets.get(i).add(0, -2.5);
    fill(#FA1414);
    square(bloomBullets.get(i).x, bloomBullets.get(i).y, size);
    }
    else if(i % 2 == 0){
    bloomBullets.get(i).add(2.5, 0);
    fill(#FA1414);
    square(bloomBullets.get(i).x, bloomBullets.get(i).y, size);
    }
    else{
    bloomBullets.get(i).add(-2.5, 0);
    fill(#FA1414);
    square(bloomBullets.get(i).x, bloomBullets.get(i).y, size);
    }
  }
} 

void createMiniBosses(){
  Enemy Mini = new Enemy(size * 10, 11, "miniBoss", 1, (int) random(width / 3, width * 2 / 3) / size * size, (int) random(height / 3) / size * size);
  PVector MiniBoss = new PVector(Mini.xcord, Mini.ycord);
  fill(#3F4067);
  square(MiniBoss.x, MiniBoss.y, Mini.size);
  miniBossList.add(Mini);
  miniBossposList.add(MiniBoss);
}

void drawMiniBoss(){
 for(int i = 0; i < miniBossposList.size(); i++){
    fill(#20675E);
    square(miniBossposList.get(i).x - size * 10 / 3, miniBossposList.get(i).y - size * 10 / 3, size * 10);
  } 
}

void updateMinis(){
  for(int i = 0; i < miniBossposList.size(); i++){
    miniBossposList.get(i).add(0.0, (float) miniBossList.get(i).spd);
    if (miniBossList.get(i).durability < 1){
          miniBossList.remove(i);
          miniBossposList.remove(i);
          i--;
      }
  }
} 


void createMiniLaser(){
  for(int i = 0; i < miniBossposList.size(); i++){
     PVector laser = new PVector(miniBossposList.get(i).x + size, miniBossposList.get(i).y);
     lasers.add(laser);
     fill(#FA1414);
     rect(laser.x, laser.y, size, height); 
  }
}

void createMissiles(int loc){
  for(int i = 0; i < miniBossposList.size(); i++){
     PVector missileL = new PVector(miniBossposList.get(i).x + loc, miniBossposList.get(i).y);
     PVector missileR = new PVector(miniBossposList.get(i).x - loc, miniBossposList.get(i).y);
     missiles.add(missileL);
     fill(#FA1414);
     square(missileL.x, missileL.y, size);
     stepCount.add(0);
     missiles.add(missileR);
     fill(#FA1414);
     square(missileR.x, missileR.y, size);
     stepCount.add(0);
  }
}

void updateMissiles(){
  for(int i = 0; i < missiles.size(); i++){
    if(missiles.get(i).y < pos.y){
      if(missiles.get(i).y < height){
        if(missiles.get(i).x > pos.x){
           missiles.get(i).add(-2.0, 2.0);
        }
        else{
           missiles.get(i).add(2.0, 2.0);
        }
      }
    }else if(missiles.get(i).x > pos.x){
           missiles.get(i).add(-2.0, -2.0);
        }else{missiles.get(i).add(2.0, -2.0);}
   fill(#FA1414);
   square(missiles.get(i).x, missiles.get(i).y, size);
   fill(#FA1414);
   circle(missiles.get(i).x, missiles.get(i).y, size);
   stepCount.set(i, (stepCount.get(i) + 1));
   if(stepCount.get(i) > 500){// limits the amount of missiles on-screen and attacking the player
     stepCount.remove(i);
     missiles.remove(i);
     i--;
   }
  }
} 

Enemy enemyDamaged(Enemy object){
   return new Enemy(object.size, object.durability - 1, object.type, object.spd, object.xcord, object.ycord);
}

class entity {
  public int size;// is actually the hitbox
  public int durability;
  public String type;
  public double spd;
  public int xcord;
  public int ycord;
  public entity() {// null entity
    size = 0;
    durability = 0;
    type = "Erroneous";
    spd = 0;
  }
  public entity(int hitboxSize, int hp, String entityType, double movspd){
    size = hitboxSize;
    durability = hp;
    type = entityType;
    spd = movspd;
  }
  public entity(int hitboxSize, int hp, String entityType, double movspd, int xpos, int ypos) {
    size = hitboxSize;
    durability = hp;
    type = entityType;
    spd = movspd;
    xcord = xpos;
    ycord = ypos;
  }
}

class Player extends entity {
  public Player(int hitboxSize, int hp, int xcord, int ycord) {
    super(hitboxSize, hp, "player",
      5, xcord, ycord);//dummy speed value, will change for balancing
  }
}

class Enemy extends entity { // to set enemy stats 
  public Enemy() {
    size = 0; 
    durability = 0;
    type = "No existe"; 
    spd = 0;
  }
  public Enemy(int hitboxSize, int hp, String type, double movspd, int xpos, int ypos){
    super(hitboxSize, hp, type, movspd); 
    xcord = xpos;
    ycord = ypos;
  }
}

class EnemyBullet{//this is more of a dir randomizer in practice
  PVector dir; 
  public EnemyBullet(){
     dir = new PVector(0, 2.5);
  }
  public EnemyBullet(PVector direction){
     dir = direction; 
  }
  
}

void spawnPowerUp(){
  PVector powerUp = new PVector((int) random(width / 3, width * 2 / 3) / size * size, (int) random(height / 3, height) / size * size);
  powerUpSpawn = true;
  int randomizer = (int) random(100);
  if(randomizer < 33){
    powerUps.add(powerUp);
    powerUpType.add("speedUp");
  }else if(randomizer < 66){
    powerUps.add(powerUp);
    powerUpType.add("timeSlow");
  }else if(randomizer < 99){powerUps.add(powerUp); powerUpType.add("healing");}
}



void drawPowerUp(){
  for(int i = 0; i < powerUps.size(); i++){
    fill(#FA975D);
    square(powerUps.get(i).x - size, powerUps.get(i).y - size, size);
  }
}

int getPowerUpStart(){
   return frameCount;
}

void collisionCheckPowerUp(){
    for(int i = 0; i < powerUps.size(); i++){
      if((abs(pos.x - powerUps.get(i).x) < player.size) && (abs(pos.y - powerUps.get(i).y)) < player.size){
        powerUps.remove(i);
        if(powerUpType.get(i).equals("speedUp")){
          spedUp = true;
        }
        if(powerUpType.get(i).equals("timeSlow")){
          timeSlow = true;
        }
        if(powerUpType.get(i).equals("healing")){
          healed = true;
        }
      }
    } 
}
