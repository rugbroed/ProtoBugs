// **************************************************
// ****               PROTO BUGS                 ****
// ****                                          ****
// ****  Totally free source code, originally    ****
// ****  made as an inspiration for a course     **** 
// ****  on interactivity at IT-University of    ****
// ****  Copenhagen by kben@itu.dk.              ****
// ****                                          ****
// **************************************************

import java.util.Iterator;
import java.util.Map;
import java.awt.event.*;

int delayInMillis = 0;

// Small setup
int canvasX = 100;
int canvasY = 100;
int tileSize = 10;
int initialize_FOOD_AMOUNT = 200;
int initialize_BUGS_AMOUNT = 50;

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

int bugViewSize = 3;

void setup() {
  background(128, 128, 128);
  
  stroke(0, 0, 0);
  
  size(canvasX * tileSize, canvasY * tileSize);
  frameRate(24);

  makeWorld();
}

void mousePressed() {
  int x = int(mouseY / tileSize);
  int y = int(mouseX / tileSize);
  
  println("x: " + x + ", y: " + y);
  
  Tile tile = world[y][x];
  Bug bug = new Bug(tile);
  bugs.add(bug);

  tile.bugArrives(bug);
  tile.display();
}

void draw() {
  moveBugs();
}

void makeWorld() {
  initializeWorld();
  
  placeFood();
  placeBugs();
  
  renderTiles();
}

void renderTiles() {
  for (int y = 0; y < canvasY; y++) {
    for (int x = 0; x < canvasX; x++) {
      
      Tile tile = world[y][x];
      tile.display();
    }
  }
}

void initializeWorld() {
  for (int y = 0; y < canvasY; y++) {
    for (int x = 0; x < canvasX; x++) {
      
      Tile tile = new Tile(y, x);
      //Tile tile = new Tile();
      world[y][x] = tile;
      
      tile.display();
    }
  }
}

void placeFood() {
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
}

void placeBugs() {
  int bugsPlaced = 0;
  while (bugsPlaced < initialize_BUGS_AMOUNT) {
    int y = int(random(canvasY));
    int x = int(random(canvasX));
    
    Tile tile = world[y][x];
    
    if (tile.getFood() == null && tile.getBug() == null) {
      Bug bug = new Bug(tile);
      
      bug.setTile(tile);
      bugs.add(bug);
  
      world[y][x].bugArrives(bug);
      
      bugsPlaced++;
    }
  }
}


void moveBugs() {
  ArrayList deadBugs = new ArrayList();
  
  for (int i = 0; i < bugs.size(); i++) {
    Bug bug = (Bug) bugs.get(i);
    
    bug.move();
    
    if (bug.getEnergy() == -50) {
      deadBugs.add(bug);
    }
  }
  
  while (deadBugs.size() > 0) {
    Bug bug = (Bug) deadBugs.get(0);
    
    Tile tile = bug.getTile();
    bug.setTile(null);
    tile.setBug(null);
    
    deadBugs.remove(0);
    bugs.remove(bug);
    bug = null;
    
    Food food = new Food(100);
    tile.setFood(food);
    
    tile.display();
  }
  
  if (delayInMillis > 0) delay(delayInMillis);
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
  Bug bug = null;

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

  public void setBug(Bug bug) {
    this.bug = bug;
  }

  public Bug getBug() {
    return bug;
  }
  
  public void bugLeaves() {
    this.bug = null;
  }
  
  public void bugArrives(Bug bug) {
    this.bug = bug;
  }
  
  void display() {
    if (getBug() != null) {
      
      if (getBug().getEnergy() <= 0) {
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
    //direction = 1;
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
    tile.bugLeaves();
    tile.display();
    
    tile = world[cp.getY()][cp.getX()];
    tile.bugArrives(this);

    if (tile.getFood() != null) {
      consume(tile.getFood());
      tile.setFood(null);
    }
    
    tile.display();
    
    setTile(tile);
  }
}

