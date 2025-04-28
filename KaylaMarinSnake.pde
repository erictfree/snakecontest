// My snake uses a closest food function to detect and go for the closest food its near
// while simultaneously scanning its surroundings for the best path to avoid collision
// with the wall and other snakes. I also added a helper funtion to predict if my snake
// will run into it's body once it gets longer. This will cause the snake to intentionally
//avoid paths that may cause it to trap itself (this is unfotunately not 100%
class KaylaMarinSnake extends Snake {
  KaylaMarinSnake(int x, int y) {
    super(x, y, "KaylaMarin");
    //can add "updateInterval=...;" to control speed
  }

  //---------------Thinking-------------------------------------------------------------------------

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // Find the closest food once
    Food closestFood = getClosestFood(this, food);

    if (closestFood == null) return; // no food to chase then do nothing

    PVector head = this.segments.get(0); //head position

    // Define possible directions
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1),  // Down
      new PVector(0, -1)  // Up
    };

    PVector bestMove = null; //found best move
    float bestDist = Float.MAX_VALUE; //shortest distance

//evaluate possible moves
    for (PVector move : possibleDirs) {
      float newX = head.x + move.x;
      float newY = head.y + move.y;

      if (isMoveSafe(newX, newY, snakes)) { //check is safe move
      
        // check if this move would get to food
        float distance = abs(newX - closestFood.x) + abs(newY - closestFood.y);

//if its closer than current best move then keep
        if (distance < bestDist) {
          bestDist = distance;
          bestMove = move;
        }
      }
    }

    if (bestMove != null) { //make best move
      setDirection(bestMove.x, bestMove.y);
    }
    // else: no good move, keep going same way
  }

  // --- helper function 1 -------------------------------------------
  boolean isMoveSafe(float x, float y, ArrayList<Snake> snakes) {
    
  // wall and collision with snakes check
  if (x < 0 || x >= width/GRIDSIZE || y < 0 || y >= height/GRIDSIZE) { //game follows grid so found this
    return false;
  }
  //check if move will hit snake
  for (Snake snake : snakes) {
    for (PVector segment: snake.segments) {
      if (x == segment.x && y == segment.y) {
        return false;
      }
    }
  }

  // Check if snake will trap itself 
  if (this.segments.size() > 5) { // Only implement when above 5 segment
  
    PVector[] possibleDirs = {
      new PVector(1, 0), 
      new PVector(-1, 0), 
      new PVector(0, 1), 
      new PVector(0, -1)
    };
    
    boolean avoid = false; 
    
    //check for escape
    for (PVector dir : possibleDirs) {
      float testXdir = x + dir.x;
      float testYdir = y + dir.y;

      boolean safe = true;
      //debug = true;
      
      // Check wall
      if (testXdir < 0 || testXdir >= width/GRIDSIZE||testYdir < 0 ||testYdir >= height/GRIDSIZE) {
        safe = false;
  }
      
      //collision check
   for (Snake snake: snakes){
      for (PVector segment: snake.segments) {
        
         if (testXdir == segment.x && testYdir == segment.y) {
            safe = false;
            break; //stops looping
          }
        }
        if (!safe) break;
      }

      if (safe) {
        avoid = true;
        break; // found at least one escape
      }
    }
    
    if (!avoid) {
      return false; // No escape then avoid move
    }
  }
  
  return true; 
}
  // --- Close Food Function (helper function 2) - inclass ------------------------------
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);
    for (int i = 0; i < food.size(); i++) {
      Food currentFood = food.get(i);


      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos); //calculate food distance

      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    
    
    return closestFood;
  }
}
