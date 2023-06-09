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
