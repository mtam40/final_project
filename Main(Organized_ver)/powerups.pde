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
