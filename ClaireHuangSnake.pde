/* Strategy - quickly move to secure food before the other snakes and get as long as possible (greedy closest-food chaser)
Do this while maneuvering around other snakes and avoiding collision with the walls by testing each position for its safety */

class ClaireHuangSnake extends Snake {
  ClaireHuangSnake(int x, int y) {
    super(x, y, "ClaireHuangSnake");
    updateInterval = 70;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    PVector dir = null;

    if (dx > 0) { // food is to the right of the snake
      dir = new PVector(1, 0);
    } else if (dx < 0) { // food to left
      dir = new PVector(-1, 0);
    } else if (dy > 0) { // food below
      dir = new PVector(0, 1);
    } else if (dy < 0) { // food above
      dir = new PVector(0, -1);
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y); // next position that snake head will be in

    PVector[] directions = { // define all possible directions
      new PVector(1, 0), // right
      new PVector(-1, 0), // left
      new PVector(0, 1), // down
      new PVector(0, -1)  // up
    };

    if (edgeDetect(newPos)) { // hit a wall
      for (PVector d : directions) {
        PVector testPos = new PVector(head.x + d.x, head.y + d.y); // temporary position to check for collision
        if (!edgeDetect(testPos)) { // tests temporary position for any walls
          setDirection(d.x, d.y); // sets direction if safe
          return;
        }
      }
      return;
    }

    if (overlap(newPos, snakes)) { // hit a snake
      for (PVector d : directions) {
        PVector testPos = new PVector(head.x + d.x, head.y + d.y); // temporary position to check for collision
        if (!overlap(testPos, snakes)) { // tests temporary position for overlap
          setDirection(d.x, d.y); // sets direction if safe
          return;
        }
      }
      return;
    }

    setDirection(dir.x, dir.y);
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0); // gets the head of the snake

    for (int i = 0; i < food.size(); i++) { // goes through every piece of food
      Food currentFood = food.get(i);

      PVector pos = new PVector(currentFood.x, currentFood.y); // makes PVector for food

      float distance = PVector.dist(head, pos); // finds distance between head and closest food

      if (distance < min) { // figures out closest food
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB);
    rectMode(CORNER);
    float c = map(index, 0, this.segments.size(), 0, 255);
    float s = map(index, 0, this.segments.size(), size+5, size-5);
    fill(255, c, 255);
    rect(x, y, s, s, 10);
    pop();
  }
}
