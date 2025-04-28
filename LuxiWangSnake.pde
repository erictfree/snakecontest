// this is a basic snake with no other special strat other than to eat and survive
class LuxiWangSnake extends Snake {
  
  LuxiWangSnake(int x, int y) {
    super(x, y, "LuxiWangSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    if (!checkSurvival(snakes)) { // if danger ahead
      avoidCollision(snakes); // avoid
    } else {
      Food closestFood = getClosestFood(this, food); // go ahead
      PVector head = this.segments.get(0);
      
      float dx = closestFood.x - head.x;
      float dy = closestFood.y - head.y;
      PVector dir = getDirectionToFood(dx, dy);

      // Predict next move
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      // if going to hit wall
      if (edgeDetect(newPos) || overlap(newPos, snakes) || checkSelfCollision(newPos)) {
        avoidCollision(snakes); // avoid
      } else {
        setDirection(dir.x, dir.y); // keep going
      }
    }
  }

  // Determines direction to move toward food
  PVector getDirectionToFood(float dx, float dy) {
    if (dx > 0) {
      return new PVector(1, 0);  // right
    } else if (dx < 0) {
      return new PVector(-1, 0); // left
    } else if (dy > 0) {
      return new PVector(0, 1);   // down
    } else {
      return new PVector(0, -1);  // up
    }
  }

  // will snake crash into enemy next move
  boolean checkSurvival(ArrayList<Snake> snakes) {
    PVector head = this.segments.get(0); // current head pos
    PVector nextHead = new PVector(head.x + direction.x, head.y + direction.y); // where head will be next
    
    if (edgeDetect(nextHead) || overlap(nextHead, snakes) || checkSelfCollision(nextHead)) {
      return false;  // Will crash
    }
    return true;     // Safe to continue
  }

  // will snake crash into self next move
  boolean checkSelfCollision(PVector nextHead) {
    for (int i = 1; i < segments.size(); i++) {
      PVector p = segments.get(i);
      if (p.x == nextHead.x && p.y == nextHead.y) {
        return true; // self collision
      }
    }
    return false;    // no self collision
  }

  // Attempt to pick a safe direction to avoid collision
  void avoidCollision(ArrayList<Snake> snakes) {
    ArrayList<PVector> posDir = new ArrayList<PVector>();
    
    // Try possible directions
    posDir.add(new PVector(1, 0));  // Right
    posDir.add(new PVector(-1, 0)); // Left
    posDir.add(new PVector(0, 1));  // Down
    posDir.add(new PVector(0, -1)); // Up
   //when next pos safe
    for (PVector dir : posDir) {
      PVector newPos = new PVector(segments.get(0).x + dir.x, segments.get(0).y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes) && !checkSelfCollision(newPos)) {
        setDirection(dir.x, dir.y); // Pick safe move
        return;
      }
    }
  }

  // Find closest food to snake
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float minDist = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0); // snake head pos
    // check each food near
    for (int i = 0; i < food.size(); i++) {
      Food currentFood = food.get(i);
      PVector foodPos = new PVector(currentFood.x, currentFood.y);
      float distance = PVector.dist(head, foodPos); // found distance
      // if new identified food closer to previous
      if (distance < minDist) {
        minDist = distance;
        closestFood = currentFood; // update new food target
      }
    }
    return closestFood; // keep old food target
  }
}
