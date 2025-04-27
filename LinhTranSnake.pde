// SimpleSnake class - moves randomly with no intelligence

class LinhTranSnake extends Snake {
  LinhTranSnake(int x, int y) {
    super(x, y, "LinhTranSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);


    // Define all possible directions: right, left, down, up
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;

    PVector dir = null;

    if (dx > 0)
    {
      dir = new PVector(1, 0);
    } else if (dx < 0)
    {
      dir = new PVector(-1, 0);
    } else if (dy > 0)
    {
      dir = new PVector(0, 1);
    } else if (dy < 0)
    {
      dir = new PVector(0, -1);
    }

    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);



    if (edgeDetect(newPos))
    {
      if (dx > 0)
      {
        setDirection(1, 0);
      } 
      else if (dx < 0)
      {
        setDirection(-1, 0);
      } 
      else if (dy > 0)
      {
        setDirection(0, 1);
      } 
      else if (dy < 0)
      {
        setDirection(0, -1);
      }
    }

    setDirection(dir.x, dir.y);

    if (overlap(newPos, snakes))
    {
      PVector newDir = possibleDirs[(int)random(possibleDirs.length)];
      setDirection(newDir.x, newDir.y);
    }
  }

  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB);
    int c = int(map(index, 0, this.segments.size(), 0, 255));
    stroke(c, 255, 255);
    fill(0);
    rect(x, y, size, size, 5);
    pop();
  }
  Food getClosestFood(Snake snake, ArrayList<Food> food) {

  float min = 1000;
  Food closestFood = null;
  PVector head = snake.segments.get(0);

  for (int i = 0; i < food.size(); i++)
  {
    Food currentFood = food.get(i);

    PVector pos = new PVector(currentFood.x, currentFood.y);

    float distance = PVector.dist(head, pos);

    if (distance < min)
    {
      min = distance;
      closestFood = currentFood;
    }
  }
  return closestFood;
}
}
