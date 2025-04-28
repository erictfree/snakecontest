
class EllaBagbySnake extends Snake {
  EllaBagbySnake(int x, int y) {
    super(x, y, "EllaBagby");
    //debug=true;
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);

    PVector head = this.segments.get(0);

    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    
    //these if statements move the snake to the direction of the closest food - setting the direction relative to the position of the closest food
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
    
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    
    if(edgeDetect(newPos)) { //hitting a wall
      dir = new PVector(1, 0);//picking a random direction and hoping for the best, although the collision detection intelligence is already set
    }
    
    if(overlap(newPos, snakes)) { //hitting another snake
      dir = new PVector(0, 1); //picking a random direction and hoping for the best
    }
    
    setDirection(dir.x, dir.y);
    
  }

  Food getClosestFood (Snake snake, ArrayList<Food> food) {
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
}
