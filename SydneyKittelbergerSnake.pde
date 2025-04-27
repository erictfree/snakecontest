//EXPLAINATION OF STRATEGY:
//For my snake, my main strategy is to avoid snakes and the wall. When my snake encounters an enemy or wall, it will cycle through directions,
//finding the one that avoids the collision and is closest to food. In addition, when getting closer to food, my snake will slightly speed up.
//I also added a rainbow pattern to my snake to make it slightly cooler than it was as a solid color. 

class SydneyKittelbergerSnake extends Snake {
  SydneyKittelbergerSnake(int x, int y) {
    super(x, y, "SydneyKittelbergerSnake");
    this.updateInterval = 100; //Default is 100
  }

  //Define All Possible Directions
  void think(ArrayList<Food> food, ArrayList<Snake> snakes) {
    PVector[] possibleDirs = {
      new PVector(1, 0), // Right
      new PVector(-1, 0), // Left
      new PVector(0, 1), // Down
      new PVector(0, -1)   // Up
    };
    
    //Locate the Closest Food
    Food closestFood = getClosestFood(this, food);
    PVector head = this.segments.get(0);
    float dx = closestFood.x - head.x; 
    float dy = closestFood.y - head.y;
    
    //Set the Direction in Order to Move Snake Closer to Food
    PVector dir = null;
    if (dx > 0)
    {
      dir = new PVector(1,0); 
    }
    else if (dx < 0)
    {
      dir = new PVector(-1,0);  
    }
    if (dy < 0)
    {
      dir = new PVector(0,-1); 
    }
    else if (dy > 0)
    {
      dir = new PVector(0,1); 
    }
    
    //Setup for Main Strategy 
    PVector newPos = new PVector(head.x + dir.x, head.y + dir.y);  //Position on Grid  
    PVector bestDir = dir; //Stores Best Direction
    float currentDis; //Current Distance
    float bestDis = 1000; //Basepoint for Best Distance
    
    if (edgeDetect(newPos) || overlap(newPos, snakes)) //Hit a Wall or Hit a Snake
    {
      PVector oppositeDir = new PVector((dir.x)*(-1), (dir.y)*(-1)); //Variable for Opposite Direction of Current Movement
      
      for (int i=0; i<3; i++) //Cycle Through Possible Directions Array
      {
        PVector testDir = possibleDirs[i];
        PVector testPos = new PVector(head.x + testDir.x, head.y + testDir.y);
        //Test New Position to Determine If Any Collisions Occur
        if (!edgeDetect(testPos) && !overlap(testPos, snakes))
        {
          if (testDir != oppositeDir) //Prevent 180 Degree Turns
          {
            currentDis = abs(closestFood.x - head.x) + abs(closestFood.y - head.y); //Determine Current Distance
            if (currentDis < bestDis) //Determine if Current Distance is the Closest to Food
            {
              //Set Variables
              bestDis = currentDis;
              bestDir = testDir;
            }
          }
        }
      }
    }
    setDirection(bestDir.x, bestDir.y); //Set Snake's Direction
    
    //Speed Snake Up When Approaching Food
    float min = 1000;
    if (min < 5)
    {
      updateInterval = 60;  
    }
    else
    {
      updateInterval = 100; 
    }

  }
  
  
  //Create Rainbow Pattern on the Snake
  void drawSegment(int index, float x, float y, float size) 
  {
    colorMode(HSB);
    rectMode(CORNER);
    int c = int(map(index, 0, this.segments.size(), 0 ,255));
    float s = map(index, 0, this.segments.size(), size, size-5);
    noStroke();
    fill(c, 255, 255);
    rect(x, y, size, size, s);
  }

}

//Method to Determine Closest Food
Food getClosestFood(Snake snake, ArrayList<Food> food)
{
  float min = 1000;
  Food closestFood = null;
  PVector head = snake.segments.get(0);
  
  for (int i=0; i<food.size(); i++) //Going through location of every piece of food
  {
    Food currentFood = food.get(i);
    PVector foodPos = new PVector (currentFood.x, currentFood.y);
    float distance = PVector.dist(head, foodPos);
    
    if (distance < min)
    {
      min = distance;
      closestFood = currentFood;
    }
  }
  return closestFood;
}
