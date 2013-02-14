// **************************************************
// ****               PROTO BUGS                 ****
// ****                                          ****
// ****  Proto Bugs is free for non-commercial   ****
// ****  use and further development. If you     ****
// ****  like the idea, please help make it      ****
// ****  better.                                 ****
// ****                                          ****
// ****  Proto Bugs was originally made as an    ****
// ****  inspiration for the students at a       ****
// ****  course on interactivity at the          ****
// ****  IT-University of Copenhagen             ****
// ****  by kben@itu.dk.                         ****
// ****                                          ****
// ****  Current functionality                   ****
// ****                                          ****
// ****    -  Bugs are initialized and move      ****
// ****       around randomly (energy: 100).     ****
// ****    -  Bugs are 'white' if they have      ****
// ****       plenty of energy (> 0). If their   ****
// ****       energy levels drop below 0, they   ****
// ****       are 'red'. If the energy level     ****
// ****       drops below -50 they die, and      ****
// ****       they turn into food.               ****
// ****    -  Food are initialized and placed    ****
// ****       randomly (energy: a random number  ****
// ****       between 1 and 200). Food is        ****
// ****       'green'                            ****
// ****    -  Bugs can be manually placed by     ****
// ****       clicking with the mouse.           ****
// ****                                          ****
// ****  Features suggestions:                   ****
// ****                                          ****
// ****    1. Bugs should learn about their      ****
// ****       surroundings, and incorporate      ****
// ****       this in their DNA.                 ****
// ****                                          ****
// ****    2. If two bugs are at the same tile   ****
// ****       and they energy levels are above   ****
// ****       200 they should produce ofspring   ****
// ****       and each should decrease 50 in     ****
// ****       energy.                            ****
// ****                                          ****
// ****                                          ****
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
  world.addNewBug(tile);
}

void draw() {
  world.moveBugs();
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
  
  void display() {
    if (this.bugs.size() > 0) {
      Bug bug = (Bug) this.bugs.get(0);
      
      if (bug.getEnergy() <= 0) {
        fill(255, 0, 0);
      }
      else {
       fill(255, 255, 255); 
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
  int energy = 100;

  Move lastMove = null;
  
  Tile tile;
  
  Bug(Tile tile) {
    this.tile = tile;
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
    
    //tile = world[cp.getY()][cp.getX()];
    tile = world.getTile(cp.getY(), cp.getX());
    tile.bugArrives(this);

    if (tile.getFood() != null) {
      consume(tile.getFood());
      tile.setFood(null);
    }
    
    tile.display();
    
    setTile(tile);
  }
}

public class World {
  // Small setup
  int initialize_FOOD_AMOUNT = 200;
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
  
  public void addNewBug(Tile tile) {
    Bug bug = new Bug(tile);
    bugs.add(bug);
  
    tile.bugArrives(bug);
    tile.display();
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
    
    while (foodPlaced < initialize_FOOD_AMOUNT) {
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
      /*
      if (bug.getTile().getNumberOfBugs() > 1) {
        Bug bug1 = this.bugs.get(0);
        Bug bug2 = this.bugs.get(1);
      }
      */
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
