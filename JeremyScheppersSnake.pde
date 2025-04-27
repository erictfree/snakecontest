
class JeremyScheppersSnake extends Snake {
  JeremyScheppersSnake(int x, int y) {
    super(x, y, "JeremyScheppers");
  }

  // Remember all think() has to do is set a direction
  // with setDirection()
  //
  // you are passing setDirection:
  // Move left: setDirection(-1, 0);
  // Move right: setDirection(1, 0);
  // Move up: setDirection(0, -1);
  // Move down: setDirection(0, 1);
  //

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); // get the front of the snake, the head

    float dx = closestFood.x - head.x;  // figure out how far the food is
    float dy = closestFood.y - head.y;  // in x and y distances

    // dir represents the direction we are going to move in N/S/E/W
    PVector dir = null;

    // check to see if snake needs to left or right until in same column as food
    // then check to see if it needs to go up or down
    // note: this is a totally arbitrary way to go about it, you may want to do it
    // differently--say prefer y direction first, or randomly favor x or you
    // or use the one that is closest.

    if (dx > 0) {
      dir = new PVector(1, 0);
    } else if (dx < 0) {
      dir = new PVector(-1, 0);
    } else if (dy > 0) {
      dir = new PVector(0, 1);
    } else if (dy < 0) {
      dir = new PVector(0, -1);
    }

    //newPos represents the actual grid location we want to move in
    // say the snake head is grid location (20, 31), if
    // dir is (-1, 0), meaning we want to move left, then
    // newPos would be (20+dir.x, 31+dir.y) or (19, 31)
    //
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    if (edgeDetect(newPos) || overlap(newPos, snakes)) {  // direction hits a wall or snake
      // what do we do? this is your strategy of how you handle this
    }

    // right now we plow ahead, ignoring if we are going to hit something
    // a first step might be to just randomly choose any other direction
    // or you could loop until you've found a safe direction, etc.
    setDirection(dir.x, dir.y);
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
