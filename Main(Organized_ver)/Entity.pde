class entity {
  public int size;// is actually the hitbox
  public int durability;
  public String type;
  public double spd;
  public int xcord;
  public int ycord;
  // I have no idea why I can't call this
  /*
  Enemy nothing = new Enemy(0, 0, "No existe", 0); //fail-safe for empty constructor
  Enemy basicEnemy = new Enemy(40, 40, "basicEnemy", 5);// dummy stat values
  Enemy miniboss = new Enemy(40, 40, "miniboss", 5);// dummy stat values
  Enemy boss = new Enemy(40, 40, "boss", 5);// dummy stat values
  Enemy bonus = new Enemy(40, 40, "bonus", 5);// dummy stat values
  public Enemy[] enemyList = {nothing, basicEnemy, miniboss, boss, bonus};  
  */
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
  /*public Enemy(String type, int xpos, int ypos) {
    for(int i = 0; i < enemyList.length; i++){
      if(enemyList[i].type.equals(type)) {
         
      }
    }
    xcord = xpos;
    ycord = ypos;
  }*/
  public Enemy(int hitboxSize, int hp, String type, double movspd, int xpos, int ypos){
    super(hitboxSize, hp, type, movspd); 
    xcord = xpos;
    ycord = ypos;
  }
}


/*class enemyType{ // to store enemy types and stats
  public int size;// is actually the hitbox
  public int durability;
  public String type;
  public double spd;
  public int xcord;
  public int ycord;
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
} 
*/

class EnemyBullet{//this is more of a dir randomizer in practice
  PVector dir; 
  public EnemyBullet(){
     dir = new PVector(0, 2.5);
  }
  public EnemyBullet(PVector direction){
     dir = direction; 
  }
  
}
