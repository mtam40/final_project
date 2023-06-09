

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
