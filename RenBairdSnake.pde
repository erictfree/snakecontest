class RenBairdSnake extends Snake {
  boolean pointMode = false; // start slow and on edge for survival 
  
  RenBairdSnake(int x, int y) {
    super(x, y, "RenBairdSnake");
    this.updateInterval = 350; // slow start
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    if (!pointMode && (millis() > 90000 || snakes.size() <= 5)) { // if time is 90 seconds or less OR number of snakes is less than/ equal to 5 change strat
      pointMode = true;
      this.updateInterval = 150; // faster speed, no longer playing edge
    }
    
    PVector head = this.segments.get(0);
    PVector dir = null;
    
    if (pointMode) { // prioritize food for points, instead of survival
      Food closeFood = getCloseFood(this, food);
      if (closeFood == null) return;
    
      float dx = closeFood.x - head.x;
      float dy = closeFood.y - head.y; // how close is the food
    
      if (dx > dy) { // directions
        if (dx > 0) {
          dir = new PVector(1, 0);
        } else if (dx < 0) {
          dir = new PVector(-1, 0);
        } else if (dy > 0) {
          dir = new PVector(0, 1); 
        } else if (dy < 0) {
        dir = new PVector(0, -1);
        }
      } else {
        dir = border(head);
      }

      if (dir == null) return;
      
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      if (edgeDetect(newPos) || overlap(newPos, snakes)) { // trigger safer logic
        dir = safer(head, snakes);
        if (dir == null) return;
      }
    
      setDirection(dir.x, dir.y);
  } else {
    dir = border(head);
    if (dir != null) {
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
        setDirection(dir.x, dir.y);  // trigger border logic
      }
    }
  }
  }
  
  // border avoidance logic
  PVector border(PVector head) {
    PVector[] options = {
      new PVector(1, 0),
      new PVector(0, 1),
      new PVector(-1, 0),
      new PVector(0, -1)
    };
    
    for (int i = 0; i < options.length; i++) {
      float x = head.x + options[i].x;
      float y = head.y + options[i].y;
      if (!edgeDetect(new PVector(x, y))) {
        return options[i];
        }
    }
    
    return null;
  }
  
  // snake avoidance logic
  PVector safer(PVector head, ArrayList<Snake> snakes) {
    PVector[] options = {
      new PVector(1, 0),
      new PVector(0, 1),
      new PVector(-1, 0),
      new PVector(0, -1)
    };

    for (int d = 0; d < options.length; d++) {
      float x = head.x + options[d].x;
      float y = head.y + options[d].y;
      PVector check = new PVector(x, y);
      if (!edgeDetect(check) && !overlap(check, snakes)) {
        return options[d];
      }
    }

    return null;
  }

  // food logic
  Food getCloseFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closeFood = null;
    
    PVector head = snake.segments.get(0);
  
    for (int i = 0; i < food.size(); i++) { // every piece of food
      Food currentFood = food.get(i);
  
      PVector pos = new PVector(currentFood.x, currentFood.y);
  
      float distance = PVector.dist(head, pos);
  
      if (distance < min) {
        min = distance;
        closeFood = currentFood;
      }
    }
    return closeFood;
  }
  
  // snake apperance
  void drawSegment(int index, float x, float y, float size) {
    push();
    float s = map(index, 0, this.segments.size(), size, size-4);
    
    // Color of background for camouflage 
    color c = get(int(x), int(y));
    stroke(1);
    fill (c);
    rect(
      x,
      y,
      s,
      s,
      6  // Fixed roundness
      );
      pop();
  }
}
