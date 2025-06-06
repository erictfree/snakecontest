

// prioritize food by going fast at the start to bulk up. once hits a good size, slow down but still go for food. if another snake head get close, go as fast as possible to escape or kill. also checks diretion to ensure it doesnt collide


class AlanaLeeSnake extends Snake {
  int evenodd = 0;
  boolean hitSomething;
  PVector[] possibleDirs = {
    new PVector(1, 0), // Right
    new PVector(-1, 0), // Left
    new PVector(0, 1), // Down
    new PVector(0, -1)   // Up
  };
  
   PVector lastDir;
  

  AlanaLeeSnake(int x, int y) {
    super(x, y, "Lovejoy");
    // updateInterval= 1000000000; //less is faster
    //this.debug = true;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {

    for (Snake snake : snakes) {
      float distance = dist(this.segments.get(0).x, this.segments.get(0).y, snake.segments.get(0).x, snake.segments.get(0).y);
      if (distance <= 20) {
        updateInterval= 1; //less is faster
      } else if (this.segments.size() >= 50 ) {
        updateInterval= 100; //less is faster
      } else {
        updateInterval= 10; //less is faster
      }
    }



    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); // get the front of the snake, the head

    float dx = closestFood.x - head.x;  // figure out how far the food is
    float dy = closestFood.y - head.y;  // in x and y distances

    // dir represents the direction we are going to move in N/S/E/W
    PVector dir = null;
          if (lastDir == null) {
      lastDir = dir;
      }

    // check to see if snake needs to left or right until in same column as food
    // then check to see if it needs to go up or down
    // note: this is a totally arbitrary way to go about it, you may want to do it
    // differently--say prefer y direction first, or randomly favor x or you
    // or use the one that is closest.
    if (evenodd % 2 == 0) {
      if (hitSomething == false) {
        if (dx > 0) {
          dir = new PVector(1, 0);
        } else if (dx < 0) {
          dir = new PVector(-1, 0);
        } else if (dy > 0) {
          dir = new PVector(0, 1);
        } else if (dy < 0) {
          dir = new PVector(0, -1);
        } else {
        }
      }
   }
    
     if (evenodd % 2 != 0) {
    //       PVector newDir = possibleDirs[(int)random(possibleDirs.length)];
    //setDirection(newDir.x, newDir.y);
      if (hitSomething == false) {
        if (dx < 0) {
          dir = new PVector(1, 0);
        } else if (dx > 0) {
          dir = new PVector(-1, 0);
        } else if (dy < 0) {
          dir = new PVector(0, 1);
        } else if (dy > 0) {
          dir = new PVector(0, -1);
        } else {
        }
      }
    }
    hitSomething = false;

    //newPos represents the actual grid location we want to move in
    // say the snake head is grid location (20, 31), if
    // dir is (-1, 0), meaning we want to move left, then
    // newPos would be (20+dir.x, 31+dir.y) or (19, 31)
    //

    // Check if this move would hit any snake (including our own)
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    
    if (edgeDetect(newPos) || overlap(newPos, snakes)) {  // direction hits a wall or snake
      // what do we do? this is your strategy of how you handle this
      for (int i = 0; i < possibleDirs.length; i++) {
        PVector tempDir = possibleDirs[i];
        PVector tempPos = new PVector(head.x + tempDir.x, head.y + tempDir.y);

        if (!edgeDetect(tempPos) && !overlap(tempPos, snakes) && (-possibleDirs[i].x != lastDir.x ||  lastDir.x == 0) && (-possibleDirs[i].y != lastDir.y ||  lastDir.y == 0)) {
          dir = new PVector(possibleDirs[i].x, possibleDirs[i].y );
          evenodd += 1;
          break;
        }
      }
    }

    // right now we plow ahead, ignoring if we are going to hit something
    // a first step might be to just randomly choose any other direction
    // or you could loop until you've found a safe direction, etc.
    if (hitSomething == false) {
      setDirection(dir.x, dir.y);
    }
    lastDir = dir;
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;

    PVector head = snake.segments.get(0);

    for (int i = 0; i < food.size(); i++) { // every piece of food
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
