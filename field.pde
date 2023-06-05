int size, w, h, moveRate, spd, spawnspd, fireSpd, miniSpawnspd, miniLaserFireSpd, miniMissileFireSpd;
int powerUpSpawnDur = 5000;
//int waveChange = 200000; // future feature, once functionalities are working
PVector pos, dir = new PVector(0,0);
PVector playerBulletsDir = new PVector(0, -10);
ArrayList<PVector> playerBullets = new ArrayList<PVector>();
entity player = new entity();
ArrayList<PVector> enemyposList = new ArrayList<PVector>();
ArrayList<Enemy> enemyList = new ArrayList<Enemy>();
ArrayList<PVector> enemyBullets = new ArrayList<PVector>();
PVector enemyBulletsDir = new PVector(0, 2.5);
Enemy basic = new Enemy();

ArrayList<PVector> miniBossposList = new ArrayList<PVector>();
ArrayList<Enemy> miniBossList = new ArrayList<Enemy>();
ArrayList<PVector> missiles = new ArrayList<PVector>();
ArrayList<Integer> stepCount = new ArrayList<Integer>();
ArrayList<PVector> lasers = new ArrayList<PVector>();

boolean powerUpSpawn = false;
ArrayList<PVector> powerUps = new ArrayList<PVector>();

boolean bossActive = false;
Enemy beegBoss = new Enemy();
PVector bossLoc = new PVector(0, 0);
Enemy theBigCrab = new Enemy(size * 200, 150, "theBigCrab", 0, width / 2, height);
ArrayList<PVector> bossHP = new ArrayList<PVector>();

void setup() {
  size(1080, 700);
  size = 20;
  w = width/size;
  h = height/size;
  moveRate = size / 4;
  spd = 10;
  spawnspd = 100;
  fireSpd = 50;
  miniSpawnspd = 2000;
  miniLaserFireSpd = 75;
  miniMissileFireSpd = 100;
  pos = new PVector(width / 2 / size * size, height / 2 / size * size); //initial position
  drawPlayer();
  player = new Player(size * 3, 55, (int) pos.x, (int) pos.y);
  //noStroke();
  //fill(0);
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
  }else{bossGrid(); drawBoss();}
  drawPlayer();
  if(powerUpSpawn = true){
    drawPowerUp();
  }
  if(frameCount % moveRate == 0) {
    updatePlayer();
  }
  if(frameCount % spd == 0) {
    createPlayerBullet();
    updateEnemies();
    updateMinis();
    collisionCheck();
  }
  if(frameCount % fireSpd == 0){
    createEnemyBullet(); 
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
  if(frameCount % miniSpawnspd == 0) {
    createMiniBosses();
  }
  if(frameCount % powerUpSpawnDur == 0) {
    spawnPowerUp();
  }
  drawEnemies();
  drawMiniBoss();
  updatePlayerBullets();
  updateEnemyBullets();
  updateMissiles();
  gameOver();
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

void grid() {
    for(int outer = 0; outer < h; outer++){
      for(int inner = 0; inner < w; inner++){
        fill(#FFFFFF);
        square( inner * size, outer * size, size);
      }
    }
}

void collisionCheck(){// hitboxes under development
 for(int i = 0; i < playerBullets.size(); i++){
   for(int j = 0; j < enemyposList.size(); j++){
     if((playerBullets.get(i).x == enemyposList.get(j).x) &&
     (abs(playerBullets.get(i).y - enemyposList.get(j).y) < enemyList.get(j).size)){
       enemyList.set(j, enemyDamaged(enemyList.get(j)));
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
   for(int i = 0; i < powerUps.size(); i++){
      if((abs(pos.x - powerUps.get(i).x) < size) && (abs(pos.y - powerUps.get(i).y)) < size){
        powerUps.remove(i);
        //powerUpSpeedUp();
      }
  }
 }
 
void playerIsHit(){
   player = new Player(size * 3, player.durability - 1, (int) pos.x, (int) pos.y);
}

void gameOver(){
 if (player.durability < 1){
   fill(#030303);
   rect(0, 0, 1080, 720);//dummy "Game Over"
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
  } 
}

//pure testing
void createBasics(){
  Enemy basic = new Enemy(size, 5, "basicEnemy", 5, (int) random(width) / size * size, (int) random(height / 3) / size * size);
  PVector basicEnemy = new PVector(basic.xcord, basic.ycord);
  fill(#3F4067);
  square(basicEnemy.x, basicEnemy.y, 40);
  enemyList.add(basic);
  enemyposList.add(basicEnemy);
}

void drawEnemies(){
 for(int i = 0; i < enemyposList.size(); i++){
    fill(#3F4067);
    square(enemyposList.get(i).x, enemyposList.get(i).y, size);
  }
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
}

void createEnemyBullet(){
  for(int i = 0; i < enemyposList.size(); i++){
     PVector enemyBullet = new PVector(enemyposList.get(i).x, enemyposList.get(i).y);
     enemyBullets.add(enemyBullet);
     fill(#FA1414);
     square(enemyBullet.x, enemyBullet.y, size); 
  }
}

void updateEnemyBullets(){
  for(int i = 0; i < enemyBullets.size(); i++){
    if(enemyBullets.get(i).y < height){
    enemyBullets.get(i).add(enemyBulletsDir);
    fill(#FA1414);
    square(enemyBullets.get(i).x, enemyBullets.get(i).y, size);
    }
    else{enemyBullets.remove(i);}
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
      else{missiles.remove(i);}
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

void spawnBoss(){
  //boss spawn overrides the field
  playerBullets = new ArrayList<PVector>();
  enemyposList = new ArrayList<PVector>();
  enemyList = new ArrayList<Enemy>();
  enemyBullets = new ArrayList<PVector>();
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
  miniBossList.add( beegBoss);
  miniBossposList.add(new PVector(beegBoss.xcord, beegBoss.ycord));
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
  if(frameCount % spd == 0){
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
  createMissiles(width / 8);
  createMissiles(6 * width / 8);
}

void bigCrabPatternB(){//laser from mouth
  createMiniLaser();
}

void bigCrabPatternC(){//bullet spray from claws
  
}

void bossHit(){
   beegBoss = new Enemy(beegBoss.size, beegBoss.durability - 1, beegBoss.type, 5, beegBoss.xcord, beegBoss.ycord);
}

void hpBarDecrease(){
  bossHP.remove(bossHP.size() - 1);
}

void bossDead(){
  if(beegBoss.durability < 1){
    bossActive = false; 
  }
}

void collisionCheckCrab(){
 for(int i = 0; i < playerBullets.size(); i++){
     if((abs(playerBullets.get(i).x - beegBoss.xcord) < beegBoss.size) &&
     (abs(playerBullets.get(i).y - beegBoss.ycord) < beegBoss.size)){
       bossHit();
       hpBarDecrease();
       playerBullets.remove(i);
       i = 0;
     }
 }
}

void spawnPowerUp(){
  PVector speedUp = new PVector((int) random(width / 3, width * 2 / 3) / size * size, (int) random(height / 3, height) / size * size);
  powerUpSpawn = true;
  powerUps.add(speedUp);
}

void drawPowerUp(){
  for(int i = 0; i < powerUps.size(); i++){
    fill(#FA975D);
    square(powerUps.get(i).x - size, powerUps.get(i).y - size, size * 3);
  }
}

/*void powerUpSpeedUp(){//powerUps in progress
  if(powerUpSpawn == true){
     int start = frameCount;
     while(frameCount < start + 200){
       moveRate = size / 8;
     }
     moveRate = size / 4;
  }
}*/
