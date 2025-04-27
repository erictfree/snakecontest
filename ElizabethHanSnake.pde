// SimpleSnake class - moves randomly with no intelligence

class ElizabethHanSnake extends Snake {
  ElizabethHanSnake(int x, int y) {
    super(x, y, "ElizabethHanSnake");
  }

void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
        
      PVector head = this.segments.get(0);
      
      float dx = closestFood.x - head.x; 
      float dy = closestFood.y - head.y;
      
      PVector dir = null;
      
      if (dx > 0) {
        dir = new PVector(1, 0); //move to the right if food is closest that way
      } else if (dx < 0) {
        dir = new PVector(-1, 0); //move to the left if food is closest that way
      } else if (dy > 0) {
        dir = new PVector(0, 1);//move up if food is closest that way
      } else if (dy < 0) {
        dir = new PVector(0, -1);//move down if food is closest that way
      } 
      
      PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);
      
      
      //check for wall collision
      if (edgeDetect(newPos)) { //hit a wall
        println("hit wall!");
        if (newPos.x < 0 || newPos.x >= width/GRIDSIZE || newPos.y < 0 || newPos.y >= height/GRIDSIZE) {
          
          //change direction to avoid collision
          dir = new PVector(random(-1, 1), random(-1, 1)); //random new direction
          newPos = new PVector(head.x + dir.x, head.y + dir.y); //update position
        
  }
      
      }
      
      //check for snake collision
      if (overlap(newPos, snakes)) { //hit a snake
        println("hit snake!");
          
          dir = new PVector(random(-1, 1), random(-1, 1)); //random new direction
          newPos = new PVector(head.x + dir.x, head.y + dir.y); //update position

      }
      
      setDirection(dir.x, dir.y);
      //setDirection(1, 0);
}

Food getClosestFood(Snake snake, ArrayList<Food> food) {
  float min = 1000;
  Food closestFood = null;
  PVector head = snake.segments.get(0);
  
  for (int i = 0; i < food.size (); i++) { //every piece of food
    Food currentFood = food.get(i);
    
    PVector pos = new PVector(currentFood.x, currentFood.y);
    
    float distance = PVector.dist(head, pos);
    
    if (distance < min) {
      min = distance;
      //println("distance is " + distance);
      closestFood = currentFood;
    }
  }
  return closestFood;
  }

  void drawSegment(int index, float x, float y, float size) {
    push();
    noStroke(); //no stroke
    colorMode(HSB);
    int c = int(map(index, 0, this.segments.size(), 0, 255)); 
    float s = map(index, 0, this.segments.size(), size, size -5); //size decreases
    fill(c, 150, 200);
    rect(
    x,
    y,
    s,
    s
    );
    pop();
  }
}
