
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
   if(stepCount.get(i) > 300){// limits the amount of missiles on-screen and attacking the player
     stepCount.remove(i);
     missiles.remove(i);
     i--;
   }
  }
} 

Enemy enemyDamaged(Enemy object){
   return new Enemy(object.size, object.durability - 1, object.type, object.spd, object.xcord, object.ycord);
}
