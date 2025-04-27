
class ArielLagunasSnake extends Snake {
  ArielLagunasSnake(int x, int y) {
    super(x, y, "ArielLagunas");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    //preferred directions toward food
    PVector dirX;
    if (dx > 0) {
      dirX = new PVector(1, 0); //move right
    } else if (dx < 0) {
      dirX = new PVector(-1, 0); //move left
    } else {
      dirX = null; //already aligned horizontally
    }

    PVector dirY;
    if (dy > 0) {
      dirY = new PVector(0, 1); //move down
    } else if (dy < 0) {
      dirY = new PVector(0, -1); //move up
    } else {
      dirY = null; //already aligned vertically
    }

    PVector[] preferredDirs = { dirX, dirY };

    //all possible directions
    PVector[] allDirs = {
      new PVector(1, 0), new PVector(-1, 0),
      new PVector(0, 1), new PVector(0, -1)
    };

    //try getting the food first
    for (PVector dir : preferredDirs) {
      if (dir != null) {
        PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
        if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
          setDirection(dir.x, dir.y);
          return;
        }
      }
    }

    //If preferred direction is blocked, find a safe alternative
    for (PVector dir : allDirs) {
      if (dir != null) {
        PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
        if (!edgeDetect(newPos) && !overlap(newPos, snakes)) {
          setDirection(dir.x, dir.y);
          return;
        }
      }
    }

    //fallback: do nothing, you are cooked   = _ =
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
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

  void drawSegment(int index, float x, float y, float size) {
    float t = millis();
    for (int i = 100; i < height - 100; i++) { 
      fill(127 + 128 * sin(i * .02 + t * .002),  //rainbow snake!
        127 + 128 * sin(i * .02 + t * .003),
        127 + 128 * sin(i * .02 + t * .006));
    }
    noStroke();
    rect(x, y, size, size, 5);
  }
}
