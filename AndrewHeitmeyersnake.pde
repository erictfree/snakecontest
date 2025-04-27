

class AndrewHeitmeyersnake extends Snake {
  AndrewHeitmeyersnake(int x, int y) {
    super(x, y, "BestSnake");
    //this.updateInterval =  
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    //Food closestFood = getCLosestFood(this, food);

    PVector head = this.segments.get(0);

    //float dx =closestFood.x - head.x;
    //float dy = closestFood.y - head.y;


    PVector dir = null;

    //if (dx > 0) {
    //  dir = new PVector(1, 0);
    //} else if (dx < 0) {
    //  dir = new PVector(-1, 0);
    //} else if (dy < 0) {
    //  dir = new PVector(0, -1);
    //} else if (dy > 0) {
    //  dir = new PVector(0, 1);
    //}




    //PVector newPos = new PVector (head.x + dir.x, head.y + dir.y);

//    if (edgeDetect(newPos)) { //hit wall incoming 
//    }

//    if (overlap(newPos, snakes)) { //hit snake
 
//    }

//below is freeman code 
   
      // Define all possible directions
      PVector[] possibleDirs = {
        new PVector(1, 0), // Right
        new PVector(-1, 0), // Left
        new PVector(0, 1), // Down
        new PVector(0, -1)  // Up
      };

      // Track the best move we find
      PVector bestDir = null;
      float bestDist = Float.MAX_VALUE;

      // Check each possible direction
      for (PVector direction : possibleDirs) {  // remember this new kind of for loop?
        // Calculate new position if we move in this direction
        float newX = head.x + direction.x;
        float newY = head.y + direction.y;

        boolean hitSomething = false;
        // Check if this move would hit a wall
        if (newX < 0 || newX >= width/GRIDSIZE || newY < 0 || newY >= height/GRIDSIZE) {
          hitSomething = true;
        }

        // Check if this move would hit any snake (including our own)
        for (Snake snake : snakes) {
          for (PVector segment : snake.segments) {
            if (newX == segment.x && newY == segment.y) {
              hitSomething = true;  
              break;  // no need to continue loop
            }
          }
          if (hitSomething){
            this.updateInterval = 500;
            break;   // no need to continue loop
        }

        if (!hitSomething) {
          // If we get here, this is a valid move
          // Find closest food and calculate distance
          Food closestFood = getClosestFood(this, food);
            this.updateInterval = 50;  
          if (closestFood != null) {
            float newDist = abs(newX - closestFood.x) + abs(newY - closestFood.y);

            // If this is the best move so far, remember it
            if (newDist < bestDist) {
              bestDist = newDist;
              bestDir = direction;
            }
          }
        }

        if (bestDir != null) {
          setDirection(bestDir.x, bestDir.y);
        }
        // otherwise we continue in same direction
      }
    
    
    
    
    //aboce is freeman code
//}
    //setDirection(dir.x, dir.y);
  }
}

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 900;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) {  //every peice of food
      Food currentFood= food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos);

      if ( distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
}
