class AdahSkaffSnake extends Snake {
  // initialize the snake
  AdahSkaffSnake(int x, int y) {
    super(x, y, "AdahMoon");  // 
  }

  // decision-making
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    // find the closest food to my snake
    Food closestFood = getClosestFood(this, food);
    
    //where is the food in relation to snake's head?
    PVector head = this.segments.get(0);
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    // snake movement
    PVector[] directions = {
      new PVector(1, 0),  // Move right
      new PVector(-1, 0), // Move left
      new PVector(0, 1),  // Move down
      new PVector(0, -1)  // Move up
    };

    // move in the safest direction
    PVector bestDir = null;
    for (PVector dir : directions) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

      // dont go someshere you'll hit a wall or snake or get to close to an enemy's head
      if (edgeDetect(newPos)) continue;
      if (overlap(newPos, snakes)) continue;
      if (isNearOtherSnakeHead(newPos, snakes)) continue;
      // prefer directions towards food
      if (bestDir == null || (dx * dir.x > 0 || dy * dir.y > 0)) {
        bestDir = dir;
      }
    }

    // go in the safest direction if there is one
    if (bestDir != null) {
      PVector newPos = new PVector(head.x + bestDir.x, head.y + bestDir.y);

      // Check if new position hits a wall
      if (edgeDetect(newPos)) {
        println("hit wall :(");
      }

      // Check if new position collides with another snake
      if (overlap(newPos, snakes)) {
        println("hit snake!");
      }
      setDirection(bestDir.x, bestDir.y);
    } else {
      // if no safest direction, choose randomely and hope for the best
      for (PVector dir : directions) {
        PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
        // try to choose a direction with nothing to collide into
        if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
          setDirection(dir.x, dir.y);
          return;
        }
      }
      // freeze if no safe move
      setDirection(0, 0);
    }
  }

  // find the closest food to my snake's head
  Food getClosestFood(Snake snake, ArrayList<Food> foodList) {
    float min = 1000;  
    Food closestFood = null;  
    PVector head = snake.segments.get(0);  

    // look at all the food options and see what's closest
    for (int i = 0; i < foodList.size(); i++) {
      Food currentFood = foodList.get(i);  
      PVector pos = new PVector(currentFood.x, currentFood.y);  
      float distance = PVector.dist(head, pos);  
      if (distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }

    if (min < 5) {
      updateInterval = 60;  //go faster when near food
    } else {
      updateInterval = 200; // go slower when not near food
    }

    return closestFood; 
  }

  //try to stay 3 spaces away from enemy snake heads
  boolean isNearOtherSnakeHead(PVector pos, ArrayList<Snake> snakes) {
    for (Snake s : snakes) {
      //don't worry abt dead snakes
      if (s == this || !s.isAlive()) continue;

     
      PVector otherHead = s.segments.get(0);

      // avoid moving in a direction that's 3 grid spaces away from enemy snake heads
      float dist = abs(pos.x - otherHead.x) + abs(pos.y - otherHead.y);
      if (dist <= 3) return true;
    }
    return false;
  }
  void drawSegment(int index, float x, float y, float size) {
    push();  // Save the current drawing state
  
    //rainbow snake effect 
    colorMode(HSB);  
    int c = int(map(index, 0, this.segments.size(), 0, 255));

    //snake tail segments get consecutively shorter
    float s = map(index, 0, this.segments.size(), size, size - 5);

    // draw snake segments
    fill(c, 255, 255);  
    rect(x, y, s, s);   
   
   //draw smaller squares (vera molnar assignment-inspired) in snake segments for coolness
    int num = 3;  
     float smallSize = s / 2;
  for (int i = 0; i < num; i++) {
        float offsetX = sin(i) * (s / 3); 
        float offsetY = cos(i) * (s / 3); 
        rect(x + offsetX, y + offsetY, smallSize, smallSize);
      }
    
    pop();  
  }
}
