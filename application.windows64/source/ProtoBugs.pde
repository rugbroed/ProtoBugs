// **************************************************
// ****               PROTO BUGS                 ****
// ****                                          ****
// ****  Proto Bugs is free for non-commercial   ****
// ****  use. If you like the idea, please help  **** 
// ****  make it better.                         ****
// ****                                          ****
// ****  ++ For project forks, please keep   ++  ****
// ****  ++ the below message in the project ++  ****
// ****  ++ header/description.              ++  ****
// ****                                          ****
// ****  Proto Bugs was originally made as an    ****
// ****  inspiration for the students at a       ****
// ****  course on interactivity at the          ****
// ****  IT-University of Copenhagen             ****
// ****  by Kasper (kben@itu.dk).                ****
// ****                                          ****
// ****                                          ****
// ****                                          ****
// ****  Current functionality                   ****
// ****                                          ****
// ****    NON-INTERACTIVELY FUNCTIONALITY       ****
// ****    -  Bugs are initialized and move      ****
// ****       around randomly (energy: 100).     ****
// ****    -  Bugs are 'white' if they have      ****
// ****       plenty of energy (> 0). If their   ****
// ****       energy levels drop below 0, they   ****
// ****       are 'red'. If the energy level     ****
// ****       drops below -50 they die, and      ****
// ****       they turn into food.               ****
// ****       Non-initialized baby bugs are      ****
// ****       blue for some moves, so birth is   ****
// ****       visual.                            ****
// ****    -  Food are initialized and placed    ****
// ****       randomly (energy: a random number  ****
// ****       between 1 and 200). Food is        ****
// ****       'green'                            ****
// ****    -  When two bugs are at the same tile ****
// ****       and they got enough energy, and    ****
// ****       they are both fertile (maning      ****
// ****       that it is some moves since they   ****
// ****       last gave offspring) they          ****
// ****       will produce ofspring, spawning a  ****
// ****       new bug and decreasing energy from ****
// ****       the parent bugs. Baby bugs are     ****
// ****       blue.                              ****
// ****                                          ****
// ****    INTERACTIVELY FUNCTIONALITY           ****
// ****    -  [MOUSE CLICK] Baby bugs can be     **** 
// ***        manually placed by clicking.       ****
// ****    -  KEY 'F': Extra food can be seeded. ****
// ****    -  KEY 'P': Pauses.                   ****
// ****                                          ****
// ****  Features suggestions:                   ****
// ****                                          ****
// ****    1. Bugs should learn about their      ****
// ****       surroundings, and incorporate      ****
// ****       this in their DNA.                 ****
// ****                                          ****
// ****    2. Food is seeded randomly acoording  ****
// ****       to variable settings.              ****
// ****                                          ****
// ****                                          ****
// **************************************************

import java.util.Iterator;
import java.util.Map;
import java.awt.event.*;

int delayInMillis = 0;

int bugViewSize = 3;

int canvasX = 100;
int canvasY = 100;
int tileSize = 10;

boolean pause = false;

World world = new World();

void setup() {
  background(128, 128, 128);
  
  stroke(0, 0, 0);
  
  size(canvasX * tileSize, canvasY * tileSize);
  frameRate(24);

  world.makeWorld();
}

void mousePressed() {
  int x = int(mouseY / tileSize);
  int y = int(mouseX / tileSize);
  
  Tile tile = world.getTile(y, x);
  world.addNewBug(tile, true);
}

void draw() {
  if (keyPressed) {
    if (key == 'f') {
      world.placeFood();
      world.display();
    }
    else {
      if (key == 'p') {
        pause = !pause;
        delay(200);
      }
    }
  }
  
  if (!pause) {
    world.moveBugs();
  }
}

void delay(int napTime) {
  try {
    Thread.sleep(napTime);
  } 
  catch (InterruptedException e) {
  }
}

class CanvasPosition {
  int cpX, cpY;
  
  public CanvasPosition(int y, int x) {
    this.cpY = int(y);
    this.cpX = int(x);
  }
  
  public void addX() {
    if (cpX == canvasX - 1) cpX = 0;
    else cpX++;
  }
  
  public void subX() {
    if (cpX == 0) cpX = canvasX - 1;
    else cpX--;
  }
  
  public void addY() {
    if (cpY == canvasY - 1) cpY = 0;
    else cpY++;
  }
  
  public void subY() {
    if (cpY == 0) {
      cpY = (canvasY - 1);
    }
    else cpY--;
  }
  
  public int getX() {
    return cpX;
  }
  
  public int getY() {
    return cpY;
  }
  
  public String toString() {
    String s = "";
    try {
      s = "[Y:" + cpY + ", X:" + cpX + "]";
    }
    catch (Exception e) {
      println("EXCEPTION!");
    }    
    
    return s;
  }
}

public class Tile {
  Food food = null;
  ArrayList bugs = new ArrayList();

  int col, row;

  Tile(int col, int row) {
    this.col = col;
    this.row = row;
  }

  public void setFood(Food food) {
    this.food = food;
  }

  public Food getFood() {
    return food;
  }

  public Bug getBug(int number) {
    return (Bug) this.bugs.get(number);
  }
  
  public int getNumberOfBugs() {
    return bugs.size();
  }
  
  public void bugLeaves(Bug bug) {
    bug.setTile(null);
    this.bugs.remove(bug);
  }
  
  public void bugArrives(Bug bug) {
    this.bugs.add(bug);
  }
  
  Bug returnBaby() {
    for (int i = 0; i < this.bugs.size(); i++) {
      Bug bug = (Bug) this.bugs.get(i);
      
      if (bug.isBaby()) return bug;
    }
    
    return null;
  }
  
  void display() {
    Bug bug = returnBaby();
    if (bug == null && this.bugs.size() > 0) bug = (Bug) this.bugs.get(0);
   
    if (bug != null) { 
      if (bug.getEnergy() <= 0) {
        fill(255, 0, 0);
      }
      else {
        if (bug.isBaby()) {
          //fill(255, 182, 193);
          fill(0, 0, 255);
        }
        else {
          fill(255, 255, 255);
        }        
      }
    } 
    else {
      if (getFood() != null) {
        fill(0, 255, 0);
      } 
      else {
        fill(0, 0, 0);
      }
    }

    rect(col * tileSize, row * tileSize, tileSize, tileSize);
  }
  
  int getCol() {
    return col;
  }
  
  int getRow() {
    return row;
  }
  
  public String toString() {
    String s = "";
    try {
      s = "[Col:" + col + ", Row:" + row + "]";
    }
    catch (Exception e) {
      println("EXCEPTION!");
    }    
    
    return s;
  }
  
}

class Move {
  int direction;

  Move() {
    direction = int(random(8) + 1);
  }

  public boolean isReversed(Move move) {
    if (move.getDirection() <= 4) {
      //println("[POS] Is move.getDirection() " + move.getDirection() + " + 4 == " + this.getDirection() + "?");

      if ((move.getDirection() + 4) == this.getDirection()) 
      {
        //println("Earlier move detected, new move is being made.");
        return true;
      }
    }
    else {
      //println("[NEG] Is move.getDirection() " + move.getDirection() + " - 4 == " + this.getDirection() + "?");

      if ((move.getDirection() - 4) == this.getDirection()) {
        //println("Earlier move detected, new move is being made.");
        return true;
      }
    }

    return false;
  }

  public int getDirection() {
    return direction;
  }
}

public class Food {
  int energy = 0;

  Food() {
    energy = int(random(200)+1);
  }

  Food(int energy) {
    this.energy = energy;
  }

  public int getEnergy() {
    return energy;
  }
}

public class Bug {
  int energy = 0;
  int numberOfMovesToStayBaby = 0;
  int numberOfMovesToFertile = 0;
  
  Move lastMove = null;
  Tile tile;
  
  Bug(Tile tile) {
    this.tile = tile;
    energy = int(random(50)) + 50;
  }
  
  public void setNumberOfMovesToStayBaby(int numberOfMovesToStayBaby) {
    this.numberOfMovesToStayBaby = numberOfMovesToStayBaby;
  }
  
  public void setNumberOfMovesToFertile(int numberOfMovesToFertile) {
    this.numberOfMovesToFertile = numberOfMovesToFertile;
  }
  
  public boolean isFertile() {
    return (this.numberOfMovesToFertile == 0);
  }
  
  public boolean isBaby() {
    return (this.numberOfMovesToStayBaby > 0);
  }

  public void consume(Food food) {
    energy = energy + food.getEnergy();
  }

  public int getEnergy() {
    return energy;
  }

  public void substractEnergy(int amount) {
    energy = energy - amount;
  }
  
  Tile getTile() {
    return tile;
  }
  
  void setTile(Tile tile) {
    this.tile = tile;
  }

  public void move() {
    Move m = null;
    boolean doContinue = true;

    while (doContinue) {
      m = new Move();

      if (lastMove == null) {
        lastMove = m;
      }
      else {
        if (!lastMove.isReversed(m)) {
          doContinue = false;
        }
      }
    }
    lastMove = m;
    
    CanvasPosition cp = new CanvasPosition(getTile().getCol(), getTile().getRow());

    switch(m.direction) {
    case 1:
      cp.subY();
      break;
      
    case 2:
      cp.subY();
      cp.addX();
      break;
      
    case 3:
      cp.addX();
      break;
      
    case 4:
      cp.addY();
      cp.addX();
      break;
      
    case 5:
      cp.addY();
      break;
      
    case 6:
      cp.addY();
      cp.subX();
      break;
      
    case 7:
      cp.subX();
      break;
      
    case 8:
      cp.subX();
      cp.subY();
      break;
    }
    
    energy--;
    
    Tile tile = getTile();
    tile.bugLeaves(this);
    tile.display();
    
    tile = world.getTile(cp.getY(), cp.getX());
    tile.bugArrives(this);

    if (tile.getFood() != null) {
      consume(tile.getFood());
      tile.setFood(null);
    }
    
    if (numberOfMovesToStayBaby > 0) {
      numberOfMovesToStayBaby--;
    }
    
    if (numberOfMovesToFertile > 0) {
      numberOfMovesToFertile--;
    }
    
    setTile(tile);

    tile.display();
  }
}

public class World {
  // Small setup
  int initialize_FOOD_AMOUNT = 500;
  int initialize_BUGS_AMOUNT = 250;
  
  // Huge setup
  /*
  int canvasX = 550;
  int canvasY = 550;
  int tileSize = 2;
  int initialize_FOOD_AMOUNT = 10000;
  int initialize_BUGS_AMOUNT = 10000;
  */
  
  Tile[][] world = new Tile[canvasY][canvasX];
  ArrayList bugs = new ArrayList();
  
  public Bug addNewBug(Tile tile, boolean asBaby) {
    Bug bug = new Bug(tile);
    
    if (asBaby) {
      bug.setNumberOfMovesToStayBaby(50);
    }      
    
    bugs.add(bug);
  
    tile.bugArrives(bug);
    tile.display();
    
    return bug;
  }
  
  void initializeWorld() {
    print("Initializing world...");
    for (int y = 0; y < canvasY; y++) {
      for (int x = 0; x < canvasX; x++) {
        
        Tile tile = new Tile(y, x);
        world[y][x] = tile;
        
        tile.display();
      }
    }
    println("DONE.");
  }
  
  public Tile getTile(int y, int x) {
    Tile tile = this.world[y][x];
    
    return tile;
  } 
  
  void placeFood() {
    print("Placing food...");
    int foodPlaced = 0;
    int tryCounter = 0;
    
    while (foodPlaced < initialize_FOOD_AMOUNT && tryCounter < (initialize_FOOD_AMOUNT * 3)) {
      tryCounter++;
      int y = int(random(canvasY));
      int x = int(random(canvasX));
  
      if (world[y][x].getFood() == null) {
        Food food = new Food();
        world[y][x].setFood(food);
        foodPlaced++;
      }
    }
    
    println("DONE.");
  }

  void placeBugs() {
    print("Placing bugs...");
    
    int bugsPlaced = 0;
    while (bugsPlaced < initialize_BUGS_AMOUNT) {
      int y = int(random(canvasY));
      int x = int(random(canvasX));
      
      Tile tile = world[y][x];
      
      if (tile.getFood() == null && tile.getNumberOfBugs() == 0) {
        Bug bug = new Bug(tile);
        
        bug.setTile(tile);
        bugs.add(bug);
    
        world[y][x].bugArrives(bug);
        
        bugsPlaced++;
      }
    }
    println("DONE.");
  }
  
  public void makeWorld() {
    initializeWorld();
    
    placeFood();
    placeBugs();
    
    display();
  }
  
  void display() {
    for (int y = 0; y < canvasY; y++) {
      for (int x = 0; x < canvasX; x++) {
        
        Tile tile = world[y][x];
        tile.display();
      }
    }
  }
  
  public void moveBugs() {
    ArrayList deadBugs = new ArrayList();
    
    for (int i = 0; i < bugs.size(); i++) {
      Bug bug = (Bug) bugs.get(i);
      
      bug.move();
      
      if (bug.getEnergy() == -50) {
        deadBugs.add(bug);
      }

      if (bug.getTile().getNumberOfBugs() > 1) {
        Bug bug1 = (Bug) this.bugs.get(0);
        Bug bug2 = (Bug) this.bugs.get(1);
        
        // Offspring should only be produced when both bugs have enough energy, and none of the bugs are classified as a baby. 
        if (bug1.getEnergy() > 100 && bug2.getEnergy() > 100 && !bug1.isBaby() && !bug2.isBaby() && bug1.isFertile() && bug2.isFertile()) {
          bug1.substractEnergy(50);
          bug2.substractEnergy(50);
          
          bug1.setNumberOfMovesToFertile(3);
          bug2.setNumberOfMovesToFertile(3);
          
          this.bugs.set(0, bug1);
          this.bugs.set(1, bug2);
          
          addNewBug(bug.getTile(), true);
          
          println("A new bug was born!");
        }
      }
    }
    
    while (deadBugs.size() > 0) {
      Bug bug = (Bug) deadBugs.get(0);
      
      Tile tile = bug.getTile();
      tile.bugLeaves(bug);
      bug.setTile(null);
      
      deadBugs.remove(0);
      bugs.remove(bug);
      bug = null;
      
      Food food = new Food(100);
      tile.setFood(food);
      
      tile.display();
    }
    
    if (delayInMillis > 0) delay(delayInMillis);
  }
}
