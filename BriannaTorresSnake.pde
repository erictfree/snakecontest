// BriannaTorresSnake class - For my snake's strategy, its priority is to always find the closest food around the map to get bigger in the safest way by having multiple attempts to find a new safe direction if near an area of collision or danger.

class BriannaTorresSnake extends Snake {
  BriannaTorresSnake(int x, int y) {
    super(x, y, "BriannaTorres");
  }

  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    
    PVector head = this.segments.get(0); //gets head of snake
    Food foodTarget = findFoodTarget(this, food);     //for the closest food target
   PVector dir = null;  //default storing for direction which is later changed
    
  if (foodTarget != null) {  // when my snake finds food
    float dx = foodTarget.x - head.x; //x position difference
    float dy = foodTarget.y - head.y; // y position difference
     //direction change based on food position   
    if (dx > 0) {
      dir = new PVector(1,0); //right
    } else if (dx < 0) {
      dir = new PVector(-1,0); //left
    } else if (dy > 0) {
      dir = new PVector(0,1); //down
    } else if (dy < 0) {
      dir = new PVector(0,-1); //up
    }
        
    if(dir != null) { //if its a safe direction
    PVector head2 = new PVector(head.x + dir.x, head.y + dir.y); //next position/direction
 //checks if the new direction is safe of wall or other snakes
    if (!edgeDetect(head2) && !overlap(head2, snakes)) {// checks for collision with another snake or wall
      setDirection(dir.x,dir.y); //moves to that direction
    } else {
      newSafeDirection(); //looks for a new safe direction if it can't detect one
    }  
  }
 }
}
void newSafeDirection()
{
  
  PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };
    int attempts = 0; //sets limit
    PVector newDir = null; //default for storing
    while (newDir == null && attempts < 10) { //only has ten attempts to trying and find a safe random direction (added limit to avoid a recursion loop)
    newDir = possibleDirs[(int)random(possibleDirs.length)]; //random direction
    PVector head3 = new PVector(this.segments.get(0).x + newDir.x, this.segments.get(0).y + newDir.y);
    if (!edgeDetect(head3) && !overlap(head3, snakes))// checks for collision with another snake or wall
     {
    setDirection(newDir.x, newDir.y); //next direction
     } else {
     newDir = null; //trys again if not safe
     attempts++; //adds an attempt
}
}
}



Food findFoodTarget (Snake snake, ArrayList<Food> food) //for finding food near the head
{
  float max = Float.MAX_VALUE; //sets the farthest distance it can go
  Food closest = null; //for storing closest food
  PVector head = snake.segments.get(0); //snake head
  
  for (int i = 0; i < food.size();i++)
  {
    Food curFood = food.get(i); //current food 
    
    PVector pos = new PVector(curFood.x,curFood.y); //position of current food
    float dis = PVector.dist(head,pos); //tries finding the distance to the next food close by 
    
    if (dis < max) {
      max = dis; //adds to the max distance
      closest = curFood; //makes the closest food now the current for next target
    }
  }
  return closest;
}
boolean overlap(PVector head2, ArrayList<Snake> snakes) { //checks to avoid with other snake's body
  for (Snake s : snakes) 
  {
    for (int i = 1; i < s.segments.size(); i++) //checks all body segments
    {
      PVector bodySegment = s.segments.get(i); //for poosition on where that body segment is
      if (bodySegment.x == head2.x && bodySegment.y == head2.y) { //if the head position is why the body is it returns true
        return true;
      }
    }
  }
return false; //no detection 
}
void drawSegment(int index, float x, float y, float size) {
  push();
  fill(#FFC5D3); //light pink
  ellipseMode(CORNER);
  ellipse(x,y,size,size);
  pop();
  }
}
