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
  player = new Player(size * 3, 50, (int) pos.x, (int) pos.y);//you adjust player hp here
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
