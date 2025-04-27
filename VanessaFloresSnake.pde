// My strategy is speed to collect food quick but move a bit slower while not looking for food in order to not rush into other snakes. When my snake detects a wall or other snake I wanted 
// it to go in a random direction to hopefully not die. 

class VanessaFloresSnake extends Snake {
  VanessaFloresSnake(int x, int y) {
    super(x, y, "VanessaFloresSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    
    PVector head = this.segments.get(0);
    
    float dx = closestFood.x - head.x;
    float dy = closestFood.y - head.y;
    
    PVector dir = null;
      if(dx > 0) {
        dir = new PVector(1,0);
      }else if (dx < 0 ) {
        dir = new PVector(-1,0);
      }else if (dy >0) {
        dir = new PVector(0,1);
      }else if(dy < 0) {
        dir = new PVector(0, -1);
  }
  
  PVector newPos =  new PVector (head.x + dir.x, head.y + dir.y);
  
  if(edgeDetect(newPos)) { //hits wall
  println("hitwall");
   PVector[] possibleDirs = {
     new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1) 
  };
  PVector newDir = possibleDirs[(int)random(possibleDirs.length)];
  setDirection(newDir.x, newDir.y);
  }
  
  if(overlap( newPos, snakes)) { //hit snake
  println("hit snake");
  PVector[] possibleDirs = {
     new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1) 
  };
  PVector newDir = possibleDirs[(int)random(possibleDirs.length)];
       setDirection(newDir.x, newDir.y);
  }
    setDirection(dir.x, dir.y);
  
  }
  Food getClosestFood (Snake snake,ArrayList<Food> food) {
    float min = 1000;
    Food closestFood = null;
    
    PVector head = snake.segments.get(0);
     
    for(int i =0; i < food.size(); i++) { //get every food
      Food currentFood= food.get(i);
      
      PVector pos = new PVector(currentFood.x, currentFood.y);
      
      float distance = PVector.dist(head, pos);
      
      if(distance < min) {
        min = distance;
        closestFood = currentFood;
    }
    } 
    
  if (min < 5) {
    updateInterval = 80;
  }else{
    updateInterval = 150;
  }
    
    return closestFood;
  }
  void drawSegment(int index, float x, float y, float size) {
    colorMode(HSB);
     int c = int(map(index, 0, this.segments.size(), 143, 255));
   fill(c, 143, 255);
   noStroke();
   rect(
      x,
      y,
      size,
      size
      //5  // Fixed roundness
      );
}
}
