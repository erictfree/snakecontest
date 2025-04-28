
class CrystalNguyenSnake extends Snake {
  CrystalNguyenSnake(int x, int y) {
    super(x, y, "CrystalNguyenSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // Get current head position
    PVector head = this.segments.get(0);
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
    for (PVector dir : possibleDirs) {
      // Calculate new position if we move in this direction
      float newX = head.x + dir.x;
      float newY = head.y + dir.y;
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
        if (hitSomething) break;   // no need to continue loop
      }
      if (!hitSomething) {
        // If we get here, this is a valid move
        // Find closest food and calculate distance
        Food closestFood = getClosestFood(this, food);
        if (closestFood != null) {
          float newDist = abs(newX - closestFood.x) + abs(newY - closestFood.y);
          // If this is the best move so far, remember it
          if (newDist < bestDist) {
            bestDist = newDist;
            bestDir = dir;
          }
        }
      }
    }
    if (bestDir != null) {
      setDirection(bestDir.x, bestDir.y);
    }
    // otherwise we continue in same direction
  }
  
  Food getClosestFood(Snake snake, ArrayList<Food> food) { // look for closest food
    float min = 1000;
    Food closestFood = null;
    
    PVector head = snake.segments.get(0); // all body segments of snake
    
    for(int i = 0; i < food.size(); i++) { // every piece of food
      Food currentFood = food.get(i);
      
      PVector pos = new PVector(currentFood.x, currentFood.y); // move to current food which is set to closest food
    
      float distance = PVector.dist(head, pos); // distance is head and position distance
    
      if (distance < min) { // if distance of closest food is close, set closest food as current food
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  
  void drawSegment(int index, float x, float y, float size) { // snake decoration
    fill(#fecccb);
    stroke(0);
    rect(
      x,
      y,
      size,
      size,
      20  // Fixed roundness
    );
  }
}
