
class ReginaAvilaSnake extends Snake { // constructor that sets everything up
  ReginaAvilaSnake (int x, int y) {
    super(x, y, "ReginaAvilaSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    PVector head = this.segments.get(0);
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    PVector dir = null;
    
    // if the food is a certain direction then we move that direction.
    if(dx > 0) {
      dir = new PVector(1, 0);
    } else if (dx < 0) {
      dir = new PVector(-1, 0);
    } else if (dy > 0){
      dir = new PVector(0, -1);
    } else if (dy < 0){
      dir = new PVector(0, -1);
    }
    
    PVector newPos = new PVector(head.x +dir.x, head.y + dir.y);
     
    if (edgeDetect(newPos)) {
    }
    
    if (overlap(newPos, snakes)) {
    }
    
    setDirection(dir.x, dir.y);
    
  }
  
  
  Food getClosestFood(Snake snake, ArrayList<Food> food) {
   float min = 1000;
   Food closestFood = null;
  // Pick a random direction from all possibilities
   PVector head = snake.segments.get(0);
  
  // going through every piece of food
   for(int i = 0; i < food.size(); i++) {
      Food currentFood = food.get(i); // get food
    
    
      PVector pos = new PVector(currentFood.x, currentFood .y);
    
      float distance = PVector.dist(head,pos);
    
    // when we get a piece of food that is closest than others, it becomes the closest food.
      if(distance <min) {
        min = distance;
        closestFood = currentFood ;
      }
    }
    
    // when food is close then the snake speeds up to get it.
    if (min < 5) {
      updateInterval = 60;
    } else {
      updateInterval = 100;
    }
    
    return closestFood;
  }
  // overrides the drawsegment in snake and draws the snake to become blue
  void drawSegment(int index, float x, float y, float size) {
    push();
    colorMode(HSB, 360, 255, 255);
    ellipseMode(CORNER);

    // Use a fixed hue sat and brightness
    float hue = 210;
    float sat = map(index, 0, this.segments.size(), 200, 255); // saturation changes
    float bright = map(index, 0, this.segments.size(), 180, 255); // dark to light

    float s = map(index, 0, this.segments.size(), size, size - 5);

    fill(hue, sat, bright);
    noStroke();
    ellipse(
      x,
      y,
      s,
      s);
  pop();
  }
}
 
