/*For my snake, I am relying on a slower, safer strategy. The method for finding food is the same as demonstrated in class, but I adjusted the 
food that the snake would choose to locate. I made it so that it would only look for food closer to the center of the screen, thus allowing it to avoid
running off the screen. I also changed how it would go down the list to find the closest food--instead of going down every food in the array, it goes down every other food--this
prevents the snake from turning too close into itself.
Also, for every 10 points, the update interval would grow, and the speed decrease. This often makes it less likely for the snake to run into another snake in my tests as it grows larger,
and makes it more likely for another snake to run into it.
*/


class LaurenCogbillSnake extends Snake {
  LaurenCogbillSnake(int x, int y) {
    super(x, y, "LaurenCogbillSnake");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
               
        PVector head = this.segments.get(0);
        
        int speedChange = 1;
        
                
        PVector dir = null;
                
         Food closestFood = getClosestFood(this, food);
         float dx = closestFood.x - head.x;
        float dy = closestFood.y - head.y;

        if(dx>0){
          dir = new PVector(1, 0);
        } else if(dx<0){
          dir = new PVector(-1,0);
        }else if(dy>0){
          dir = new PVector(0,1);
        }else if (dy<0){
        dir = new PVector(0,-1);
        }
        
        if(this.score - 10 > speedChange){
          updateInterval = updateInterval+1;
          speedChange = this.score;
          println(speedChange); //slows down for every 10 points
        }
        
   
        PVector newPos = new PVector(head.x +dir.x, head.y + dir.y);

        setDirection(dir.x, dir.y);

    }

Food getClosestFood(Snake snake, ArrayList<Food> food){
  float min = 1000;
  Food closestFood = null;
  PVector head = snake.segments.get(0);
  
  for(int i = 0; i< food.size(); i = i + 2){ //Does not necessarily select closest food, but skips every other food in the array
    Food currentFood = food.get(i);
    
    PVector pos = new PVector(currentFood.x, currentFood.y);
    
    float distance = PVector.dist(head, pos);
    
    if(distance < min && currentFood.x < 1905 && currentFood.x> 5 && currentFood.y > 5 && currentFood.y < 1095){ //only selects food closer to the center, preventing snake from going offscreen
      min=distance;
      closestFood = currentFood;
    }
  }
  return closestFood;
}

}
