// RinNishiwakiSnake class - moves very slowly and chases for food

class RinNishiwakiSnake extends Snake {
  RinNishiwakiSnake(int x, int y) {
    super(x, y, "RinNishiwakiSnake");
    updateInterval = 2000; // me being slow
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
   Food closestFood = getClosestFood(this, food);
   
   PVector head = this.segments.get(0);
   
   float dx = closestFood.x - head.x;
   float dy = closestFood.y - head.y;
   
   if (dx > 0){
     setDirection(1,0);
   } else if (dx < 0) {
     setDirection(-1,0);
   } else if (dy < 0) {
     setDirection(0,-1);
   } else if (dy > 0){
     setDirection(0,1);
   }
 }
  
  Food getClosestFood(Snake snake, ArrayList<Food> food) { // method to get the closest food
    float min = 1000;
    Food closestFood = null;
  
    PVector head = snake.segments.get(0); // use this to compare distance of this to food
  
    for(int i = 0; i < food.size(); i++){ // go through every piece of food
      Food currentFood = food.get(i);
    
      PVector pos = new PVector(currentFood.x, currentFood.y);
    
      float distance = PVector.dist(head, pos);
    
      if (distance < min) { // reset which one is the closest one as the snake moves
        min = distance;
        closestFood = currentFood;
      }
    }
    return closestFood;
  }
 
}
