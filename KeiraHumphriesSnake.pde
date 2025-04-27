/*My snake is relatively simple, designed to look for food but factor in the edge and other snakes, 
and change direction based on that. When my snake detects an obstacle, it turns away and assigns a new direction.
My snake will also speed up to get closer to food if it is not in its immediate vicinity,
but will move at a normal speed otherwise.*/

class KeiraHumphriesSnake extends Snake {
  KeiraHumphriesSnake(int x, int y) {
    super(x, y, "KeiraHumphriesSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    Food closestFood = getClosestFood(this, food);
    
      PVector head =  this.segments.get(0);
      float dx = closestFood.x - head.x;
      float dy = closestFood.y - head.y;
        
        PVector dir = null;
        if (dx > 0){
          dir = new PVector (1,0);
        }else if (dx < 0){
          dir = new PVector(-1,0);
        }else if (dy < 0){
          dir = new PVector(0, -1);
        }else if (dy > 0){
          dir = new PVector (0, 1);
        }
        
        if (dir == null){
       dir = new PVector (0,1); //just in case there isn't a direction chosen for some reason (I only did this because I was getting a warning on line 30 about dir potentially being null at that location)
     }
        
     if (abs(dx) > 3 || abs(dy) > 3) { //if the snake is far from food
       this.updateInterval = 50; //speed up
     } else{
       this.updateInterval = 100; //otherwise speed is normal
     }
   
     
     PVector newPos = new PVector (head.x + dir.x, head.y + dir.y); //"new position" PVector checks in front of head 
     
     PVector [] altDir = { //array that assigns alt directions to try 
       new PVector(1,0),
       new PVector(-1, 0),
       new PVector(0, 1),
       new PVector(0, -1),
       };        
        
   if (edgeDetect(newPos) || overlap(newPos, snakes)) { //edge-detects in front of the head (newPos called above)
    for (PVector d : altDir){
      PVector altPos = new PVector (head.x + d.x, head.y + d.y);
      if(!edgeDetect(altPos) && !overlap(altPos, snakes)){ //if the new direction both doesn't hit a wall or another snake
          dir = d; //set the original PVector for direction equal to the updated safe one
          newPos = altPos; //set the new position
          break; //breaks the for loop once that new safe direction has been found and assigned
        }
      }
   }           
     setDirection(dir.x, dir.y);
  }


Food getClosestFood(Snake snake, ArrayList<Food> food){
  float min = 1000;
  Food closestFood = null;
  PVector head =  snake.segments.get(0);
  
  for (int i = 0; i < food.size(); i++){ //every piece of food
    Food currentFood = food.get(i);
    
    PVector pos = new PVector(currentFood.x, currentFood.y);
    
    float distance =  PVector.dist(head, pos);
    
    if (distance < min){
      min = distance;
      closestFood = currentFood;
    }
  }
  return closestFood;
  }
}
