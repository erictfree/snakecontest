//Strategy: Strategy is simply looking for food and avoiding the collosion with own body and other snakes
//(went to office hours)

class AngelDuranGonzalezSnake extends Snake {
  AngelDuranGonzalezSnake(int x, int y) {
    super(x, y, "AngelDuranGonzalez");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); // get the front of the snake, the head

    float dx = closestFood.x - head.x;  // figure out how far the food is
    float dy = closestFood.y - head.y;  // in x and y distances

    // dir represents the direction we are going to move in N/S/E/W
    PVector dir = null;

    if (dx > 0) {
      dir = new PVector(1, 0); //up
    } else if (dx < 0) {
      dir = new PVector(-1, 0); //left
    } else if (dy > 0) {
      dir = new PVector(0, 1); //down
    } else if (dy < 0) {
      dir = new PVector(0, -1); //up
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

    // checks to see if about to collide, if so finds a safer position to proceed
    if (edgeDetect(newPos) || overlap(newPos, snakes) || willCollideWithSelf(newPos)) {
      dir = findSafeDirection(snakes);  
      if (dir == null) {
        
        return;
      }
      newPos = new PVector(head.x + dir.x, head.y + dir.y);
    }

    //sets the chosen direction to be safe
    setDirection(dir.x, dir.y);
  }

  // Helper method to check if the snake is about to collide with itself
  boolean willCollideWithSelf(PVector newPos) {
    for (int i = 1; i < segments.size(); i++) {  // Start from 1 because 0 is the head
      PVector segment = segments.get(i);
      if (newPos.x == segment.x && newPos.y == segment.y) {
        return true;  //if collision is detected
      }
    }
    return false;  //no collision
  }

  //tries to find a safe direction for the snake without colliding into body
  PVector findSafeDirection(ArrayList<Snake> snakes) {
    PVector[] directions = {
      new PVector(1, 0),   // Right
      new PVector(-1, 0),  // Left
      new PVector(0, 1),   // Down
      new PVector(0, -1)   // Up
    };

    for (PVector dir : directions) {
      PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!willCollideWithSelf(newPos) && !edgeDetect(newPos) && !overlap(newPos, snakes)) {
        return dir;  //returns safe direction
      }
    }

    return null;  //trapped
  }

  //looks for the closest food for the snake to proceed to eat it
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { // Every piece of food
      Food currentFood = food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y);

      float distance = PVector.dist(head, pos);

      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
}
