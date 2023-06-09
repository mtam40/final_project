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
