// SimpleSnake class - moves randomly with no intelligence

class JosiahVillarrealFloresSnake extends Snake {
  JosiahVillarrealFloresSnake(int x, int y) {
    super(x, y, "JosiahVillarreal");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
   ///finds the closest piece of food
   Food closestFood = getClosestFood(this, food);

   ///gets the position of the head
   PVector head = this.segments.get(0);
 
   ///how far the food is from the head
   float dx = closestFood.x - head.x; 
   float dy = closestFood.y - head.y;
   
    ///movement options
    PVector dir = null;
    if (dx > 0) {
     dir = new PVector(1, 0);
    } else if (dx < 0) {
      dir = new PVector(-1, 0); 
    } else if (dy > 0) {
      dir = new PVector (0, 1);
    } else if ( dy < 0) {
      dir = new PVector(0, -1);
    }
    
    ///calculates where the head would move
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    
    if (edgeDetect(newPos)) { /// hits a wall
      tryOtherDirections(snakes); ///if it is about to hit an edge, tries another way
    }
    
    if (overlap(newPos, snakes)) { /// hits a snake
      tryOtherDirections(snakes); ///If it is close to hitting a snake, try another direction
    }
    
    ///check if moving would crash into itself
    if (!collidingWithSelf(newPos)) {
     setDirection(dir.x, dir.y); ///if safe continue normal movement
    } else {///otherwise try a different direction
      tryOtherDirections(snakes);
    }
  }
  
  ///function to check if a position would collide with itself
  boolean collidingWithSelf(PVector pos) {
    for (int i = 1; i < segments.size(); i++) {///skips the head index at 0
      PVector part = segments.get(i);
      if (part.x == pos.x && part.y == pos.y) {
        return true;///would crash
      }
    }
    return false;///safe
  }
  
  ///function to try moving in a different direction
  void tryOtherDirections (ArrayList<Snake> snakes) {
    PVector head = this.segments.get(0);
    ///list of possible directions R, L, D, U
    PVector[] directions = {
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };
    
    ///tries each direction
    for (PVector dir : directions) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      ///tries to avoid, itself, walls and other snakes
      if (!collidingWithSelf(newPos) && !edgeDetect(newPos) && !overlap(newPos, snakes)) { ///move in the first safe direction
        setDirection(dir.x, dir.y);
        return;
      }
    }
  }
  
  ///function to get the closest food
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
  
    PVector head = snake.segments.get(0);
  
    for(int i = 0; i < food.size(); i++) {
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
