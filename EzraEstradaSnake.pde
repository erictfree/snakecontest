// EzraEstradaSnake class - moves randomly with no intelligence

class EzraEstradaSnake extends Snake {
  EzraEstradaSnake(int x, int y) {
    super(x, y, "EzraEstrada");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) { //finds nearest food
    Food closestFood = getClosestFood(this, food);
    
    PVector head = this.segments.get(0); //gets head position
    
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    
    PVector dir = null; //holds direction
    
    //decides direction to move towards food
    if (dx > 0) {
      dir = new PVector(1, 0); //right
    } else if (dx < 0) {
      dir = new PVector(-1, 0); //left
    } else if (dy > 0) {
      dir = new PVector(0, 1); //down
    } else if (dy < 0) {
      dir = new PVector(0, -1); //up
    }
    
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y); //calculates where head will move
    
    if (edgeDetect(newPos)) { //hit a wall
      //println("hit wall!");
    }
    
    if (overlap(newPos, snakes)) { //hit a snake
      //println("hit snake!");
    }
    
    if (selfOverlap(newPos)) { //hit itself
      //println("hit self!");
      dir = pickSafeDirection(head, snakes); //pick safe direction instead
    }
    
    setDirection(dir.x, dir.y); //set safe direction
  }
  
  //checks if snake will hit itself
  boolean selfOverlap(PVector pos) {
    for (PVector segment : this.segments) {
      if (pos.x == segment.x && pos.y == segment.y) {
        return true; //found overlap with body
      }
    }
    return false; //no overlap, snake safe :)
  }
  
  //picks safe direction (avoiding walls, snakes, itself) 
  PVector pickSafeDirection(PVector head, ArrayList<Snake> snakes) {
    PVector[] dirList = {
      new PVector(1, 0), 
      new PVector(-1, 0),
      new PVector(0, 1), 
      new PVector(0, -1)
    };
    
    //check directions for safety
    for (PVector dir : dirList) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes) && !selfOverlap(newPos)) {
        return dir; //found safe direction
      }
    }
    //if no safe direction found, just move right
    return new PVector(1, 0);
  }
  
  //finds & returns closest food to snake head
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null; //stores closest food found
    
    PVector head = snake.segments.get(0); //snake head position
    
    //iterates every piece of food
    for(int i = 0; i < food.size(); i++) { 
      Food currentFood = food.get(i); //get current food
      
      PVector pos = new PVector(currentFood.x, currentFood.y); //food position
      
      float distance = PVector.dist(head, pos); //calculate head to food distance
      
      //if new food closer then previous closest
      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
}
