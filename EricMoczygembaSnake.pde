// SimpleSnake class - moves randomly with no intelligence

class EricMoczygembaSnake extends Snake {
  EricMoczygembaSnake(int x, int y) {
    super(x, y, "EricMoczygembaSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    
    PVector head = this.segments.get(0);
    
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    
    PVector direction = null;
    
    if ( dx > 0) {
      direction = new PVector(1,0);
    } else if (dx < 0) {
     direction = new PVector(-1,0); 
    } else if (dy > 0) {
      direction = new PVector(0,1);
    } else if (dy < 0) {
      direction = new PVector(0,-1);
    }
    
    PVector newPos = new PVector(head.x + direction.x, head.y, + direction.y);
    
    //if (edgeDetect(newPos)) { // hit a wall
    //  println("hit wall");
    //}
    
    //if (overlap(newPos, snakes)) { // hit a snake
    //  println("hit snake");
    //}
    
    setDirection(direction.x, direction.y);
  }


  Food getClosestFood(Snake snake, ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    PVector head = snake.segments.get(0);
    
    for(int i = 0; i < food.size(); i++) { //every piece of food
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
    fill(mouseX,mouseY,mouseY- mouseX);
    rect(
      x,
      y,
      size,
      size,
      5  // Fixed roundness
      );
  }
}
