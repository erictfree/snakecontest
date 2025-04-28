// SimpleSnake class - moves randomly with no intelligence

class KylaPatelSnake extends Snake {
  KylaPatelSnake(int x, int y) {
    super(x, y, "KylaPatelSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    PVector dir = null;

    //move to food
    if (dx > 0) {
      dir = new PVector(1,0);
    } else if (dx < 0) {
      dir = new PVector(-1,0);;
    } else if (dy < 0) {
      dir = new PVector(0,1);;
    } else if (dy > 0) {
      dir = new PVector(0,-1);;
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);

    //if (edgeDetect(newPos)){//hit wall

    // }

    // if (overlap(newPos, snakes)) {

    // }

    setDirection(dir.x, dir.y);
  }

  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    PVector head  = snake.segments.get(0);

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
