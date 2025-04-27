/*
I don;t really have a strategy for my snake. The onyl thing I did add was making it 
go slightly slower than the other snakes, I'm hoping it'll be like a tortoise 
and the hare situation. Other than that it is a very simple snake with no tricks 
up it's sleeves.
*/

//int updateInterval;

class JocelynePartidaSnake extends Snake {
  JocelynePartidaSnake(int x, int y) {
    super(x, y, "JocelynePartidaSnake");
    updateInterval = 140;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    PVector direction = null;
    if (dx > 0) {
      direction = new PVector(1, 0);
    } else if (dx < 0) {
      direction = new PVector(-1, 0);
    } else if (dy > 0) {
      direction = new PVector(0, 1);
    } else if (dy < 0) {
      direction = new PVector(0, -1);
    }

    PVector newPos = new PVector(head.x + direction.x, head.y + direction.y);
    if (edgeDetect(newPos)) {
      direction = new PVector(1, 0);
     
    }

    if (overlap(newPos, snakes)) {
      setDirection(random(direction.x), random(direction.y));
    }
    setDirection(direction.x, direction.y);
  }

  void drawSegment(int index, float x, float y, float size) {
    fill(176, 5, 68);
    float s = map(index, 0, this.segments.size(), size, size-4);
    rect(
      x,
      y,
      s,
      s,
      5  // Fixed roundness
      );
  }
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
  float min = 1000;
  Food closestFood = null;
  PVector head = snake.segments.get(0);

  for (int i = 0; i < food.size(); i++) {
    Food currentFood= food.get(i);

    PVector pos = new PVector (currentFood.x, currentFood.y);

    float distance = PVector.dist(head, pos);

    if (distance < min) {
      min = distance;
      closestFood = currentFood;
    }
  }

  return closestFood;
}
}
