
class LanaNguyenSnake extends Snake {
  LanaNguyenSnake(int x, int y) {
    super(x, y, "LanaNguyenSnake");
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
      dir = new PVector (-1, 0);
    }  else if (dy > 0) {
      dir = new PVector(0, 1);
    } else if (dy < 0) {
      dir = new PVector(0, -1);
    }
    
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
    
    if (edgeDetect(newPos)) { //hit wall
      
    }
    
    if (overlap(newPos, snakes)) { //hit snake
      
    }
    
    
    setDirection(newPos.x, newPos.y);
  }
  
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0);
  
    for(int i = 0; i < food.size(); i++) { //every piece of food
      Food currentFood = food.get(i);
      
      PVector pos = new PVector(currentFood.x, currentFood.y);
      
      float distance = PVector.dist(head, pos);
      
      if(distance < min) {
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
}
