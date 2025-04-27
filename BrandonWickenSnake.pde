// SimpleSnake class - moves randomly with no intelligence

class BrandonWickenSnake extends Snake {
  BrandonWickenSnake(int x, int y) {
    super(x, y, "BrandonWicken");
  }

  /* Basic logic is to find what directions are available without hitting anything, then search for 
  nearby food horizontally to the right, then left, then vertically up, and down before finally moving 
  towards the first one it detected, in that order. P.S. It doesn't always work as I intended, but its 
  difficult to know if its just my monitor being too small to display all the walls */

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    
    PVector head = this.segments.get(0); // get the current head position
    
    //float dx = closestFood.x - head.x; // figure out how far the food is
    //float dy = closestFood.y - head.y; // in x and y distances
    
    // useful array for possible directions
    PVector[] possibleDirs = {
      new PVector(1, 0),   // Right
      new PVector(0, 1),   // Down
      new PVector(-1, 0),  // Left
      new PVector(0, -1)   // Up
    };
    
    // find available direction by going through all available
    for (PVector dir : possibleDirs) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      // if direction doesn't hit a wall or snake
      if (!edgeDetect(newPos) || !overlap(newPos, snakes)) {  
        if (closestFood.x > head.x) { // go right
          dir.x = 1;
        } else if (closestFood.x < head.x) { //or else go left, etc.
          dir.x = -1;
        }
        // find closest food up and down
         else if (closestFood.y > head.y) {
          dir.y = 1;
        } else if (closestFood.y < head.y) {
          dir.y = -1;
        }
      setDirection(dir.x, dir.y);
      }
    }
  }


  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    
    PVector head = snake.segments.get(0);
    
    for(int i = 0; i < food.size(); i++) { //every piece of food
      Food currentFood = food.get(i);
      
      PVector pos = new PVector(currentFood.x, currentFood.y); //temp for computing distance
      
      float distance = PVector.dist(head, pos);
      
      if (distance < min) {
        min = distance;
        //println("distance is " + distance);
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
}
