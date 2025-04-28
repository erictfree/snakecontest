//my snake's main strategy is to prioritize food. But it does other tasks like avoiding other snakes and walls. Its not aggressive or anything so
//its greatest weakness is getting cornered by other snakes since it doesn't know how to cut off other snakes, 
//weakness: closing in on itself, or getting trapped by other snakes
//strenghths: minds its own business and looks for food


class EverestNguyenSnake extends Snake {
  EverestNguyenSnake(int x, int y) {
    super(x, y, "EverestNguyenSnake");
    //control the speed
    updateInterval = 50;

  }
  
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    
    PVector head = this.segments.get(0);
    
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    
    PVector dir = new PVector(0, 0); 
    PVector currentDir = new PVector(direction.x, direction.y);
    
    // finding food, make it follow directions based on distance
    if (abs(dx) > abs(dy)) { //absolute values of snake distance from food
      if (dx > 0) {
        dir = new PVector(1, 0); //x or horizontal movements
      } else {
        dir = new PVector(-1, 0); // y vertical movements 
      }
    } else {
      if (dy > 0) { //food is under snake
        dir = new PVector(0, 1);
      } else {
        dir = new PVector(0, -1); //food is above snake
      }
    }
    // try different directions 
    if (dir.x != -currentDir.x || dir.y != -currentDir.y) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      // Check for walls and other snakes
      if (edgeDetect(newPos)) { // Hit a wall
        // Try alternative directions
        tryAlternativeDirections(head, currentDir, snakes);
      } else if (overlap(newPos, snakes)) { // Hit a snake
      //println("detect snake");
        tryAlternativeDirections(head, currentDir, snakes);
      } else {
        setDirection(dir.x, dir.y);
      }
    } else {
      tryAlternativeDirections(head, currentDir, snakes);
    }
  }
  
  void tryAlternativeDirections(PVector head, PVector currentDir, ArrayList<Snake> snakes) {
    // Try all possible directions except the opposite of current direction
    PVector[] directions = {
      new PVector(1, 0),
      new PVector(-1, 0),
      new PVector(0, 1),
      new PVector(0, -1)
    };
    
    for (PVector dir : directions) {
      // Skip if this is the opposite of current direction
      if (dir.x == -currentDir.x && dir.y == -currentDir.y) continue;
      
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      // Check if this direction is safe
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        setDirection(dir.x, dir.y);
        return;
      }
    }
    
    // If no safe direction, just continue in current direction
    setDirection(currentDir.x, currentDir.y);
  }
  
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
  
  
  //decorating my snake
  void drawSegment(int index, float x, float y, float size) {
    push();
    noStroke();
    colorMode(HSB);
    ellipseMode(CORNER);
    int c = (int)map(index, 0, this.segments.size(), 0, 255); //pastel rainbow snake
    float s = map(index, 0, this.segments.size(), size+6, size-6); //change the weight of the snake
    fill(c, 55, 250); //pastel rainbow snake
    ellipse(
      x,
      y,
      s,
      s
    );
    pop();
  }
}
