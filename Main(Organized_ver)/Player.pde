
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
