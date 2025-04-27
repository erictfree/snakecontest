// This snake searches located nearby food and takes the shortest route
// to that destination. It also has a customized visual appearance.

class DaeYparraguirreSnake extends Snake {
  DaeYparraguirreSnake(int x, int y) {
    super(x, y, "DaeYparraguirre");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0); 

    float dx = closestFood.x - head.x;  
    float dy = closestFood.y - head.y;  

    PVector dir = null;

    if (dx > 0) {
      dir = new PVector(1, 0);
    } else if (dx < 0) {
      dir = new PVector(-1, 0);
    } else if (dy > 0) {
      dir = new PVector(0, 1);
    } else if (dy < 0) {
      dir = new PVector(0, -1);
    }
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
  void drawSegment(int index, float x, float y, float size) {
    colorMode(HSB);
    int c = int(map(index, 0, this.segments.size(), 0, 255));
    fill(c, 255, random(255));
    strokeWeight(2);
    stroke(0);
    rect(
      x,
      y,
      size,
      size,
      5  
      );
  }
}
