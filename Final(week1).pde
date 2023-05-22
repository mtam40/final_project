int size, w, h;
int spd = 20;
PVector pos, dir = new PVector(0,0);
PVector playerBulletsDir = new PVector(0, -5);
ArrayList<PVector> playerBullets = new ArrayList<PVector>();

void setup() {
  size(1080, 720);
  size = 40;
  w = width/size;
  h = height/size;
  pos = new PVector(w / 2 * size, h / 1.5 * size); //initial position
  drawPlayer();
  //noStroke();
  //fill(0);
}

void draw() {
  background(200);
  grid();
  drawPlayer();
  if(frameCount % spd == 0) {
    updatePlayer();
  }
  updatePlayerBullets();
}


void drawPlayer() {
  fill(#74FF83);
  square(pos.x, pos.y, size);
}

void updatePlayer(){
  pos.add(dir);
  fill(#74FF83);
  square(pos.x, pos.y, size);
  createPlayerBullet();
}

void createPlayerBullet(){
  PVector playerBullet = new PVector(pos.x, pos.y);
  playerBullets.add(playerBullet);
  fill(#C45D5D);
  square(playerBullet.x, playerBullet.y, 20);
}

void updatePlayerBullets(){
  for(int i = 0; i < playerBullets.size(); i++){
    playerBullets.get(i).add(playerBulletsDir);
    fill(#C45D5D);
    square(playerBullets.get(i).x, playerBullets.get(i).y, 20);
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

void keyPressed() {
  if(key == CODED) {
    if(keyCode == UP) { dir = new PVector(0, -size); }
    if(keyCode == DOWN) { dir = new PVector(0, size); }
    if(keyCode == LEFT) { dir = new PVector(-size, 0); }
    if(keyCode == RIGHT) { dir = new PVector(size, 0); }
  } 
}

class entity {
  public int size;// is actually the hitbox
  public int durability;
  public String type;
  public double spd;
  public entity() {// null entity
    size = 0;
    durability = 0;
    type = "Erroneous";
    spd = 0;
  }
  public entity(int hitboxSize, int hp, String entityType, double movspd) {
    size = hitboxSize;
    durability = hp;
    type = entityType;
    spd = movspd;
  }
}

class Player extends entity {
  public Player(int hitboxSize, int hp ) {
    super(hitboxSize, hp, "player",
      5);//dummy speed value, will change for balancing
  }
}
/*
class Enemy extends entity { // to set enemy stats
  public Enemy() {
    Enemy enemy = new enemyType("No existe");
  }
  public Enemy(String enemytype) {
    Enemy enemy = new enemyType(enemytype);
  }
}

class enemyType extends Enemy { // to store enemy types and stats

  public enemyType(String enemytype) {
    type = enemytype;
    for (int i = 0; i < enemyList.length; i++) {
      if (enemytype.equals(enemyList[i].type)) {
        size = enemyList[i].size;
        durability = enemyList[i].durability;
        spd = enemyList[i].spd;
      }
    }
  }
  private String[] enemyList = {nothing, basicEnemy, miniboss, boss, bonus};
  entity nothing = new enemyType(0, 0, "No existe", 0); //fail-safe for empty constructor
  entity basicEnemy = new entity(40, 40, "basicEnemy", 5);// dummy stat values
  entity miniboss = new entity(40, 40, "miniboss", 5);// dummy stat values
  entity boss = new entity(40, 40, "boss", 5);// dummy stat values
  entity bonus = new entity(40, 40, "bonus", 5);// dummy stat values
}

}*/
/*
class Bullet extends entity{
  public Bullet(){
    
  }
}*/
