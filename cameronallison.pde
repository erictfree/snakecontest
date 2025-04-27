//got assistance

//the snake finds food in its proximity. 
//the snake also avoids the walls.


////class CameronAllisonSnake extends Snake { 
////  CameronAllisonSnake(int x, int y) {
////    super(x, y, "CameronAllisonSnake");
////  }

////  @Override
////  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
////    Food closestFood = getClosestFood(this, food);
////    if (closestFood == null) return; // Always good to check

////    PVector head = this.segments.get(0); 

////    float dx = closestFood.x - head.x;
////    float dy = closestFood.y - head.y;

////PVector dir = null;

////    if (dx > 0) {
////      dir = new PVector(1, 0);  // Move right
////    } else if (dx < 0) {
////      dir = new PVector(-1, 0); // Move left
////    } else if (dy > 0) {
////      dir = new PVector(0, 1);  // Move down
////    } else if (dy < 0) {
////      dir = new PVector(0, -1); // Move up
////    }

  
////  PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

////if (edgeDetect(newPos)) {
////}
////if (overlap(newPos, snakes)) {
////  //setDirection(newPos.x, dir.y);

////}
////setDirection(dir.x, dir.y);
//////setDirection(1, 0);
////}
////boolean edgeDetect(PVector pos) {
////  // Assuming 40x30 board (columns x rows)
////  return (pos.x < 0 || pos.x >= 40 || pos.y < 0 || pos.y >= 30);
////}

////boolean overlap(PVector pos, ArrayList<Snake> snakes) {
////  for (Snake s : snakes) {
////    for (PVector part : s.segments) {  // Check every body segment of every snake
////      if (part.x == pos.x && part.y == pos.y) {
////        return true;  // Collision detected
////      }
////    }
////  }
////  return false;  // No collision
////}

////  Food getClosestFood(Snake snake, ArrayList<Food> food) {
////    float min = Float.MAX_VALUE; 
////    Food closestFood = null; 

////    PVector head = snake.segments.get(0);

////    for (int i = 0; i < food.size(); i++) {
////      Food currentFood = food.get(i);
////      PVector pos = new PVector(currentFood.x, currentFood.y);
////      float distance = PVector.dist(head, pos);

////      if (distance < min) {
////        min = distance;
////        closestFood = currentFood;
////      }
////    }
////    return closestFood; 
////  }
////}


////  if (dir != null) {
////    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

////    if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
////      setDirection(dir.x, dir.y);  // Only set direction if it's safe
////    } else {
////      // fallback safe move if original move is bad
////      randomSafeMove(snakes);
////    }
////  }
////  }
  
  
  
//class for snake  
  class CameronAllisonSnake extends Snake { 
  CameronAllisonSnake(int x, int y) {
    super(x, y, "CameronAllisonSnake");
  }

  @Override
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    if (closestFood == null) return;

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    PVector dir = null;
//how the snake moves--which way
    if (dx > 0) {
      dir = new PVector(1, 0);  
    } else if (dx < 0) {
      dir = new PVector(-1, 0); 
    } else if (dy > 0) {
      dir = new PVector(0, 1);  
    } else if (dy < 0) {
      dir = new PVector(0, -1); 
    }

    if (dir != null) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);


//no collision
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        setDirection(dir.x, dir.y);  // Only move if safe
      } else {
        randomSafeMove(snakes); // Try a safe random move if blocked
      }
    }
  }

  boolean edgeDetect(PVector pos) {
    return (pos.x < 0 || pos.x >= 40 || pos.y < 0 || pos.y >= 30);
  }

//snake collision
  boolean overlap(PVector pos, ArrayList<Snake> snakes) {
    for (Snake s : snakes) {
      for (PVector part : s.segments) {
        if (part.x == pos.x && part.y == pos.y) {
          return true;
        }
      }
    }
    return false;
  }

//move random if unsafe
  void randomSafeMove(ArrayList<Snake> snakes) {
    PVector[] options = {
      new PVector(1, 0), new PVector(-1, 0), new PVector(0, 1), new PVector(0, -1)
    };

    ArrayList<PVector> safeMoves = new ArrayList<PVector>();
    PVector head = this.segments.get(0);

    for (PVector dir : options) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        safeMoves.add(dir);
      }
    }

    if (safeMoves.size() > 0) {
      PVector pick = safeMoves.get((int)random(safeMoves.size()));
      setDirection(pick.x, pick.y);
    }
  }
//get close food to grow
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = Float.MAX_VALUE; 
    Food closestFood = null; 
    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) {
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
